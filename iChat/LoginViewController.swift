//
//  LoginViewController.swift
//  iChat
//
//  Created by Charles Gong on 6/11/15.
//  Copyright (c) 2015 Charles Gong. All rights reserved.
//

import UIKit
import Parse

class LoginViewController: UIViewController {

    @IBOutlet weak var usernameTF: UITextField!
    @IBOutlet weak var passwordTF: UITextField!
    @IBOutlet weak var loginButton: UIButton!
    @IBOutlet weak var signUpButton: UIButton!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view.
    }
    
    override func viewDidAppear(animated: Bool) {
        if(PFUser.currentUser()?.username != nil) {
            self.performSegueWithIdentifier("LoginSegue", sender: nil)
        }
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    @IBAction func loginButtonPressed(sender: UIButton) {
        PFUser.logInWithUsernameInBackground(self.usernameTF.text!, password:self.passwordTF.text!) {
            (user: PFUser?, error: NSError?) -> Void in
            if user != nil {
                self.performSegueWithIdentifier("LoginSegue", sender: nil)
            } else {
                let alert = UIAlertView(title: "Try Again", message: "Please check your login information and try again", delegate: nil, cancelButtonTitle: "Okay")
                alert.show()
            }
        }
    }
    
    @IBAction func signUpButtonPressed(sender: UIButton) {
        let user = PFUser()
        user.username = self.usernameTF.text
        user.password = self.passwordTF.text
        
        user.signUpInBackgroundWithBlock {
            (succeeded: Bool, error: NSError?) -> Void in
            if let error = error {
                _ = error.userInfo["error"] as? NSString
            }
            else {
            }
            dispatch_async(dispatch_get_main_queue()) {
                self.usernameTF.text = ""
                self.passwordTF.text = ""
            }
        }

    }

    @IBAction func viewTapped(sender: UITapGestureRecognizer) {
        self.usernameTF.endEditing(true)
        self.passwordTF.endEditing(true)
    }
    
    
    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepareForSegue(segue: UIStoryboardSegue, sender: AnyObject?) {
        // Get the new view controller using segue.destinationViewController.
        // Pass the selected object to the new view controller.
    }
    */

}
