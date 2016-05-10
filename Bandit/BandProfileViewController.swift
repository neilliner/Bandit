//
//  BandProfileViewController.swift
//  Bandit
//
//  Created by Piyoros Vephula on 11/22/2558 BE.
//  Copyright © 2558 Piyoros Vephula. All rights reserved.
//

import UIKit
import Parse
import AVKit
import AVFoundation

class BandProfileViewController: UIViewController, UITableViewDataSource, UITableViewDelegate, UIImagePickerControllerDelegate, UINavigationControllerDelegate {

    let user = PFUser.currentUser()!
    var selectedBand = 0
    
    var createNewBand = false
    
    @IBOutlet weak var bandOnBoardingView: UIView!
    @IBOutlet weak var createBandButton: UIButton!
    
    @IBOutlet weak var infoBarButton: UIBarButtonItem!
    var infoImage:UIImage?
    
    @IBOutlet weak var editBarButton: UIBarButtonItem!
    var editImage:UIImage?
    
    @IBOutlet weak var toolBar: UIToolbar!
    @IBOutlet weak var bandSelectDropdown: UIView!
    @IBOutlet weak var bandSelectDropdownTableView: UITableView!
    @IBOutlet var bandTableView: UITableView!
    
    var bandArray = [PFObject]()
    //var bandIdArray = [String]()
    //var bandGenreArray = [String]()
    //var bandGenre:String?
    var bandMemberArray = [PFObject]()
    var seekInstruments = [String]()
    
    var reloadAfterEditBand = false
    
    @IBOutlet weak var toggleModeSwitch: UISegmentedControl!
    
    @IBAction func toggleMode(sender: UISegmentedControl) {
        switch sender.selectedSegmentIndex {
        case 0:
            print("Individual")
            self.navigationController?.popToRootViewControllerAnimated(false)
            //performSegueWithIdentifier("Individual", sender: self)
        case 1:
            print("Band")
            //performSegueWithIdentifier("Band", sender: self)
        default:
            print("You shouldn't be here")
        }
    }
    
    @IBAction func editBand(sender: UIBarButtonItem) {
        reloadAfterEditBand = true
        performSegueWithIdentifier("Edit Band", sender: self)
    }
    
    @IBAction func createBand(sender: UIButton) {
        createNewBand = true
        performSegueWithIdentifier("Create New Band", sender: self)
    }
    
    @IBAction func closeBandSelect(sender: AnyObject) {
        bandSelectDropdown.hidden = true
    }
    @IBAction func selectBand(sender: UIButton) {
        print("dropdown")
        self.bandSelectDropdown.hidden = false
        
//        
//        self.bandSelectDropDown.hidden = false
//        let alert = UIAlertController(title: "Profile Error", message: "Your profile has not been set", preferredStyle: UIAlertControllerStyle.Alert)
//        let ok = UIAlertAction(title: "OK", style: UIAlertActionStyle.Default, handler: self.okActionTapped)
//        alert.addAction(ok)
//        let cancel = UIAlertAction(title: "Cancel", style: UIAlertActionStyle.Cancel, handler: { (action: UIAlertAction) -> Void in
//            print("Cancel Button Tapped")
//            
//            self.navigationController?.popToRootViewControllerAnimated(true)
//        })
//        alert.addAction(cancel)
//        self.presentViewController(alert, animated: true, completion: nil)
    }
    
//    func okActionTapped(action: UIAlertAction) {
//        print("Ok Button Tapped")
//        self.navigationController?.popViewControllerAnimated(true)
//    }
    
    
    @IBAction func cameraButtonTapped(sender: UIBarButtonItem) {
        chooseImage()
    }
    
    override func prepareForSegue(segue: UIStoryboardSegue, sender: AnyObject?) {
        if segue.identifier == "Edit Band"{
            let editBandVC = segue.destinationViewController as! EditBandViewController
            editBandVC.band = bandArray[selectedBand]
        }
        if segue.identifier == "Band Info"{
            let bandInfoVC = segue.destinationViewController as! BandInfoViewController
            bandInfoVC.band = bandArray[selectedBand]
        }
    }
    
    func imagePickerController(picker: UIImagePickerController, didFinishPickingImage image: UIImage!, editingInfo: [NSObject : AnyObject]!) {
        print("didFinishPickingImage")

        let band = bandArray[selectedBand]
        let bandname = band["bandname"]
        // save photo
        let imageData = UIImageJPEGRepresentation(image, 0.5)
        //let imageData = UIImagePNGRepresentation(image)
        
        let parseImageFile = PFFile(name: "\(bandname)-band-profile-image.jpg" , data: imageData!)
        band["photo"] = parseImageFile
        do {try band.save();print("band photo saved")}catch {print("error!!")}
        self.dismissViewControllerAnimated(true, completion: {
            let indexPath = NSIndexPath(forRow: 0, inSection: 0)
            self.bandTableView.reloadRowsAtIndexPaths([indexPath], withRowAnimation: UITableViewRowAnimation.Fade)
        })
        
    }
    
    ///////////  temporary /////////////
    var audioArray = [PFObject]()
    var videoArray = [PFObject]()
    
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
    ///////////  temporary /////////////
    
    func chooseImage() {
        let imagePicker = UIImagePickerController()
        imagePicker.delegate = self
        if Platform.isSimulator {
            imagePicker.sourceType = UIImagePickerControllerSourceType.PhotoLibrary
        }
        else {
            imagePicker.sourceType = UIImagePickerControllerSourceType.Camera
        }
        imagePicker.allowsEditing = false
        self.presentViewController(imagePicker, animated: true, completion: nil)
    }
    
    func makeBandNameArray() -> [String]{
        var b = [String]()
        for band in bandArray{
            b.append(band.objectForKey("bandname") as! String)
        }
        return b
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        infoImage = infoBarButton.image
        editImage = editBarButton.image
        
        self.navigationItem.setHidesBackButton(true, animated:false)
        
        getBandProfileObject(self.user)
        //seekInstruments = getSeekInstruments(bandArray[selectedBand])
        
        bandTableView.rowHeight = UITableViewAutomaticDimension
        bandTableView.estimatedRowHeight = 160.0

        self.createBandButton.layer.borderWidth = 2
        self.createBandButton.layer.borderColor = AppearanceHelper.itemColor().CGColor
        self.createBandButton.layer.cornerRadius = 5
        
        ///////////  temporary /////////////
        self.audioArray = self.getAudioObject(self.user)
        self.videoArray = self.getVideoObject(self.user)
        ///////////  temporary /////////////
    }   
    
    override func viewWillAppear(animated: Bool) {
        toggleModeSwitch.selectedSegmentIndex = 1
        self.tabBarController?.tabBar.hidden = false
        //self.bandSelectDropdown.hidden = false
        self.bandSelectDropdown.hidden = true
        self.navigationController?.navigationBar.setBackgroundImage(UIImage(), forBarMetrics: UIBarMetrics.Default)
        self.navigationController?.navigationBar.shadowImage = UIImage()
        self.navigationController?.navigationBar.translucent = true
        
        // make UIToolbar transparent
        self.toolBar.setBackgroundImage(UIImage(),
            forToolbarPosition: UIBarPosition.Any,
            barMetrics: UIBarMetrics.Default)
        self.toolBar.setShadowImage(UIImage(),
            forToolbarPosition: UIBarPosition.Any)
        
        
        
        
//        toggleModeSwitch.layer.borderColor = AppearanceHelper.itemColor().CGColor;
//        toggleModeSwitch.layer.cornerRadius = 0.0;
//        toggleModeSwitch.layer.borderWidth = 1.5;
        toggleModeSwitch.removeBorders()
        toggleModeSwitch.setTitleTextAttributes([NSForegroundColorAttributeName: UIColor.whiteColor(),NSFontAttributeName: UIFont(name: "HelveticaNeue-Bold", size: 14)!], forState:.Normal)
        toggleModeSwitch.setTitleTextAttributes([NSForegroundColorAttributeName: AppearanceHelper.itemColor(),NSFontAttributeName: UIFont(name: "HelveticaNeue-Bold", size: 14)!], forState:.Selected)
        
        
    }
    
    override func viewDidAppear(animated: Bool) {
        //super.viewDidAppear(animated)
        navigationController?.hidesBarsOnSwipe = true
        
        if createNewBand == true {
            getBandProfileObject(user)
            print("bandTableView reloaded")
            //bandTableView.reloadData()
            createNewBand = false
        }
        if reloadAfterEditBand == true {
            bandArray = [PFObject]()
            getBandProfileObject(user)
            if let b = bandArray.isIndexNotOver(selectedBand) {
                getBandMember(b)
            }
            bandTableView.reloadData()
//            let indexPath = NSIndexPath(forRow: 0, inSection: 2)
//            self.bandTableView.reloadRowsAtIndexPaths([indexPath], withRowAnimation: UITableViewRowAnimation.Fade)
            print("bandTableView reloaded")
            reloadAfterEditBand = false
        }
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
        
        do {
            bands = try query.findObjects()
            for band in bands {
                var found = 0
                
                for b in bandArray{
                    if b.objectForKey("band") as? PFObject == band {
                        found++
                    }
                }
                
//                for bandId in bandArray{
//                    if band.objectForKey("band")!.objectId!! == bandId{
//                        found++
//                    }
//                }
                
                if found == 0 {
                    self.bandArray.append(band.objectForKey("band") as! PFObject)
                    //print(bandIdArray)
                }
            }
        }
        catch {
            // error
            print("Band not found")
        }
//        queryBandName.findObjectsInBackgroundWithBlock {
//            (objects: [PFObject]?, error: NSError?) -> Void in
//            
//            if error == nil {
//                // The find succeeded.
//                // Do something with the found objects
//                if let objects = objects {
//                    //print(objects)
//                    for object in objects {
//                        print(object.objectForKey("band")!.objectId!!)
//                        self.bandNameArray.append(object.objectForKey("band")!.objectId!!)
//                    }
//                }
//            } else {
//                // Log details of the failure
//                print("Band not found")
//            }
//        }
        
//        for id in bandIdArray {
//            //print("************************************ \(id)")
//            let query = PFQuery(className: "Band")
//            query.whereKey("objectId", equalTo: id)
//
//            query.includeKey("genre")
//            query.findObjectsInBackgroundWithBlock {
//                (objects: [PFObject]?, error: NSError?) -> Void in
//                
//                if error == nil {
//                    // The find succeeded.
//                    // Do something with the found objects
//                    if let objects = objects {
//                        //print(objects)
//                        for object in objects {
//                            self.bandArray.append(object)
//                            //self.seekInstruments = self.getSeekInstruments(self.bandArray[self.selectedBand])
//                        }
//                        dispatch_async(dispatch_get_main_queue()) {
//                            self.bandTableView.reloadData()
//                            self.bandSelectDropdownTableView.reloadData()
//                        }
//                    }
//                }
//                else {
//                    // Log details of the failure
//                    print("Band not found")
//                }
//            }
//        }
    }
    
    func getBandGenres(band: PFObject) -> [String] {
        var genres = [String]()
        var genresObj = [PFObject]()
        let query = PFQuery(className: "BandGenre")
        query.whereKey("band", equalTo: band)
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
    
    func getSeekInstruments(band: PFObject) -> [String] {
        
        seekInstruments = [String]()
        print("###################")
        print(seekInstruments)
        var instruments = [String]()
        var instrumentsObj = [PFObject]()
        let query = PFQuery(className: "BandSeek")
        query.whereKey("band", equalTo: band)
        do{
            instrumentsObj = try query.findObjects()
            print(instrumentsObj)
        }
        catch{
            print("Instrument not found")
        }
        
        for i in instrumentsObj {
            instruments.append(i.objectForKey("instrument") as! String)
        }
        
        return instruments
    }
    
    func getBandMember(band: PFObject){
        bandMemberArray = [PFObject]()
        print("###### \(bandMemberArray)")
        //let bId = bandId as! PFObject
        var members = [PFObject]()
        var bs = [PFObject]()
        let query = PFQuery(className: "UserBand")
        //print("*************getBandMember************** \(bandId)")
        //query.whereKey("band", equalTo: PFObject(withoutDataWithClassName: "Band", objectId: bandId))
        
        query.whereKey("band", equalTo: band)
        query.includeKey("user")
//        query.findObjectsInBackgroundWithBlock {
//            (objects: [PFObject]?, error: NSError?) -> Void in
//            
//            if error == nil {
//                // The find succeeded.
//                // Do something with the found objects
//                if let objects = objects {
//                    print("************query.findObjectsInBackgroundWithBlock************* \(objects)")
//                    for object in objects {
//                        //self.bandArray.append(object)
//                    }
//                    dispatch_async(dispatch_get_main_queue()) {
//                        self.bandTableView.reloadData()
//                        //self.bandSelectDropdown.reloadData()
//                    }
//                }
//            }
//            else {
//                // Log details of the failure
//                print("Member not found")
//            }
//        }
        do {
            bs = try query.findObjects()
            //print(bs)
            for b in bs {
                members.append(b.objectForKey("user")  as! PFObject)
                //self.bandMemberArray.append(band.objectForKey("user") )
                
            }
            bandMemberArray = members
            //print(bandMemberArray)
        }
        catch {
            // error
            print("Member not found")
        }
        //print(members)
        
        
        
    }
    
    func numberOfSectionsInTableView(tableView: UITableView) -> Int {
        if tableView.isEqual(bandSelectDropdownTableView){return 2}
        // if tableView.tag == 1{return 1}
        return 5
    }
    
    func tableView(tableView: UITableView, viewForHeaderInSection section: Int) -> UIView? {
        let title: UILabel = UILabel()
        title.text = ""
        title.textAlignment = NSTextAlignment.Center
        
        if tableView.isEqual(bandSelectDropdownTableView){return nil}
        
        switch section {
            case 0: title.text = ""
            case 1: title.text = "Instrumentalists need"
            case 2: title.text = "Members"
            case 3: title.text = "Music"
            case 4: title.text = "Video"
            default: title.text = "Unknown"
        }
        
        return title
    }
    
    func tableView(tableView: UITableView, heightForHeaderInSection section: Int) -> CGFloat {
        //if section == 0 {
            // Get rid of section 0 header by change the style "Group" to "Plain" in Attribute Inspector
            return 0.0
        //}
        //else{
        //    return 32.0
        //}
    }
    
    func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        print("********************")
        print(seekInstruments)
        //print(bandArray)
        var row = 0
        
        if tableView.isEqual(bandSelectDropdownTableView){
            switch section {
                case 0: row = bandArray.count
                case 1: row = 1
                default: row = 0
            }
        }
        else{
            switch section {
                case 0: // cover
                    if bandArray.count == 0 {
                        row = 0
                    }
                    else {
                        row = 1
                    }
                case 1: //seek
    //                if seekInstruments.count == 0 {
    //                    row = 0
    //                }
    //                else {
                        row = 1
    //                }
                case 2: row = 1//member
                case 3: row = audioArray.count//music
                case 4: row = videoArray.count//video
                default: row = 0
            }
        }
        return row
    }
    
//    override func tableView(tableView: UITableView, heightForHeaderInSection section: Int) -> CGFloat {
//
//    }
    
    func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell {
        
        var bandGenre:String?
        
        if bandArray.count > 0 {
            print("*******tableView*******")
            bandOnBoardingView.hidden = true
            
            infoBarButton.image = infoImage
            editBarButton.image = editImage
            
            bandGenre = makeStringFromArray(getBandGenres(self.bandArray[self.selectedBand]), delim: "•")
            //bandGenreArray = getBandGenres(self.bandArray[self.selectedBand])
            getBandMember(bandArray[selectedBand])
            
            self.seekInstruments = self.getSeekInstruments(self.bandArray[self.selectedBand])
        }
        else{
            infoBarButton.image = nil
            editBarButton.image = nil
            bandOnBoardingView.hidden = false
        }
        
        if tableView.isEqual(bandSelectDropdownTableView){
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
                let cell = tableView.dequeueReusableCellWithIdentifier("Create New Band") as UITableViewCell!
                return cell
            }
        }
        else{
            if indexPath.section == 0 {
                let cell = tableView.dequeueReusableCellWithIdentifier("Band Profile") as! BandProfileCell!
                //let bandnameArray = makeBandNameArray()
                
                if let imageFile = bandArray[selectedBand].objectForKey("photo") as? PFFile {
                    imageFile.getDataInBackgroundWithBlock({
                        (imageData: NSData?, error: NSError?) -> Void in
                        if (error == nil) {
                            cell.bandProfileImage.image = UIImage(data:imageData!)
                        }
                    })
                }
            
                cell.bandName.setTitle(" " + (bandArray[selectedBand].objectForKey("bandname") as! String) + " ▼ ", forState: .Normal)

                //print(bandArray.count)
                //cell.bandPopover.options = bandnameArray.map { KFPopupSelector.Option.Text(text:$0) }
                //cell.bandPopover.selectedIndex = selectedBand
                //cell.bandPopover.labelDecoration = .DownwardTriangle
                cell.genre.text = bandGenre!.uppercaseString
                //cell.genre.text = String(bandArray[selectedBand].objectForKey("genre")!.objectForKey("genre")!).uppercaseString
                
                
                
                return cell
            }
            else if indexPath.section == 1 {
                //if seekInstruments.count > 0 {
                let cell = tableView.dequeueReusableCellWithIdentifier("Seeking") as! InstrumentCell!
                
                for view in cell.instView.subviews {
                    view.removeFromSuperview()
                }
                
                if seekInstruments.count > 0 {
                    cell.instArray = self.seekInstruments
                    cell.loadImages()
                
                }
                return cell
                //}
            }
            else if indexPath.section == 2 {
                let cell = tableView.dequeueReusableCellWithIdentifier("Member") as! MemberCell!
                // ******** Important - this removes existing thumbnails and replaces with new one ********
                for view in cell.memberScrollView.subviews {
                    view.removeFromSuperview()
                }
                //cell.memberScrollView.
                cell.memberArray = self.bandMemberArray
                print("*******tableView - Member********")
                print(cell.memberArray)
                cell.loadImages()
                return cell
            }
            else if indexPath.section == 3{
                let cell = tableView.dequeueReusableCellWithIdentifier("Band Music") as! BandAudioCell!
                //let cell = tableView.dequeueReusableCellWithIdentifier("Audio") as! AudioCell!
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
                let cell = tableView.dequeueReusableCellWithIdentifier("Band Video") as! BandVideoCell!
                //let cell = tableView.dequeueReusableCellWithIdentifier("Video") as! VideoCell!
                cell.title.text = "VDO title" //videoId[indexPath.row]
                let videoId = videoArray[indexPath.row].objectForKey("videoID") as! String
                cell.loadYouTube(videoId)
    //            let cell = tableView.dequeueReusableCellWithIdentifier("Video") as! VideoCell!
    //            cell.title.text = "VDO title" //videoId[indexPath.row]
    //            let videoId = videoArray[indexPath.row].objectForKey("videoID") as! String
    //            cell.loadYouTube(videoId)
                return cell
            }
        }
    }
    
    func tableView(tableView: UITableView, didSelectRowAtIndexPath indexPath: NSIndexPath) {
        if tableView.isEqual(bandSelectDropdownTableView){
            if indexPath.section == 0 {
                self.selectedBand = indexPath.row
                //getBandMember(bandArray[selectedBand].objectId!)
                bandTableView.reloadData()
                self.bandSelectDropdown.hidden = true
                print(selectedBand)
            }
            else{
                performSegueWithIdentifier("Create New Band", sender: self)
            }
        }
    }
    
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
