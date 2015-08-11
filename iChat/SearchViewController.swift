//
//  SearchViewController.swift
//  iChat
//
//  Created by Charles Gong on 7/18/15.
//  Copyright (c) 2015 Charles Gong. All rights reserved.
//

import UIKit
import Parse

class SearchViewController: UIViewController, UITableViewDelegate, UITableViewDataSource, UITextFieldDelegate {
    
    @IBOutlet weak var searchUsername: UITextField!
    @IBOutlet weak var doneButton: UIButton!
    @IBOutlet weak var usernameTableView: UITableView!
    
    let searchSegueID = "SearchSegue"
    var userArray:[String]!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view.
        self.usernameTableView.delegate = self
        self.usernameTableView.dataSource = self
        
        self.searchUsername.delegate = self
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }

    @IBAction func doneButtonTapped(sender: UIButton) {
        self.doneButton.enabled = false
        
        var query: PFQuery = PFQuery(className: "_User")
        query.whereKey("username", equalTo: searchUsername.text)
        query.findObjectsInBackgroundWithBlock { (objects: [AnyObject]?, error: NSError?) -> Void in
            self.userArray = [String]()
            
            if let objects = objects as? [PFObject] {
                for userObject in objects {
                    let username: String? = (userObject)["username"] as? String
                    
                    if username != nil {
                        self.userArray.append(username!)
                    }
                }
            }
            
            dispatch_async(dispatch_get_main_queue()) {
                self.usernameTableView.reloadData()
                self.doneButton.enabled = true
            }
        }
    }
    
    override func prepareForSegue(segue: UIStoryboardSegue, sender: AnyObject?) {
        if segue.identifier == searchSegueID {
            if let destination = segue.destinationViewController as? ViewController {
                if let searchIndex =  self.usernameTableView.indexPathForSelectedRow()?.row {
                }
            }
        }
    }
    
    func tableView(tableView: UITableView, didSelectRowAtIndexPath indexPath: NSIndexPath) {
        self.usernameTableView.deselectRowAtIndexPath(indexPath, animated: true)
    }
    
    func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell {
        let cell = self.usernameTableView.dequeueReusableCellWithIdentifier("UsernameCell") as! UITableViewCell
        cell.textLabel?.text = self.userArray[indexPath.row]
        return cell
    }
    
    func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return userArray.count
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
