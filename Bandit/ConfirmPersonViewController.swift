//
//  ConfirmPersonViewController.swift
//  Bandit
//
//  Created by Piyoros Vephula on 3/29/16.
//  Copyright © 2016 Piyoros Vephula. All rights reserved.
//

import UIKit
import Parse
import ParseUI
import AVKit
import AVFoundation

class ConfirmPersonViewController: UIViewController, UITableViewDelegate, UITableViewDataSource{
    
    
    var inboxObject:PFObject?
    var status:String?
    var type:String?
    var band:PFObject?
    
    @IBOutlet var profileTableView: UITableView!
    
    var user:PFUser?
    var instArray = [String]()
    var tappedImage:PFImageView?
    var photoArray = [PFObject]()
    var audioArray = [PFObject]()
    var videoArray = [PFObject]()
    var genreString:String!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        instArray = getInstruments(self.user!)
        genreString = makeStringFromArray(getGenres(self.user!), delim: "•")
        self.photoArray = self.getPhotoObject(self.user!)
        self.audioArray = self.getAudioObject(self.user!)
        self.videoArray = self.getVideoObject(self.user!)
        
        profileTableView.contentInset = UIEdgeInsetsMake(-1.0, 0.0, 0.0, 0.0);
        
        profileTableView.rowHeight = UITableViewAutomaticDimension
        profileTableView.estimatedRowHeight = 160.0
        
    }
    
    override func viewWillAppear(animated: Bool) {
        
        self.navigationController?.navigationBar.setBackgroundImage(UIImage(), forBarMetrics: UIBarMetrics.Default)
        self.navigationController?.navigationBar.shadowImage = UIImage()
        self.navigationController?.navigationBar.translucent = true
        self.tabBarController?.tabBar.hidden = false
    }
    
    override func viewDidAppear(animated: Bool) {
        super.viewDidAppear(animated)
        navigationController?.hidesBarsOnSwipe = true
        
    }
    
    func imageTapped(img: AnyObject) {
        print("imageTapped")
        self.tappedImage = img.view! as! PFImageView
        self.performSegueWithIdentifier("Seek Full Screen Image", sender: self)
    }
    
    func getPhotoObject(user: PFUser) -> [PFObject] {
        var obj = [PFObject]()
        let query = PFQuery(className: "UserPhoto")
        query.whereKey("user", equalTo: user)
        do{
            obj = try query.findObjects()
        }
        catch{
            print("Photo not found")
        }
        return obj
    }
    
    func getAudioObject(user: PFUser) -> [PFObject] {
        var obj = [PFObject]()
        let query = PFQuery(className: "UserAudio")
        query.whereKey("user", equalTo: user)
        do{
            obj = try query.findObjects()
        }
        catch{
            print("Audio not found")
        }
        return obj
    }
    
    func getVideoObject(user: PFUser) -> [PFObject] {
        var obj = [PFObject]()
        let query = PFQuery(className: "UserVideo")
        query.whereKey("user", equalTo: user)
        do{
            obj = try query.findObjects()
        }
        catch{
            print("Video not found")
        }
        return obj
    }
    
    func getInstruments(user: PFUser) -> [String] {
        var instruments = [String]()
        var instrumentsObj = [PFObject]()
        let query = PFQuery(className: "UserInst")
        query.whereKey("user", equalTo: user)
        do{
            instrumentsObj = try query.findObjects()
        }
        catch{
            print("Instrument not found")
        }
        
        for i in instrumentsObj {
            instruments.append(i.objectForKey("instrument") as! String)
        }
        print(instruments)
        return instruments
    }
    
    func getGenres(user: PFUser) -> [String] {
        var genres = [String]()
        var genresObj = [PFObject]()
        let query = PFQuery(className: "UserGenre")
        query.whereKey("user", equalTo: user)
        do{
            
            genresObj = try query.findObjects()
        }
        catch{
            print("Genres not found")
        }
        
        for g in genresObj {
            genres.append(g.objectForKey("genre") as! String)
        }
        return genres
    }
    
    func makeStringFromArray(array: [String], delim: String) -> String {
        var str = ""
        for el in array {
            var d = ""
            if str.characters.count > 0 { d = " \(delim) " }
            str = "\(str)\(d)\(el)"
        }
        return str
    }
    
    func confirmToJoinBand(sender: AnyObject){
        print("confirmToJoinBand")
        let alert = UIAlertController(title: "Confirm", message: "Are you sure to accept this person to your band?", preferredStyle: UIAlertControllerStyle.Alert)
        let ok = UIAlertAction(title: "Yes", style: UIAlertActionStyle.Default, handler: { (action: UIAlertAction) -> Void in
            self.inboxObject!["status"] = "confirmed"
            self.inboxObject!.saveInBackgroundWithBlock({
                (success: Bool, error: NSError?) -> Void in
                if error == nil {
                    print("inbox class saved")
                }else {
                    print(error)
                }
                if success {
                    let userBand = PFObject(className: "UserBand")
                    userBand["user"] = self.user
                    userBand["band"] = self.band
                    userBand.saveInBackgroundWithBlock({
                        (success: Bool, error: NSError?) -> Void in
                        if error == nil {
                            print("inbox class saved")
                        }else {
                            print(error)
                        }
                        if success {
                            self.navigationController?.popViewControllerAnimated(true)
                        }
                    })
                }
            })
        })
        alert.addAction(ok)
        
        let cancel = UIAlertAction(title: "No", style: UIAlertActionStyle.Cancel, handler: { (action: UIAlertAction) -> Void in
            print("Cancel Button Tapped")
            //self.navigationController?.popViewControllerAnimated(true)
        })
        alert.addAction(cancel)
        self.presentViewController(alert, animated: true, completion: nil)
    }
    
    func rejectThisUser(sender: AnyObject){
        print("rejectThisUser")
        
        let alert = UIAlertController(title: "Reject request", message: "Are you sure?", preferredStyle: UIAlertControllerStyle.Alert)
        let ok = UIAlertAction(title: "Yes", style: UIAlertActionStyle.Default, handler: { (action: UIAlertAction) -> Void in
            self.inboxObject!["status"] = "rejected"
            self.inboxObject!.saveInBackgroundWithBlock({
                (success: Bool, error: NSError?) -> Void in
                if error == nil {
                    print("inbox class saved")
                }else {
                    print(error)
                }
                if success {
                   self.navigationController?.popViewControllerAnimated(true)
                }
            })
        })
        alert.addAction(ok)
        
        let cancel = UIAlertAction(title: "No", style: UIAlertActionStyle.Cancel, handler: { (action: UIAlertAction) -> Void in
            print("Cancel Button Tapped")
            //self.navigationController?.popViewControllerAnimated(true)
        })
        alert.addAction(cancel)
        self.presentViewController(alert, animated: true, completion: nil)
    }
    
    func cancelRequest(sender: AnyObject){
        print("cancelRequest")
        let alert = UIAlertController(title: "Cancel invitation", message: "Are you sure?", preferredStyle: UIAlertControllerStyle.Alert)
        let ok = UIAlertAction(title: "Yes", style: UIAlertActionStyle.Default, handler: { (action: UIAlertAction) -> Void in
            self.inboxObject!["status"] = "cancelled"
            self.inboxObject!.saveInBackgroundWithBlock({
                (success: Bool, error: NSError?) -> Void in
                if error == nil {
                    print("inbox class saved")
                }else {
                    print(error)
                }
                if success {
                    self.navigationController?.popViewControllerAnimated(true)
                }
            })
        })
        alert.addAction(ok)
        
        let cancel = UIAlertAction(title: "No", style: UIAlertActionStyle.Cancel, handler: { (action: UIAlertAction) -> Void in
            print("Cancel Button Tapped")
            //self.navigationController?.popViewControllerAnimated(true)
        })
        alert.addAction(cancel)
        self.presentViewController(alert, animated: true, completion: nil)
    }
    
//    func saveInvitation(band: PFObject, u: PFUser) {
//
//        let bandInvite = PFObject(className: "Inbox")
//        bandInvite["notificationType"] = "Band Invites User"
//        bandInvite["senderUser"] = PFUser.currentUser()
//        bandInvite["senderBand"] = band
//        bandInvite["receiverUser"] = u
//        bandInvite["status"] = "pending"
//        bandInvite.saveInBackgroundWithBlock({
//            (success: Bool, error: NSError?) -> Void in
//            if error == nil {
//                print("band invite class saved")
//            }else {
//                print(error)
//            }
//            if success {
//                
//                let alert = UIAlertController(title: "Invitation sent", message: "Please wait for him/her to decide.", preferredStyle: UIAlertControllerStyle.Alert)
//                let ok = UIAlertAction(title: "OK", style: UIAlertActionStyle.Default, handler: { (action: UIAlertAction) -> Void in
//                    self.navigationController?.popViewControllerAnimated(true)
//                })
//                alert.addAction(ok)
//                self.presentViewController(alert, animated: true, completion: nil)
//            }
//        })
//    }
    
    func okActionTapped(action: UIAlertAction) {
        print("Ok Button Tapped")
        self.navigationController?.popViewControllerAnimated(true)
    }
    
    func numberOfSectionsInTableView(tableView: UITableView) -> Int {
        return 4
    }
    
    func tableView(tableView: UITableView, titleForHeaderInSection section: Int) -> String? {
        var title = ""
        
        switch section {
        case 0: title = ""
        case 1: title = "Photo"
        case 2: title = "Audio"
        case 3: title = "Video"
        default: title = "Unknown"
        }
        
        return title
    }
    
    func tableView(tableView: UITableView, heightForHeaderInSection section: Int) -> CGFloat {
        return 0.0
    }
    
    func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        var row = 0
        print("************************")
        print(inboxObject)
        print(status)
        print(type)
        print(band)
        print("************************")
        switch section {
            case 0: row = 1
            case 1: row = 1
            case 2: row = audioArray.count
            case 3: row = videoArray.count
            default: row = 0
        }

        return row
    }
    
    func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell {
        
        if indexPath.section == 0 {
            let cell = tableView.dequeueReusableCellWithIdentifier("Profile") as! ProfileCell!
            let imageFile = user!["image"] as! PFFile
            imageFile.getDataInBackgroundWithBlock({
                (imageData: NSData?, error: NSError?) -> Void in
                if (error == nil) {
                    cell.profileImage.image = UIImage(data:imageData!)
                    cell.coverImage.image = UIImage(data:imageData!)
                }
            })
            
            let name = user!["fullName"] as! String
            
            cell.profileImage.layer.masksToBounds = false
            cell.profileImage.layer.cornerRadius = cell.profileImage.frame.size.width/2
            cell.profileImage.clipsToBounds = true
            
            cell.location.text = (user!["location"] as! String).uppercaseString
            
            cell.instArray = self.instArray
            cell.loadImages()
            
            cell.fullName.text = name
            cell.exp.text = ""
            
            cell.instrument.text = ""
            cell.genre.text = "\(genreString.lowercaseString)"
            
            let bandname = band!["bandname"] as! String
            
            if type == "User Joins Band" { // This user request to join my band
                
                if status == "pending" {
                    
                    let sentence = "Do you want this person to join your band \(bandname)?"
                    
                    let wordRange = (sentence as NSString).rangeOfString(bandname)
                    let attributedString = NSMutableAttributedString(string: sentence, attributes: [NSFontAttributeName : UIFont.systemFontOfSize(20, weight: UIFontWeightThin)])
                    
                    attributedString.setAttributes([NSFontAttributeName : UIFont.systemFontOfSize(20, weight: UIFontWeightBold), NSForegroundColorAttributeName : AppearanceHelper.itemColor()], range: wordRange)
                    
                    cell.confirmDescription.attributedText = attributedString
                    cell.confirmButton.addTarget(self, action: "confirmToJoinBand:", forControlEvents: .TouchUpInside)
                    cell.rejectButton.addTarget(self, action: "rejectThisUser:", forControlEvents: .TouchUpInside)
                    cell.cancelButton.hidden = true
                }
                else if status == "confirmed" {
                    cell.confirmDescription.text = "You accepted \(name) to your band, \(bandname)."
                    cell.confirmButton.hidden = true
                    cell.rejectButton.hidden = true
                    cell.cancelButton.hidden = true
                }
                else if status == "rejected" {
                    cell.confirmDescription.text = "You rejected \(name)."
                    cell.confirmButton.hidden = true
                    cell.rejectButton.hidden = true
                    cell.cancelButton.hidden = true
                }
                else if status == "cancelled" {
                    cell.confirmDescription.text = "\(name) cancelled the request."
                    cell.confirmButton.hidden = true
                    cell.rejectButton.hidden = true
                    cell.cancelButton.hidden = true
                }
            }
            else{ // I invite this user to join my band
                
                if status == "pending" {
                    cell.confirmDescription.text = "Be patient. \(name) is deciding."
                    cell.cancelButton.addTarget(self, action: "cancelRequest:", forControlEvents: .TouchUpInside)
                    cell.confirmButton.hidden = true
                    cell.rejectButton.hidden = true
                }
                else if status == "confirmed" {
                    cell.confirmDescription.text = "\(name) has joined your band, \(bandname)!"
                    cell.cancelButton.hidden = true
                    cell.confirmButton.hidden = true
                    cell.rejectButton.hidden = true
                }
                else if status == "rejected" {
                    cell.confirmDescription.text = "\(name) rejected your request!"
                    cell.cancelButton.hidden = true
                    cell.confirmButton.hidden = true
                    cell.rejectButton.hidden = true
                }
                else if status == "cancelled" {
                    cell.confirmDescription.text = "You cancelled the invitation"
                    cell.cancelButton.hidden = true
                    cell.confirmButton.hidden = true
                    cell.rejectButton.hidden = true
                }
            }
            
            
            
            
            
            return cell
        }
        else if indexPath.section == 1 {
            let cell = tableView.dequeueReusableCellWithIdentifier("Photo") as! PhotoCell!
            
            for view in cell.photoScrollView.subviews {
                view.removeFromSuperview()
            }

            cell.photoArray = self.photoArray
            cell.loadImages()
            
            for view in cell.photoScrollView.subviews {
                let tapGestureRecognizer = UITapGestureRecognizer(target:self, action:Selector("imageTapped:"))
                view.userInteractionEnabled = true
                view.addGestureRecognizer(tapGestureRecognizer)
            }
            
            return cell
        }
        else if indexPath.section == 2 {
            let cell = tableView.dequeueReusableCellWithIdentifier("Audio") as! AudioCell!
            cell.title.text = (audioArray[indexPath.row].objectForKey("title") as! String).uppercaseString + " "
            
            let imageFile = audioArray[indexPath.row].objectForKey("coverImage") as! PFFile
            imageFile.getDataInBackgroundWithBlock({
                (imageData: NSData?, error: NSError?) -> Void in
                if (error == nil) {
                    cell.cover.image = UIImage(data:imageData!)
                }
            })
            
            let audioFile = audioArray[indexPath.row].objectForKey("audioFile") as! PFFile
            cell.audioURLString = audioFile.url!
            
        
            return cell
        }
        else{
            let cell = tableView.dequeueReusableCellWithIdentifier("Video") as! VideoCell!
            cell.title.text = "VDO title"
            let videoId = videoArray[indexPath.row].objectForKey("videoID") as! String
            cell.loadYouTube(videoId)
            return cell
        }
    }
    
    func tableView(tableView: UITableView, didSelectRowAtIndexPath indexPath: NSIndexPath) {
        
    }
    
    override func prepareForSegue(segue: UIStoryboardSegue, sender: AnyObject?) {
        if segue.identifier == "Seek Full Screen Image"{
//            let fullScreenVC = segue.destinationViewController as! FullScreenImageViewController
//            fullScreenVC.img = self.tappedImage
        }
        if segue.identifier == "Person Info"{
//            let infoVC = segue.destinationViewController as! SeekPersonInfoViewController
//            infoVC.user = self.user
        }
        if segue.identifier == "Invite Person"{
            //let infoVC = segue.destinationViewController as! SeekPersonInfoViewController
            //infoVC.user = self.user
        }
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