//
//  SignUpViewController.swift
//  iChat
//
//  Created by Manasa Tipparam on 8/10/15.
//  Copyright (c) 2015 Charles Gong. All rights reserved.
//

import UIKit
import Parse

class SignUpViewController: UIViewController {

    @IBOutlet weak var usernameTF: UITextField!
    @IBOutlet weak var passwordTF: UITextField!
    @IBOutlet weak var confirmPasswordTF: UITextField!
    
    @IBAction func doneButtonPressed(sender: AnyObject) {
        var user = PFUser()
        
        let query = PFUser.query()
        query?.whereKey("username", equalTo: self.usernameTF.text)
        
        var count = query?.findObjects()?.count
        
        if (query?.findObjects()?.count == 0)
        {
            user.username = self.usernameTF.text
        }
        else
        {
            let userExistsAlert = UIAlertView(title: "User already exists!", message: "Try again with a new username", delegate: nil, cancelButtonTitle: "Okay")
            userExistsAlert.show()
            return
        }
        
        if(self.passwordTF.text == self.confirmPasswordTF.text)
        {
            user.password = self.passwordTF.text
            
            user.signUpInBackgroundWithBlock({
                (succeeded: Bool, error: NSError?) -> Void in
                if let error = error {
                    let errorString = error.userInfo?["error"] as? NSString
                } else {
                    
                }
                dispatch_async(dispatch_get_main_queue()) {
                    self.usernameTF.text = ""
                    self.passwordTF.text = ""
                    self.confirmPasswordTF.text = ""
                    let next = self.storyboard?.instantiateViewControllerWithIdentifier("LoginViewController") as! LoginViewController
                    self.presentViewController(next, animated: true, completion: nil)
                }
            })
            
        }
        else
        {
            let passMisMatchAlert = UIAlertView(title: "Passwords do not match!", message: "Please check and try again", delegate: nil, cancelButtonTitle: "Okay")
            passMisMatchAlert.show()
        }
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    


}
