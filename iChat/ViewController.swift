//
//  ViewController.swift
//  iChat
//
//  Created by Charles Gong on 5/28/15.
//  Copyright (c) 2015 Charles Gong. All rights reserved.
//

import UIKit
import Parse

class ViewController: UIViewController, UITableViewDelegate, UITableViewDataSource, UITextFieldDelegate {

    @IBOutlet weak var messageTableView: UITableView!
    @IBOutlet weak var messageTextField: UITextField!
    @IBOutlet weak var sendButton: UIButton!
    @IBOutlet weak var dockViewHeightConstraint: NSLayoutConstraint!
    @IBOutlet weak var messageNavigationItem: UINavigationItem!
    
    var messageArray: [String] = [String]()
    var recipient: String = ""
    
    var username = PFUser.currentUser()?.username
    var newMessageObject: PFObject = PFObject(className: "Messages")
    var newConvoObject: PFObject = PFObject(className: "Conversations")
    
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view, typically from a nib.
        
        self.messageTableView.delegate = self
        self.messageTableView.dataSource = self
        
        self.messageTextField.delegate = self
        
        self.messageNavigationItem.title = self.recipient
        
        let tapGesture: UITapGestureRecognizer = UITapGestureRecognizer(target: self, action: "tableViewTapped")
        self.messageTableView.addGestureRecognizer(tapGesture)
        
        _ = NSTimer.scheduledTimerWithTimeInterval(0.5, target: self, selector: "retrieveMessages", userInfo: nil, repeats: true)
        
        NSNotificationCenter.defaultCenter().addObserver(self, selector: "keyboardWillShow:", name: UIKeyboardWillShowNotification, object: nil)
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    @IBAction func sendButtonTapped(sender: UIButton) {
        self.sendButton.enabled = false
        
        self.newMessageObject = PFObject(className: "Messages")
        self.newMessageObject["Text"] = self.messageTextField.text! + " -" + self.username!
        self.newMessageObject["User"] = self.username
        self.newMessageObject["recipient"] = self.recipient
        self.newMessageObject.saveInBackgroundWithBlock { (success: Bool, error: NSError?) -> Void in
            if (success) {
                // The object has been saved.
                self.retrieveMessages()
                self.addNewConvo()
            }
            else {
                // There was a problem, check error.description
                NSLog(error!.description)
            }
            
            // Only update UI on the main thread
            dispatch_async(dispatch_get_main_queue()) {
                self.sendButton.enabled = true
                self.messageTextField.text = ""
            }
        }
    }
    
    // Check if recipient is already on conversation list else add them to message list
    func addNewConvo() {
        let query: PFQuery = PFQuery(className: "Conversations")
        query.selectKeys(["recipientUser", "sender"])
        query.findObjectsInBackgroundWithBlock { (objects: [AnyObject]?, error: NSError?) -> Void in
            
            if let objects = objects as? [PFObject] {
                var inConvo: Bool = false
                for convoObject in objects {
                    let recipientUser: String? = (convoObject)["recipientUser"] as? String
                    let sender: String? = (convoObject)["sender"] as? String
                    
                    if ((recipientUser == self.username && sender == self.recipient) || (sender == self.username && recipientUser == self.recipient)) {
                        inConvo = true
                    }
                }
                
                if !inConvo {
                    self.newConvoObject = PFObject(className: "Conversations")
                    self.newConvoObject["recipientUser"] = self.recipient
                    self.newConvoObject["sender"] = self.username
                    self.newConvoObject.saveInBackgroundWithBlock { (success: Bool, error: NSError?) -> Void in
                        if (success) {
                            // The object has been saved.
                            NSLog("\nsuccess")
                        }
                        else {
                            // There was a problem, check error.description
                            NSLog(error!.description)
                        }
                    }
                }
            }

        }
    }
    
    func tableViewTapped() {
        self.messageTextField.endEditing(true)
    }
    
    func retrieveMessages() {
        let query: PFQuery = PFQuery(className: "Messages")
        let recipientAndUser: [String] = [self.username!, self.recipient]
        
        query.whereKey("recipient", containedIn: recipientAndUser)
        query.addAscendingOrder("createdAt")
        
        query.findObjectsInBackgroundWithBlock { (objects: [AnyObject]?, error: NSError?) -> Void in
            self.messageArray = [String]()
            
            if let objects = objects as? [PFObject] {
                for messageObject in objects {
                    let recipientUser: String? = (messageObject)["recipient"] as? String
                    let sender: String? = (messageObject)["User"] as? String
                    
                    if ((recipientUser == self.username && sender == self.recipient) || (recipientUser == self.recipient && sender == self.username)) {
                            let messageText: String? = (messageObject)["Text"] as? String
                    
                            if messageText != nil {
                                self.messageArray.append(messageText!)
                                //println(self.messageArray.count)
                        }
                    }
                    
                    dispatch_async(dispatch_get_main_queue()) {
                        self.messageTableView.reloadData()
                    }
                }
            }
            
        }
        
    }
    
    // MARK: textField Functions
    
    func keyboardWillShow(sender: NSNotification) {
        if let userInfo = sender.userInfo {
            if let keyboardHeight = userInfo[UIKeyboardFrameEndUserInfoKey]?.CGRectValue.size.height {
                
                self.view.layoutIfNeeded()
                UIView.animateWithDuration(0.5, animations: { () -> Void in
                    self.dockViewHeightConstraint.constant = CGFloat(keyboardHeight + 51)
                    self.view.layoutIfNeeded()
                })
                
            }
        }
    }

    func textFieldDidEndEditing(textField: UITextField) {
        self.view.layoutIfNeeded()
        UIView.animateWithDuration(0.25, animations: {
            self.dockViewHeightConstraint.constant = 51
            self.view.layoutIfNeeded()
        })
    }
    
    // MARK: tableView Functions
    
    func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell {
        let cell = self.messageTableView.dequeueReusableCellWithIdentifier("MessageCell") as UITableViewCell!
        cell.textLabel?.text = self.messageArray[indexPath.row]
        return cell
    }
    
    func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return messageArray.count
    }
}

