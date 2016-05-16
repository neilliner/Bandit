//
//  IndividualProfileViewController.swift
//  Bandit
//
//  Created by Piyoros Vephula on 11/18/2558 BE.
//  Copyright © 2558 Piyoros Vephula. All rights reserved.
//

import UIKit
import Parse
import ParseUI
import AVKit
import AVFoundation


class IndividualProfileViewController: UITableViewController, UIImagePickerControllerDelegate, UINavigationControllerDelegate{

    let user = PFUser.currentUser()!
    
    @IBOutlet var profileTableView: UITableView!
    @IBOutlet weak var toggleModeSwitch: UISegmentedControl!
    
    var tappedImage:PFImageView?
    var reload = false
    var reloadPhotos = false
    var instArray = [String]()
    //var userObject:PFObject!
    var photoArray = [PFObject]()
    var audioArray = [PFObject]()
    var videoArray = [PFObject]()
    //var genreArray = [String]()
    var genreString:String!
    var imgPickerTag = ""
    
    @IBAction func toggleMode(sender: UISegmentedControl) {
        switch sender.selectedSegmentIndex {
        case 0:
            print("Individual")
            //performSegueWithIdentifier("Individual", sender: self)
        case 1:
            print("Band")
            performSegueWithIdentifier("Band", sender: self)
        default:
            print("You shouldn't be here")
        }
    }
    

    @IBAction func editButtonTapped(sender: UIBarButtonItem) {
        print("editButtonTapped")
        reload = true
        self.performSegueWithIdentifier("Edit Profile", sender: sender)
    }
    
    override func prepareForSegue(segue: UIStoryboardSegue, sender: AnyObject?) {
        if segue.identifier == "Full Screen Image"{
            let fullScreenVC = segue.destinationViewController as! FullScreenImageViewController
            fullScreenVC.img = self.tappedImage
        }
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        print(user)
        instArray = getInstruments(self.user)
        //self.userObject = self.getProfileObject(self.user)
        //genreArray = getGenres(self.user)
        //print(genreArray)
        genreString = makeStringFromArray(getGenres(self.user), delim: "•")
        
        self.photoArray = self.getPhotoObject(self.user)
        self.audioArray = self.getAudioObject(self.user)
        self.videoArray = self.getVideoObject(self.user)
//        for _ in audioArray {
//            sliderValues.append(0.0)
//        }
        //print(audioArray)
        profileTableView.contentInset = UIEdgeInsetsMake(-1.0, 0.0, 0.0, 0.0);
        
        profileTableView.rowHeight = UITableViewAutomaticDimension
        profileTableView.estimatedRowHeight = 160.0
        
    }
    
    override func viewWillAppear(animated: Bool) {
        
        self.navigationController?.navigationBar.setBackgroundImage(UIImage(), forBarMetrics: UIBarMetrics.Default)
        self.navigationController?.navigationBar.shadowImage = UIImage()
        self.navigationController?.navigationBar.translucent = true
        
        toggleModeSwitch.selectedSegmentIndex = 0
        
        //toggleModeSwitch.layer.borderColor = AppearanceHelper.itemColor().CGColor;
        //toggleModeSwitch.layer.cornerRadius = 0.0;
        //toggleModeSwitch.layer.borderWidth = 0;
        toggleModeSwitch.removeBorders()
        toggleModeSwitch.setTitleTextAttributes([NSForegroundColorAttributeName: UIColor.whiteColor(),NSFontAttributeName: UIFont(name: "HelveticaNeue-Bold", size: 14)!], forState:.Normal)
        toggleModeSwitch.setTitleTextAttributes([NSForegroundColorAttributeName: AppearanceHelper.itemColor(),NSFontAttributeName: UIFont(name: "HelveticaNeue-Bold", size: 14)!], forState:.Selected)
        self.tabBarController?.tabBar.hidden = false
        
        
    }
    
    override func viewDidAppear(animated: Bool) {
        super.viewDidAppear(animated)
        navigationController?.hidesBarsOnSwipe = true
        
        if reload == true {
            //if instArray != getInstruments(user) || genreString != makeStringFromArray(getGenres(self.user), delim: "•") {
                //self.profileTableView.reloadData()
                self.instArray = [String]()
                self.instArray = getInstruments(user)
                genreString = makeStringFromArray(getGenres(self.user), delim: "•")
                print("%%%%%%%%%%%%%%")
                print(instArray)
                let indexPath = NSIndexPath(forRow: 0, inSection: 0)
                self.profileTableView.reloadRowsAtIndexPaths([indexPath], withRowAnimation: UITableViewRowAnimation.Fade)
                reload = false
            //}
        }
        if reloadPhotos == true {
            if self.photoArray.count != getPhotoObject(user).count {
                self.photoArray = getPhotoObject(user)
                let indexPath = NSIndexPath(forRow: 0, inSection: 1)
                self.profileTableView.reloadRowsAtIndexPaths([indexPath], withRowAnimation: UITableViewRowAnimation.Left
                )
            }
            reloadPhotos = false
        }
    }
    
    func profileImageTapped(img: AnyObject){
        //print("profileImageTapped")
        chooseImage("Profile Image")
//        let imageData = UIImageJPEGRepresentation(self.profileImage.image!, 0.5)
//        
//        //create a parse file to store in cloud
//        let parseImageFile = PFFile(name: "profile_image.jpg", data: imageData!)
//        user["image"] = parseImageFile
//        user.saveInBackgroundWithBlock({
//            (success: Bool, error: NSError?) -> Void in
//            if error == nil {
//                print("data uploaded")
//            }else {
//                print(error)
//            }
//        })
    }
    
    func addIconTapped(img: AnyObject){
        //print("Add Photo")
        //let currentDateTime = NSDate()
        //print(currentDateTime.timeIntervalSince1970)
        chooseImage("Add Photo")
    }
    
    func chooseImage(imgPkrTag: String) {
        let imagePicker = UIImagePickerController()
        imagePicker.delegate = self
        if Platform.isSimulator {
            imagePicker.sourceType = UIImagePickerControllerSourceType.PhotoLibrary
        }
        else {
            imagePicker.sourceType = UIImagePickerControllerSourceType.Camera
        }
        imagePicker.allowsEditing = false
        imgPickerTag = imgPkrTag
        self.presentViewController(imagePicker, animated: true, completion: nil)
    }
    
    func imagePickerController(picker: UIImagePickerController, didFinishPickingImage image: UIImage!, editingInfo: [NSObject : AnyObject]!) {
        print("***************")
        print(picker.description)
        print("***************")
        //profileImage.image = image
        // save photo
        let imageData = UIImageJPEGRepresentation(image, 0.5)
        //let imageData = UIImagePNGRepresentation(image)
        
        
        if imgPickerTag == "Profile Image" {
            let parseImageFile = PFFile(name: "\(user.username!)-profile-image.jpg" , data: imageData!)
            //let userPhoto = PFObject(className: "UserPhoto")
            //userPhoto["user"] = user
            user["image"] = parseImageFile
            
            
            do {try user.save()}
            catch {}
            //self.photoArray = self.getPhotoObject(self.user)
            self.dismissViewControllerAnimated(true, completion: {
                let indexPath = NSIndexPath(forRow: 0, inSection: 0)
                self.profileTableView.reloadRowsAtIndexPaths([indexPath], withRowAnimation: UITableViewRowAnimation.Fade)
            })
        }
        
        if imgPickerTag == "Add Photo" {
            let currentDateTime = NSDate()
            let parseImageFile = PFFile(name: "\(user.username!)photo-\(currentDateTime.timeIntervalSince1970).jpg" , data: imageData!)
            let userPhoto = PFObject(className: "UserPhoto")
            userPhoto["user"] = user
            userPhoto["photo"] = parseImageFile
            
            
            do {try userPhoto.save()}
            catch {}
            self.photoArray = self.getPhotoObject(self.user)
            self.dismissViewControllerAnimated(true, completion: {
                let indexPath = NSIndexPath(forRow: 0, inSection: 1)
                self.profileTableView.reloadRowsAtIndexPaths([indexPath], withRowAnimation: UITableViewRowAnimation.Left)
            })

        
//        userPhoto.saveInBackgroundWithBlock({
//            (success: Bool, error: NSError?) -> Void in
//            if error == nil {
//                print("data uploaded")
//                //self.dismissViewControllerAnimated(true, completion: nil)
//                self.dismissViewControllerAnimated(true, completion: {
//                    self.photoArray = self.getPhotoObject(self.user)
//                    let indexPath = NSIndexPath(forRow: 0, inSection: 1)
//                    self.profileTableView.reloadRowsAtIndexPaths([indexPath], withRowAnimation: UITableViewRowAnimation.Left)
//                })
////                dispatch_async(dispatch_get_main_queue()) {
////                    
////                    let indexPath = NSIndexPath(forRow: 0, inSection: 1)
////                    self.profileTableView.reloadRowsAtIndexPaths([indexPath], withRowAnimation: UITableViewRowAnimation.Left)
////                }
//                
//            }else {
//                print(error)
//                
//            }
//            if success == true {
////                dispatch_async(dispatch_get_main_queue()) {
////                    
////                    let indexPath = NSIndexPath(forRow: 0, inSection: 1)
////                    self.profileTableView.reloadRowsAtIndexPaths([indexPath], withRowAnimation: UITableViewRowAnimation.Left)
////                }
////                self.photoArray = self.getPhotoObject(self.user)
//                
//            }
//        })
        
        //self.dismissViewControllerAnimated(true, completion: nil)
        }
        
    }
    
//    func getProfileObject(user: PFUser) -> PFObject {
//
//        var obj:PFObject!
//        // ***** load user's profile and image
//        let query = PFQuery(className: "Profile")
//        query.whereKey("user", equalTo: user)
//        query.includeKey("user")
//        query.includeKey("instrument")
//        query.includeKey("genre")
//        
//        // get data synchronously
//        do{
//            obj = try query.getFirstObject()
//        }
//        catch{
//            
//            // if profile not found -> alert user to create or go back
//            print("Profile not found")
//            let alert = UIAlertController(title: "Profile Error", message: "Your profile has not been set", preferredStyle: UIAlertControllerStyle.Alert)
//            let ok = UIAlertAction(title: "OK", style: UIAlertActionStyle.Default, handler: self.okActionTapped)
//            alert.addAction(ok)
//            let cancel = UIAlertAction(title: "Cancel", style: UIAlertActionStyle.Cancel, handler: { (action: UIAlertAction) -> Void in
//                print("Cancel Button Tapped")
//                self.navigationController?.popToRootViewControllerAnimated(true)
//            })
//            alert.addAction(cancel)
//            self.presentViewController(alert, animated: true, completion: nil)
//        }
//        return obj
//    }
    
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
        print("$$$$$$$$$$$$$")
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
    
    func okActionTapped(action: UIAlertAction) {
        print("Ok Button Tapped")
        self.navigationController?.popViewControllerAnimated(true)
    }
    
    func imageTapped(img: AnyObject) {
        print("imageTapped")
        //print(img.view!)
        reloadPhotos = true
        self.tappedImage = img.view! as! PFImageView
        self.performSegueWithIdentifier("Full Screen Image", sender: self)
    }
    
    override func numberOfSectionsInTableView(tableView: UITableView) -> Int {
        return 4
    }
    
    override func tableView(tableView: UITableView, titleForHeaderInSection section: Int) -> String? {
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
    
    override func tableView(tableView: UITableView, heightForHeaderInSection section: Int) -> CGFloat {
//        if section == 0 {
//            // Get rid of section 0 header by change the style "Group" to "Plain" in Attribute Inspector
            return 0.0            
//        }
//        else{
//            return 32.0
//        }
    }
    
    override func tableView(tableView: UITableView, willDisplayHeaderView view: UIView, forSection section: Int) {
        
        if section != 0 {
            let header: UITableViewHeaderFooterView = view as! UITableViewHeaderFooterView
            //recast your view as a UITableViewHeaderFooterView
            
            header.contentView.backgroundColor = UIColor.groupTableViewBackgroundColor()
            //make the background color light blue
            
            header.textLabel!.textColor = AppearanceHelper.mainColorDark()
            //make the text white
            
            header.textLabel!.font = UIFont.systemFontOfSize(14.0,weight: UIFontWeightRegular)
            
            header.textLabel!.text = header.textLabel!.text?.uppercaseString
            
            header.alpha = 1.0
            //make the header transparent
        }
    }
    
    override func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        var row = 0

        switch section {
            case 0: row = 1
            case 1: row = 1
            case 2: row = audioArray.count
            case 3: row = videoArray.count
            default: row = 0
        }
        return row
    }
    
//    override func tableView(tableView: UITableView, willDisplayHeaderView view: UIView, forSection section: Int) {
//        let header: UITableViewHeaderFooterView = view as! UITableViewHeaderFooterView //recast your view as a UITableViewHeaderFooterView
//        header.contentView.backgroundColor = UIColor(red: 0/255, green: 181/255, blue: 229/255, alpha: 1.0) //make the background color light blue
//    }
    
    override func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell {

        if indexPath.section == 0 {
            let cell = tableView.dequeueReusableCellWithIdentifier("Profile") as! ProfileCell!
            let imageFile = user["image"] as! PFFile//userObject!["image"] as! PFFile
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
            
            let tapGestureRecognizer = UITapGestureRecognizer(target:self, action:Selector("profileImageTapped:"))
            cell.profileImage.userInteractionEnabled = true
            cell.profileImage.addGestureRecognizer(tapGestureRecognizer)
            
            if let loc = user["location"] as? String {
                cell.location.text = loc.uppercaseString
            }
            
            for view in cell.instView.subviews {
                view.removeFromSuperview()
            }
            
            if self.instArray.count > 0 {
                cell.instArray = self.instArray
                cell.loadImages()
            }
            
            cell.fullName.text = user["fullName"] as! String//userObject["user"].objectForKey("fullName") as! String
            
            cell.exp.text = ""//String(userObject["exp"])
            //cell.exp.layer.cornerRadius = cell.exp.frame.size.width/2
            //cell.exp.clipsToBounds = true
            
            cell.instrument.text = ""//userObject["instrument"].objectForKey("instrument") as! String
            
            cell.genre.text = "\(genreString.lowercaseString)"//(userObject["genre"].objectForKey("genre") as! String).lowercaseString
            
            return cell
        }
        else if indexPath.section == 1 {
            let cell = tableView.dequeueReusableCellWithIdentifier("Photo") as! PhotoCell!
            
            for view in cell.photoScrollView.subviews {
                view.removeFromSuperview()
            }
            cell.shouldShowAddIcon = true
            cell.photoArray = self.photoArray
            cell.loadImages()
            
            for view in cell.photoScrollView.subviews {
                let tapGestureRecognizer = UITapGestureRecognizer(target:self, action:Selector("imageTapped:"))
                view.userInteractionEnabled = true
                view.addGestureRecognizer(tapGestureRecognizer)
            }
            
            let tapGestureRecognizer = UITapGestureRecognizer(target:self, action:Selector("addIconTapped:"))
            cell.addIcon!.userInteractionEnabled = true
            cell.addIcon!.addGestureRecognizer(tapGestureRecognizer)
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
    
    /*
    // MARK: - Navigation
    
    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepareForSegue(segue: UIStoryboardSegue, sender: AnyObject?) {
    // Get the new view controller using segue.destinationViewController.
    // Pass the selected object to the new view controller.
    }
    */
    
    struct Platform {
        static let isSimulator: Bool = {
            var isSim = false
            #if arch(i386) || arch(x86_64)
                isSim = true
            #endif
            return isSim
        }()
    }
    
}

/*
    
    override func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath, object: PFObject?) -> PFTableViewCell {
        
        print(object)
        var cell = tableView.dequeueReusableCellWithIdentifier("Profile") as! ProfileCell!
//        if profileCell == nil {
//            profileCell = ProfileCell(style: UITableViewCellStyle.Default, reuseIdentifier: "Profile")
//        }
        
        // Display image
        //print(object?["image"])
        
        if let thumbnail = object?["image"] as? PFFile {
            cell.profileImage.file = thumbnail
            cell.profileImage.loadInBackground()
            //profileCell.profileImage.layer.borderWidth = 1.0
            cell.profileImage.layer.masksToBounds = false
            //profileCell.profileImage.layer.borderColor = UIColor.whiteColor().CGColor
            cell.profileImage.layer.cornerRadius = cell.profileImage.frame.size.width/2
            cell.profileImage.clipsToBounds = true
        }
        
        // Extract values from the PFObject to display in the table cell
        
        if let name = object?["user"].objectForKey("fullName") as? String {
            cell.fullName.text = name

        }
        
        if let exp = object?["exp"] as? Int {
            cell.exp.text = String(exp)
            cell.exp.layer.cornerRadius = cell.exp.frame.size.width/2
            cell.exp.clipsToBounds = true
        }
        
        if let instrument = object?["instrument"].objectForKey("instrument") as? String {
            //let instrument = "Instrument"
            cell.instrument.text = instrument
        }
        
        if let genre = object?["genre"].objectForKey("genre") as? String {
            cell.genre.text = genre
        }
        
        return cell
    }
    
}*/
