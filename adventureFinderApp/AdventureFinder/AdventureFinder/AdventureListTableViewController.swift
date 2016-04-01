//
//  AdventureListTableViewController.swift
//  AdventureFinder
//
//  Created by Wayne Bangert on 3/23/16.
//  Copyright © 2016 Wayne Bangert. All rights reserved.
//

import UIKit
import Firebase

class AdventureListTableViewController: UITableViewController {
    
    let ref = Firebase(url: "https://adventurefinder.firebaseio.com/adventures")
    let usersRef = Firebase(url: "https://adventurefinder.firebaseio.com/activeUsers")
    
    var adventures = [AdventureItem]()
    var user: User!
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        ref.observeEventType(.Value, withBlock: { snapshot in
            print(snapshot.value)
            }, withCancelBlock: {error in
                print(error.description)
        })
        
        user = User(uid: "FakeID", email: "looking@for.fun")
        
        tableView.rowHeight = 85.0
        
    }
    

    
    override func viewDidAppear(animated: Bool) {
        super.viewDidAppear(animated)
        
        ref.queryOrderedByChild("completed").observeEventType(.Value, withBlock: { snapshot in
            print(snapshot.value)
            
                var newAdventures = [AdventureItem]()
            
                for adventure in snapshot.children {
                    
                    let adventureItem = AdventureItem(snapshot: adventure as! FDataSnapshot)
                    newAdventures.append(adventureItem)
                }
                self.adventures = newAdventures
                self.tableView.reloadData()
            })
        
        ref.observeAuthEventWithBlock { authData in
            if authData != nil {
                self.user = User(authData: authData)
                
                let currentUserRef = self.usersRef.childByAppendingPath(self.user.uid)
                
                currentUserRef.setValue(self.user.email)
                
                currentUserRef.onDisconnectRemoveValue()
            }
        }
    }
    
    override func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return adventures.count
    }
    
    override func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCellWithIdentifier("AdventureCell") as! AdventureItemTableViewCell
        
        let adventureItem = adventures[indexPath.row]
        
        cell.adventure = adventureItem
        cell.configureView()
        
        return cell
        
    }
    
  
    
    
    @IBAction func addButtonTouched(sender:AnyObject) {
        let alert = UIAlertController(title: "New Adventure", message: "Add an Adventure", preferredStyle: .Alert)
        
        let saveAction = UIAlertAction(title: "Save", style: .Default) { (action: UIAlertAction) -> Void in
            
            let textField = alert.textFields![0]
            let addressTextField = alert.textFields![1]
            
            let adventureItem = AdventureItem(name: textField.text!, addedByUser: self.user.email, key: "", address: addressTextField.text!)
//            let adventureItem = AdventureItem(name: textField.text!, addedByUser: self.user.email, addressTextField.text!)
            
            let adventureItemRef = self.ref.childByAppendingPath(textField.text!.lowercaseString)
            
            adventureItemRef.setValue(adventureItem.toAnyObject())
            
            self.adventures.append(adventureItem)
            self.tableView.reloadData()
        }
        
        let cancelAction = UIAlertAction(title: "Cancel", style: .Default) { (action: UIAlertAction!) -> Void in
        }
        
        alert.addTextFieldWithConfigurationHandler {
            (textField: UITextField!) -> Void in
            textField.placeholder = "Enter Place Name"
        }
        alert.addTextFieldWithConfigurationHandler {
            (addressTextField: UITextField!) -> Void in
            addressTextField.placeholder = "Enter Address"
        }
        
        alert.addAction(saveAction)
        alert.addAction(cancelAction)
        
        presentViewController(alert, animated: true, completion: nil)
        
       
    }
    
    
//    override func prepareForSegue(segue: UIStoryboardSegue, sender: AnyObject?) {
//        var detailItem:AnyObject?
//        
//        let controller = segue.destinationViewController as! AdventureItemViewController
//        
//        if let indexPath = self.tableView.indexPathForSelectedRow {
//            if segue.identifier == "AdventureItemView" {
//                detailItem = adventures(indexPath.row)
//            }
//        }
//    
//        print(detailItem)
//        
//    }

}
