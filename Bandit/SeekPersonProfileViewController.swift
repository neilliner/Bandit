//
//  SeekPersonProfileViewController.swift
//  Bandit
//
//  Created by Piyoros Vephula on 3/22/16.
//  Copyright © 2016 Piyoros Vephula. All rights reserved.
//

import UIKit
import Parse
import ParseUI
import AVKit
import AVFoundation

//public var player = AVPlayer()

class SeekPersonProfileViewController: UIViewController, UITableViewDelegate, UITableViewDataSource{
    
    var bandArray = [PFObject]()
    
    @IBOutlet var profileTableView: UITableView!
    @IBOutlet weak var bandDropdown: UIView!
    @IBOutlet weak var bandDropdownTableView: UITableView!
    @IBOutlet weak var bandDropdownToolBar: UIToolbar!
    
    var user:PFUser?
    var instArray = [String]()
    var tappedImage:PFImageView?
    var photoArray = [PFObject]()
    var audioArray = [PFObject]()
    var videoArray = [PFObject]()
    var genreString:String!
    
    @IBAction func closeBandDropdown(sender: UIBarButtonItem) {
        bandDropdown.hidden = true
    }
    override func viewDidLoad() {
        super.viewDidLoad()
        
        getBandProfileObject(PFUser.currentUser()!)
        //getBandProfileObject(self.user!)
        instArray = getInstruments(self.user!)
        //self.userObject = self.getProfileObject(self.user!)
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
        
        self.bandDropdownToolBar.setBackgroundImage(UIImage(),
            forToolbarPosition: UIBarPosition.Any,
            barMetrics: UIBarMetrics.Default)
        self.bandDropdownToolBar.setShadowImage(UIImage(),
            forToolbarPosition: UIBarPosition.Any)
        
        self.bandDropdown.hidden = true
    }
    
    override func viewDidAppear(animated: Bool) {
        super.viewDidAppear(animated)
        navigationController?.hidesBarsOnSwipe = true
        
    }
    
    func getBandProfileObject(user: PFUser){
        
        var bands = [PFObject]()
        // ***** load band's profile and image
        //let query = PFQuery(className: "Band")
        let query = PFQuery(className: "UserBand")
        
        //query.whereKey("member", equalTo: user)
        query.whereKey("user", equalTo: user)
        query.includeKey("band")
        // *** now we need to query user's band first (in UserBand class) then whereKey>bandname
        //print(bandArray)
        do {
            bands = try query.findObjects()
            print(bands)
            for band in bands {
                var found = 0
                
                for b in bandArray{
                    if b.objectForKey("band") as? PFObject == band {
                        found++
                    }
                }
                
                if found == 0 {
                    self.bandArray.append(band.objectForKey("band") as! PFObject)
                }
            }
        }
        catch {
            // error
            print("Band not found")
        }
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
            //print("********")
            //print(genresObj)
        }
        catch{
            print("Genres not found")
        }
        //print(genresObj)
        
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
        //print(str)
        return str
    }
    
    func inviteToBand(sender: AnyObject){
        print("inviteToBand")
        self.bandDropdown.hidden = false
    }
    
    func saveInvitation(band: PFObject, u: PFUser) {
//        let bandInvite = PFObject(className: "BandInvite")
//        bandInvite["band"] = band
//        bandInvite["inviteUser"] = u
//        bandInvite["status"] = "pending"
        let bandInvite = PFObject(className: "Inbox")
        bandInvite["notificationType"] = "Band Invites User"
        bandInvite["senderUser"] = PFUser.currentUser()
        bandInvite["senderBand"] = band
        bandInvite["receiverUser"] = u
        bandInvite["status"] = "pending"
        bandInvite.saveInBackgroundWithBlock({
            (success: Bool, error: NSError?) -> Void in
            if error == nil {
                print("band invite class saved")
            }else {
                print(error)
            }
            if success {
                
                let alert = UIAlertController(title: "Invitation sent", message: "Please wait for him/her to decide.", preferredStyle: UIAlertControllerStyle.Alert)
                let ok = UIAlertAction(title: "OK", style: UIAlertActionStyle.Default, handler: { (action: UIAlertAction) -> Void in
                    //print("Cancel Button Tapped")
                    self.navigationController?.popViewControllerAnimated(true)
                })
                alert.addAction(ok)
                
//                let cancel = UIAlertAction(title: "Cancel", style: UIAlertActionStyle.Cancel, handler: { (action: UIAlertAction) -> Void in
//                    print("Cancel Button Tapped")
//                    //self.navigationController?.popViewControllerAnimated(true)
//                })
//                alert.addAction(cancel)
                self.presentViewController(alert, animated: true, completion: nil)
                
                //self.navigationController?.popViewControllerAnimated(true)
                //let viewController:UIViewController = UIStoryboard(name: "Main", bundle: nil).instantiateViewControllerWithIdentifier("Inbox")
                //self.presentViewController(viewController, animated: false, completion: nil)
                //self.tabBarController!.presentViewController(viewController, animated: true, completion: nil)
            }
        })
    }
    
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
        //        if section == 0 {
        //            // Get rid of section 0 header by change the style "Group" to "Plain" in Attribute Inspector
        return 0.0
        //        }
        //        else{
        //            return 32.0
        //        }
    }
    
//    func tableView(tableView: UITableView, willDisplayHeaderView view: UIView, forSection section: Int) {
//        
//        if section != 0 {
//            let header: UITableViewHeaderFooterView = view as! UITableViewHeaderFooterView
//            //recast your view as a UITableViewHeaderFooterView
//            
//            header.contentView.backgroundColor = UIColor.groupTableViewBackgroundColor()
//            //make the background color light blue
//            
//            header.textLabel!.textColor = AppearanceHelper.mainColorDark()
//            //make the text white
//            
//            header.textLabel!.font = UIFont.systemFontOfSize(14.0,weight: UIFontWeightRegular)
//            
//            header.textLabel!.text = header.textLabel!.text?.uppercaseString
//            
//            header.alpha = 1.0
//            //make the header transparent
//        }
//    }
    
    func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        var row = 0
        
        if tableView.isEqual(bandDropdownTableView){
            switch section {
                case 0: row = bandArray.count
                case 1: if bandArray.count == 0 { row = 1 }
                default: row = 0
            }
        }
        else{
            switch section {
                case 0: row = 1
                case 1: row = 1
                case 2: row = audioArray.count
                case 3: row = videoArray.count
            default: row = 0
            }
        }
        return row
    }
    
    //    override func tableView(tableView: UITableView, willDisplayHeaderView view: UIView, forSection section: Int) {
    //        let header: UITableViewHeaderFooterView = view as! UITableViewHeaderFooterView //recast your view as a UITableViewHeaderFooterView
    //        header.contentView.backgroundColor = UIColor(red: 0/255, green: 181/255, blue: 229/255, alpha: 1.0) //make the background color light blue
    //    }
    
    func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell {
        
        if bandArray.count > 0 {
            print("#########################")
            print(bandArray)
        }
        else{
            
        }
        
        if tableView.isEqual(bandDropdownTableView){
            
            if indexPath.section == 0 {
                let cell = tableView.dequeueReusableCellWithIdentifier("Band Select") as! BandSelectCell!
                cell.bandname.text = bandArray[indexPath.row].objectForKey("bandname") as! String
                if let imageFile = bandArray[indexPath.row].objectForKey("photo") as? PFFile {
                    imageFile.getDataInBackgroundWithBlock({
                        (imageData: NSData?, error: NSError?) -> Void in
                        if (error == nil) {
                            cell.bandImage.image = UIImage(data:imageData!)
                        }
                    })
                }
                return cell
            }
            else{
                //if bandArray.count == 0 {
                    let cell = tableView.dequeueReusableCellWithIdentifier("Create New Band") as UITableViewCell!
                    return cell
                //}
            }
        }
        else{
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
                
                cell.profileImage.layer.masksToBounds = false
                cell.profileImage.layer.cornerRadius = cell.profileImage.frame.size.width/2
                cell.profileImage.clipsToBounds = true
                
                cell.location.text = (user!["location"] as! String).uppercaseString
                
                cell.instArray = self.instArray
                cell.loadImages()
                
                cell.fullName.text = user!["fullName"] as! String
                cell.exp.text = ""//String(userObject["exp"])
                //cell.exp.layer.cornerRadius = cell.exp.frame.size.width/2
                //cell.exp.clipsToBounds = true
                
                cell.instrument.text = ""//userObject["instrument"].objectForKey("instrument") as! String
                
                cell.genre.text = "\(genreString.lowercaseString)"//(userObject["genre"].objectForKey("genre") as! String).lowercaseString
                
                
                cell.inviteButton.addTarget(self, action: "inviteToBand:", forControlEvents: .TouchUpInside)
                
                return cell
            }
            else if indexPath.section == 1 {
                let cell = tableView.dequeueReusableCellWithIdentifier("Photo") as! PhotoCell!
                
                for view in cell.photoScrollView.subviews {
                    view.removeFromSuperview()
                }
                //cell.shouldShowAddIcon = true
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
                
                //cell.playButton.tag = indexPath.row
                //cell.playButton.addTarget(cell, action: "playAudio:", forControlEvents: .TouchUpInside)
                //indexPathForUpdate.append(indexPath)
                //cell.slider.tag = indexPath.row
                //cell.slider.addTarget(self, action: "sliderMove:", forControlEvents: .ValueChanged)
                //cell.slider.setValue(sliderValues[indexPath.row], animated: false)
                //print(sliderValues)
                return cell
            }
            else{
                let cell = tableView.dequeueReusableCellWithIdentifier("Video") as! VideoCell!
                cell.title.text = "VDO title" //videoId[indexPath.row]
                let videoId = videoArray[indexPath.row].objectForKey("videoID") as! String
                cell.loadYouTube(videoId)
                return cell
            }
        }
    }
    
    func tableView(tableView: UITableView, didSelectRowAtIndexPath indexPath: NSIndexPath) {
        
        if tableView.isEqual(bandDropdownTableView){
            
            // save to Parse
            saveInvitation(bandArray[indexPath.row], u: user!)
            
            //performSegueWithIdentifier("Invite Person", sender: self)
            //if indexPath.section == 0 {
                //self.selectedBand = indexPath.row
                //getBandMember(bandArray[selectedBand].objectId!)
                //bandTableView.reloadData()
                //self.bandDropdown.hidden = true
                //print(selectedBand)
            //}
            //else{
                //performSegueWithIdentifier("Create New Band", sender: self)
            //}
        }
    }
    
    override func prepareForSegue(segue: UIStoryboardSegue, sender: AnyObject?) {
        if segue.identifier == "Seek Full Screen Image"{
            let fullScreenVC = segue.destinationViewController as! FullScreenImageViewController
            fullScreenVC.img = self.tappedImage
        }
        if segue.identifier == "Person Info"{
            let infoVC = segue.destinationViewController as! SeekPersonInfoViewController
            infoVC.user = self.user
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
