//
//  InboxViewController.swift
//  Bandit
//
//  Created by Piyoros Vephula on 3/28/16.
//  Copyright © 2016 Piyoros Vephula. All rights reserved.
//

import UIKit
import Parse

class InboxViewController: UIViewController, UITableViewDelegate, UITableViewDataSource {
    
    let user = PFUser.currentUser()!
    var inboxObjects = [PFObject]()
    var selectedUser:PFUser?
    var selectedBand:PFObject?
    var actionType:String?
    var actionStatus:String?
    var joiningBand:PFObject?
    var sendObject:PFObject?
    var willReload = false
    
    @IBOutlet weak var inboxTableView: UITableView!
    
    func getInboxObjects(user: PFUser) -> [PFObject] {
        var objs = [PFObject]()
        //let predicate = NSPredicate(format: "senderUser = \(user)")
        //let query = PFQuery(className: "Inbox", predicate: predicate)
        let userSend = PFQuery(className: "Inbox")
        userSend.whereKey("senderUser", equalTo: user)
        //userSend.includeKey("_User")
        
        let userReceive = PFQuery(className: "Inbox")
        userReceive.whereKey("receiverUser", equalTo: user)
        //userReceive.includeKey("_User")
        
        var ub = [PFObject]()
        let userBandQuery = PFQuery(className: "UserBand")
        userBandQuery.whereKey("user", equalTo: user)
        do{
            ub = try userBandQuery.findObjects()
        }
        catch{
            print("user's band(s) not found")
        }
        var bandsOfUser = [PFObject]()
        for b in ub {
            bandsOfUser.append(b["band"] as! PFObject)
        }
        print("--------------------- bandsOfUser")
        print(bandsOfUser)
        let bandReceive = PFQuery(className: "Inbox") // array of bands
        bandReceive.whereKey("receiverBand", containedIn: bandsOfUser) // we need know know which band user is in.
        
        let query = PFQuery.orQueryWithSubqueries([userSend,userReceive,bandReceive])
        query.includeKey("senderUser")
        query.includeKey("receiverBand")
        //query.includeKey("Band")
        do{
            objs = try query.findObjects()
        }
        catch{
            print("inbox not found")
        }
        return objs
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        print("INBOX!!")
        inboxObjects = getInboxObjects(user)
        print(inboxObjects)
        // Uncomment the following line to preserve selection between presentations
        // self.clearsSelectionOnViewWillAppear = false

        // Uncomment the following line to display an Edit button in the navigation bar for this view controller.
        // self.navigationItem.rightBarButtonItem = self.editButtonItem()
    }
    
    override func viewWillAppear(animated: Bool) {
        self.navigationController?.navigationBar.setBackgroundImage(UIImage(), forBarMetrics: UIBarMetrics.Default)
        self.navigationController?.navigationBar.shadowImage = UIImage()
        self.navigationController?.navigationBar.translucent = true
    }

    override func viewDidAppear(animated: Bool) {
        if willReload == true {
            inboxObjects = getInboxObjects(user)
            inboxTableView.reloadData()
            willReload = false
        }
    }
    
    override func viewDidDisappear(animated: Bool) {
        willReload = true
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }

    // MARK: - Table view data source

    func numberOfSectionsInTableView(tableView: UITableView) -> Int {
        // #warning Incomplete implementation, return the number of sections
        return 1
    }

    func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        // #warning Incomplete implementation, return the number of rows
        return inboxObjects.count
    }


    func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCellWithIdentifier("Inbox Cell") as! InboxCell
        
        if let io = inboxObjects[indexPath.row] as? PFObject {
            
            let s = io["status"] as! String
            
            if io["notificationType"] as? String == "User Joins Band" {
                if io.objectForKey("senderUser") as? PFUser == user {
                    let imageFile = io["receiverBand"].objectForKey("photo") as! PFFile
                    imageFile.getDataInBackgroundWithBlock({
                        (imageData: NSData?, error: NSError?) -> Void in
                        if (error == nil) {
                            cell.img.image = UIImage(data:imageData!)
                        }
                    })
                    
                    let b = io.objectForKey("receiverBand")! as! PFObject
                    let bname = b["bandname"] as! String
                    cell.name.text = bname.uppercaseString
                    
                    if s == "pending" {
                        cell.type.text = "Joining Request Sent"
                        cell.detail.text = "Please wait for the band's decision."
                    }
                    else if s == "confirmed" {
                        cell.type.text = "Confirmed"
                        cell.detail.text = "Congratulations, you have joined \(bname)!"
                    }
                    else if s == "rejected" {
                        cell.type.text = "Rejected"
                        cell.detail.text = "\(bname) rejected your request."
                    }
                    else if s == "cancelled" {
                        cell.type.text = "Cancelled"
                        cell.detail.text = "You cancelled your request."
                    }
                    
                    let dateFormatter = NSDateFormatter()
                    dateFormatter.dateStyle = .ShortStyle
                    cell.date.text = dateFormatter.stringFromDate(io.createdAt!)
                }
                else{

                    let imageFile = io["senderUser"].objectForKey("image") as! PFFile
                    imageFile.getDataInBackgroundWithBlock({
                        (imageData: NSData?, error: NSError?) -> Void in
                        if (error == nil) {
                            cell.img.image = UIImage(data:imageData!)
                        }
                    })
                    cell.img.layer.masksToBounds = false
                    cell.img.layer.cornerRadius = cell.img.frame.size.width/2
                    cell.img.clipsToBounds = true
                    
                    let u = io.objectForKey("senderUser")! as! PFUser
                    let uname = u["fullName"] as! String
                    cell.name.text = uname.uppercaseString
                    
                    if s == "pending" {
                        cell.type.text = "Joining Request Received"
                        cell.detail.text = "Please think about this person."
                    }
                    else if s == "confirmed" {
                        let bn = io.objectForKey("receiverBand")! as! PFObject
                        let bname = bn["bandname"] as! String
                        cell.type.text = "Confirmed"
                        cell.detail.text = "\(uname) has joined your band \(bname)!"
                    }
                    else if s == "rejected" {
                        cell.type.text = "Rejected"
                        cell.detail.text = "You rejected \(uname)'s request."
                    }
                    else if s == "cancelled" {
                        cell.type.text = "Cancelled"
                        cell.detail.text = "\(uname) cancelled the request."
                    }
                    
                    let dateFormatter = NSDateFormatter()
                    dateFormatter.dateStyle = .ShortStyle
                    cell.date.text = dateFormatter.stringFromDate(io.createdAt!)
                }
            }
            else{
                if io.objectForKey("senderUser") as? PFUser == user {
                    let imageFile = io["receiverUser"].objectForKey("image") as! PFFile
                    imageFile.getDataInBackgroundWithBlock({
                        (imageData: NSData?, error: NSError?) -> Void in
                        if (error == nil) {
                            cell.img.image = UIImage(data:imageData!)
                        }
                    })
                    cell.img.layer.masksToBounds = false
                    cell.img.layer.cornerRadius = cell.img.frame.size.width/2
                    cell.img.clipsToBounds = true
                    
                    let u = io.objectForKey("receiverUser")! as! PFUser
                    let uname = u["fullName"] as! String
                    cell.name.text = uname.uppercaseString
                    
                    if s == "pending" {
                        cell.type.text = "Band Invitation Sent"
                        cell.detail.text = "Please wait for recipient's response."
                    }
                    else if s == "confirmed" {
                        let bn = io.objectForKey("senderBand")! as! PFObject
                        let bname = bn["bandname"] as! String
                        cell.type.text = "Confirmed"
                        cell.detail.text = "Congratulations, \(uname) has joined your band, \(bname)!"
                    }
                    else if s == "rejected" {
                        cell.type.text = "Rejected"
                        cell.detail.text = "\(uname) rejected your invitation."
                    }
                    else if s == "cancelled" {
                        cell.type.text = "Cancelled"
                        cell.detail.text = "You cancelled your invitation."
                    }
                    
                    let dateFormatter = NSDateFormatter()
                    dateFormatter.dateStyle = .ShortStyle
                    cell.date.text = dateFormatter.stringFromDate(io.createdAt!)
                }
                else{
                    let imageFile = io["senderBand"].objectForKey("photo") as! PFFile
                    imageFile.getDataInBackgroundWithBlock({
                        (imageData: NSData?, error: NSError?) -> Void in
                        if (error == nil) {
                            cell.img.image = UIImage(data:imageData!)
                        }
                    })
                    
                    let b = io.objectForKey("senderBand")! as! PFObject
                    let bname = b["bandname"] as! String
                    cell.name.text = bname.uppercaseString
                    
                    if s == "pending" {
                        cell.type.text = "Band Invitation Received"
                        cell.detail.text = "Do you want to join this band?"
                    }
                    else if s == "confirmed" {
                        cell.type.text = "Confirmed"
                        cell.detail.text = "Congratulations, you have joined \(bname)!"
                    }
                    else if s == "rejected" {
                        cell.type.text = "Rejected"
                        cell.detail.text = "You rejected \(bname)'s request."
                    }
                    else if s == "cancelled" {
                        cell.type.text = "Cancelled"
                        cell.detail.text = "\(bname) cancelled their request."
                    }
                    
                    let dateFormatter = NSDateFormatter()
                    dateFormatter.dateStyle = .ShortStyle
                    cell.date.text = dateFormatter.stringFromDate(io.createdAt!)
                }
            }
        }

        return cell
    }

    func tableView(tableView: UITableView, didSelectRowAtIndexPath indexPath: NSIndexPath) {
        willReload = true
        if let io = inboxObjects[indexPath.row] as? PFObject {
            if io["notificationType"] as? String == "User Joins Band" {
                if io.objectForKey("senderUser") as? PFUser == user {
                    
                    print("I applied to a band")
                    selectedBand = (io.objectForKey("receiverBand")! as! PFObject)
                    print("********************selectedBand")
                    print(selectedBand)
                    actionType = (io["notificationType"] as! String)
                    actionStatus = (io["status"] as! String)
                    selectedUser = (io.objectForKey("senderUser") as! PFUser)
                    sendObject = io
                    performSegueWithIdentifier("Band Profile", sender: self)
                }
                else{
                    print("A user applied to join my band")
                    selectedUser = (io.objectForKey("senderUser")! as! PFUser)
                    actionType = (io["notificationType"] as! String)
                    actionStatus = (io["status"] as! String)
                    
                    joiningBand = (io["receiverBand"] as! PFObject)
                    sendObject = io
                    performSegueWithIdentifier("Person Profile", sender: self)
                }
            }
            else{//band invites user
                if io.objectForKey("senderUser") as? PFUser == user {
                    print("I sent an invitation to a user")
                    selectedUser = (io.objectForKey("receiverUser")! as! PFUser)
                    actionType = (io["notificationType"] as! String)
                    actionStatus = (io["status"] as! String)
                    joiningBand = (io["senderBand"] as! PFObject)
                    print("********************joiningBand")
                    print(joiningBand)
                    sendObject = io
                    performSegueWithIdentifier("Person Profile", sender: self)
                }
                else{
                    print("A band invited me to join them")
                    selectedBand = (io.objectForKey("senderBand")! as! PFObject)
                    print("********************selectedBand")
                    print(selectedBand)
                    actionType = (io["notificationType"] as! String)
                    actionStatus = (io["status"] as! String)
                    selectedUser = (io.objectForKey("senderUser") as! PFUser)
                    sendObject = io
                    performSegueWithIdentifier("Band Profile", sender: self)
                }
            }
        }
    }
    
    override func prepareForSegue(segue: UIStoryboardSegue, sender: AnyObject?) {
        if segue.identifier == "Person Profile"{
            let personVC = segue.destinationViewController as! ConfirmPersonViewController
            personVC.inboxObject = self.sendObject!
            personVC.user = self.selectedUser!
            personVC.type = self.actionType!
            personVC.status = self.actionStatus!
            if joiningBand != nil {
                personVC.band = joiningBand!
            }
//            else{
//                personVC.band = selectedBand!
//            }
        }
        if segue.identifier == "Band Profile"{
            let bandVC = segue.destinationViewController as! ConfirmBandViewController
            bandVC.inboxObject = self.sendObject!
            bandVC.bandObject = self.selectedBand!
            bandVC.type = self.actionType!
            bandVC.status = self.actionStatus!
            bandVC.senderUser = self.selectedUser!
        }
        if segue.identifier == "Event Profile"{
            //let infoVC = segue.destinationViewController as! SeekPersonInfoViewController
            //infoVC.user = self.user
        }
    }

    /*
    // Override to support conditional editing of the table view.
    override func tableView(tableView: UITableView, canEditRowAtIndexPath indexPath: NSIndexPath) -> Bool {
        // Return false if you do not want the specified item to be editable.
        return true
    }
    */

    /*
    // Override to support editing the table view.
    override func tableView(tableView: UITableView, commitEditingStyle editingStyle: UITableViewCellEditingStyle, forRowAtIndexPath indexPath: NSIndexPath) {
        if editingStyle == .Delete {
            // Delete the row from the data source
            tableView.deleteRowsAtIndexPaths([indexPath], withRowAnimation: .Fade)
        } else if editingStyle == .Insert {
            // Create a new instance of the appropriate class, insert it into the array, and add a new row to the table view
        }    
    }
    */

    /*
    // Override to support rearranging the table view.
    override func tableView(tableView: UITableView, moveRowAtIndexPath fromIndexPath: NSIndexPath, toIndexPath: NSIndexPath) {

    }
    */

    /*
    // Override to support conditional rearranging of the table view.
    override func tableView(tableView: UITableView, canMoveRowAtIndexPath indexPath: NSIndexPath) -> Bool {
        // Return false if you do not want the item to be re-orderable.
        return true
    }
    */

    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepareForSegue(segue: UIStoryboardSegue, sender: AnyObject?) {
        // Get the new view controller using segue.destinationViewController.
        // Pass the selected object to the new view controller.
    }
    */

}
