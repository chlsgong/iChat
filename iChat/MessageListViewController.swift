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
    
    var messageListArray: [String] = [String]()

    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view.
        
        self.messageListTableView.delegate = self
        self.messageListTableView.dataSource = self
        
        self.retrieveConvo()
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    func retrieveConvo() {
        var query: PFQuery = PFQuery(className: "Conversations")
        
        query.findObjectsInBackgroundWithBlock { (objects: [AnyObject]?, error: NSError?) -> Void in
            self.messageListArray = [String]()
            
            if let objects = objects as? [PFObject] {
                for convoObject in objects {
                    let recipientUser: String? = (convoObject)["recipientUser"] as? String
                    
                    if recipientUser != nil {
                        self.messageListArray.append(recipientUser!)
                    }
                }
            }
            
            dispatch_async(dispatch_get_main_queue()) {
                self.messageListTableView.reloadData()
            }
        }
    }
    
    func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell {
        let cell = self.messageListTableView.dequeueReusableCellWithIdentifier("MessageListCell") as! UITableViewCell
        cell.textLabel?.text = self.messageListArray[indexPath.row]
        return cell
    }
    
    func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return messageListArray.count
    }


}
