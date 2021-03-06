//
//  MessageListViewController.swift
//  iChat
//
//  Created by Charles Gong on 7/18/15.
//  Copyright (c) 2015 Charles Gong. All rights reserved.
//

import UIKit
import Parse

class MessageListViewController: UIViewController, UITableViewDelegate, UITableViewDataSource {

    @IBOutlet weak var messageListTableView: UITableView!
    
    let convoSegueID = "ConvoSegue"
    var messageListArray: [String] = [String]()
    
    var username = PFUser.currentUser()?.username

    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view.
        self.messageListTableView.delegate = self
        self.messageListTableView.dataSource = self
        
        _ = NSTimer.scheduledTimerWithTimeInterval(0.5, target: self, selector: "retrieveConvo", userInfo: nil, repeats: true)
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    func retrieveConvo() {
        let query: PFQuery = PFQuery(className: "Conversations")

        query.selectKeys(["sender", "recipientUser"])
        query.addDescendingOrder("createdAt")
        
        query.findObjectsInBackgroundWithBlock { (objects: [AnyObject]?, error: NSError?) -> Void in
            self.messageListArray = [String]()
            
            if let objects = objects as? [PFObject] {
                for convoObject in objects {
                    let recipientUser: String? = (convoObject)["recipientUser"] as? String
                    let sender: String? = (convoObject)["sender"] as? String

                    if(recipientUser == self.username! && sender != nil) {
                        self.messageListArray.append(sender!)
                    }
                    
                    else if (sender == self.username! && recipientUser != nil) {
                        self.messageListArray.append(recipientUser!)
                    }
                }
            }

            dispatch_async(dispatch_get_main_queue()) {
                self.messageListTableView.reloadData()
            }
        }
    }
    
    override func prepareForSegue(segue: UIStoryboardSegue, sender: AnyObject?) {
        if segue.identifier == convoSegueID {
            if let destination = segue.destinationViewController as? ViewController {
                    let indexPath = self.messageListTableView.indexPathForSelectedRow
                
                    let currentCell = self.messageListTableView.cellForRowAtIndexPath(indexPath!) as UITableViewCell!
                    destination.recipient = currentCell.textLabel!.text!
            }
        }
    }
    
    @IBAction func signOutButtonPressed(sender: UIButton) {
        PFUser.logOut()
    }
    
    func tableView(tableView: UITableView, canEditRowAtIndexPath indexPath: NSIndexPath) -> Bool {
        return true
    }
    
    func tableView(tableView: UITableView, commitEditingStyle editingStyle: UITableViewCellEditingStyle, forRowAtIndexPath indexPath: NSIndexPath) {
        if (editingStyle == UITableViewCellEditingStyle.Delete) {
            self.messageListArray.removeAtIndex(indexPath.row)
            self.messageListTableView.reloadData()
        }
    }
    
    func tableView(tableView: UITableView, didSelectRowAtIndexPath indexPath: NSIndexPath) {
        self.messageListTableView.deselectRowAtIndexPath(indexPath, animated: true)
    }
    
    func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell {
        let cell = self.messageListTableView.dequeueReusableCellWithIdentifier("MessageListCell") as UITableViewCell!
        cell.textLabel?.text = self.messageListArray[indexPath.row]
        return cell
    }
    
    func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return messageListArray.count
    }
}
