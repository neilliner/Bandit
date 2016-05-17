//
//  AddPostViewController.swift
//  Bandit
//
//  Created by Piyoros Vephula on 3/6/16.
//  Copyright © 2016 Piyoros Vephula. All rights reserved.
//

import UIKit
import Parse
import ParseUI

class AddPostViewController: UIViewController,UITableViewDelegate,UITableViewDataSource, UITextFieldDelegate {
    
    let baseUrl = "https://maps.googleapis.com/maps/api/geocode/json?"
    let apikey = "AIzaSyCg_xGAkvB3lYANPhF4oR1UAQduOmQEuac"
    @IBOutlet weak var hiddenView: UIView!
    
    var tappedImage:PFImageView?
    var tappedBand:PFObject?
    @IBOutlet weak var bandLabel: UILabel!
    @IBOutlet weak var bandScrollView: UIScrollView!
    @IBOutlet weak var typeSelector: UISegmentedControl!
    var chosenType:String?
    
    var bandArray = [PFObject]()
    
    @IBOutlet weak var genreLabel: UILabel!
    @IBOutlet weak var genreText: UITextView!
    @IBOutlet weak var genreDropdown: UIView!
    let genres = ["Pop","Rock","Jazz","Blues","Funk","Soul","Reggae","R&B","Country"]
    var chosenGenres = [String]()
    
    @IBOutlet weak var grayLayer: UIView!
    
    @IBOutlet weak var subject: UITextField!

    @IBOutlet weak var vox: UIImageView!
    @IBOutlet weak var egtr: UIImageView!
    @IBOutlet weak var bass: UIImageView!
    @IBOutlet weak var drum: UIImageView!
    @IBOutlet weak var keyb: UIImageView!
    @IBOutlet weak var agtr: UIImageView!
    @IBOutlet weak var wind: UIImageView!
    @IBOutlet weak var synt: UIImageView!
    @IBOutlet weak var perc: UIImageView!
    @IBOutlet weak var othr: UIImageView!
    var chosenInst = [String]()
    
    @IBOutlet weak var compen: UITextField!
    @IBOutlet weak var eventDate: UITextField!
    var datePicker = UIDatePicker()
    var eDate:NSDate?

    @IBOutlet weak var location: UITextField!
    @IBOutlet weak var confirmButton: UIButton!
    var loc:String?
    var geoPoint:PFGeoPoint?
    
    @IBOutlet weak var locationInput: UITextField!
    @IBOutlet weak var locationToolbar: UIToolbar!
    
    @IBOutlet weak var detail: UITextView!
    
    @IBOutlet weak var addPostButton: UIButton!
    @IBOutlet weak var locationPopup: UIView!
    
    @IBAction func addPost(sender: UIButton) {
        
        // save post
        let boardObj = PFObject(className: "Board")
        boardObj["boardType"] = chosenType!
        boardObj["subject"] = subject.text
        boardObj["user"] = PFUser.currentUser() // for record
        
        if tappedBand != nil {
            boardObj["band"] = tappedBand!
        }
        
        if compen.text != "" {
            boardObj["compensation"] = Int(compen.text!)
        }
        if eDate != nil {
            boardObj["date"] = eDate
        }
        if geoPoint != nil {
            boardObj["location"] = geoPoint
        }
        if detail.text != nil {
            boardObj["detail"] = detail.text
        }
        
        boardObj.saveInBackgroundWithBlock({
            (success: Bool, error: NSError?) -> Void in
            if error == nil {
                print("board class saved")
            }else {
                print(error)
            }
            if success {
        
            }
        })
        
        var saveInst = [PFObject]()
        for instru in self.chosenInst {
            let inst = PFObject(className: "BoardInst")
            inst["boardId"] = boardObj
            inst["instrument"] = instru
            saveInst.append(inst)
        }
        do{ try PFObject.saveAll(saveInst) } catch{}
    
        if chosenType == "Jam" {
            var saveGenre = [PFObject]()
            
            for g in chosenGenres {
                
                let bgnr = PFObject(className: "BoardGenre")
                bgnr["boardObject"] = boardObj
                bgnr["genre"] = g
                saveGenre.append(bgnr)
            }
            
            do{ try PFObject.saveAll(saveGenre) } catch{}
        }
        else{
        
            //get genres from band and save to BoardGenre class
            var genresObj = [PFObject]()
            let queryBandGenre = PFQuery(className: "BandGenre")
            queryBandGenre.whereKey("band", equalTo: tappedBand!)
            do{
                
                genresObj = try queryBandGenre.findObjects()
            }
            catch{
                print("Genres not found")
            }
            
            var saveGenre = [PFObject]()
            
            for g in genresObj {
  
                let bgnr = PFObject(className: "BoardGenre")
                bgnr["boardObject"] = boardObj
                bgnr["genre"] = g.objectForKey("genre") as! String
                saveGenre.append(bgnr)
            }
            
            do{ try PFObject.saveAll(saveGenre) } catch{}
            
        }
        
        self.navigationController?.popViewControllerAnimated(true)
    }
    
    func goBack(){
        self.navigationController?.popToRootViewControllerAnimated(true)
    }
    @IBAction func typeSelected(sender: UISegmentedControl) {
        switch sender.selectedSegmentIndex {
        case 0:
            print("Permanent")
            chosenType = "Permanent"
            genreLabel.hidden = true
            genreText.hidden = true
            bandLabel.hidden = false
            bandScrollView.hidden = false
        case 1:
            print("Gig")
            chosenType = "Gig"
            genreLabel.hidden = true
            genreText.hidden = true
            bandLabel.hidden = false
            bandScrollView.hidden = false
        case 2:
            print("Audition")
            chosenType = "Audition"
            genreLabel.hidden = true
            genreText.hidden = true
            bandLabel.hidden = false
            bandScrollView.hidden = false
        case 3:
            print("Jam")
            chosenType = "Jam"
            genreLabel.hidden = false
            genreText.hidden = false
            bandLabel.hidden = true
            bandScrollView.hidden = true
            tappedBand = nil
        default:
            print("You didn't select any type.")
        }
    }
    
    @IBAction func closeLocationPopup(sender: UIBarButtonItem) {
        locationPopup.hidden = true
        grayLayer.hidden = true
    }
    
    @IBAction func locationTextTapped(sender: UITextField) {
        locationPopup.hidden = false
        grayLayer.hidden = false
    }
    
    @IBAction func detectLocation(sender: UIButton) {
        locationInput.text = "94103"
    }
    
    @IBAction func locationConfirmed(sender: UIButton) {
        //loc = getCityForZip(locationInput.text!)
        //location.text = loc
        print(locationInput.text)
        geoPoint = getLatLngForAddress(locationInput.text!)
        location.text = locationInput.text!
        //genreBackground.hidden = true
        locationPopup.hidden = true
        grayLayer.hidden = true
    }
    
    @IBAction func genreDoneSelection(sender: UIButton) {
        genreDropdown.hidden = true
        grayLayer.hidden = true
        genreText.text = ""
        var delim = ""
        for genre in chosenGenres {
            genreText.text = "\(genreText.text)\(delim) \(genre)"
            delim = ","
        }
    }
    
//    func getCityForZip(zipCode: String) -> String{
//        var cityName:String?
//        let url = NSURL(string: "\(baseUrl)address=\(zipCode)&key=\(apikey)")
//        let data = NSData(contentsOfURL: url!)
//        let json = try! NSJSONSerialization.JSONObjectWithData(data!, options: NSJSONReadingOptions.AllowFragments) as! NSDictionary
//        if let result = json["results"] as? NSArray {
//            if let address = result[0]["address_components"] as? NSArray {
//                if let city = address[1] as? NSDictionary {
//                    print("**************")
//                    print(city["long_name"]!)
//                    cityName = city["long_name"] as? String
//                }
//            }
//        }
//        return cityName!
//    }
//    
//    func getLatLngForAddress(address: String) -> PFGeoPoint{
//        var point:PFGeoPoint?
//        
//        let ad = address.stringByReplacingOccurrencesOfString(" ", withString: "%20", options: NSStringCompareOptions.LiteralSearch, range: nil)
//        print(address)
//        let url = NSURL(string: "\(baseUrl)address=%27\(ad)%27&key=\(apikey)")
//
//        let data = NSData(contentsOfURL: url!)
//        let json = try! NSJSONSerialization.JSONObjectWithData(data!, options: NSJSONReadingOptions.AllowFragments) as! NSDictionary
//        if let result = json["results"] as? NSArray {
//            if let geo = result[0]["geometry"] as? NSDictionary {
//                if let ltng = geo["location"] as? NSDictionary {
//                    print("**************")
//                    print(ltng["lat"]!)
//                    print(ltng["lng"]!)
//                    point = PFGeoPoint(latitude: Double(ltng["lat"]! as! NSNumber), longitude: Double(ltng["lng"]! as! NSNumber))
//                }
//            }
//        }
//        return point!
//    }
    
    func getCityForZip(zipCode: String) -> String{
        var cityName:String?
        let url = NSURL(string: "\(baseUrl)address=\(zipCode)&key=\(apikey)")
        let data = NSData(contentsOfURL: url!)
        let json = try! NSJSONSerialization.JSONObjectWithData(data!, options: NSJSONReadingOptions.AllowFragments) as! NSDictionary
        if let result = json["results"] as? NSArray {
            if let address = (result[0] as! NSDictionary)["address_components"] as? NSArray {
                if let city = address[1] as? NSDictionary {
                    print("**************")
                    print(city["long_name"]!)
                    cityName = city["long_name"] as? String
                }
            }
        }
        return cityName!
    }
    
    func getLatLngForAddress(address: String) -> PFGeoPoint{
        var point:PFGeoPoint?
        
        let ad = address.stringByReplacingOccurrencesOfString(" ", withString: "%20", options: NSStringCompareOptions.LiteralSearch, range: nil)
        print(address)
        let url = NSURL(string: "\(baseUrl)address=%27\(ad)%27&key=\(apikey)")
        
        let data = NSData(contentsOfURL: url!)
        let json = try! NSJSONSerialization.JSONObjectWithData(data!, options: NSJSONReadingOptions.AllowFragments) as! NSDictionary
        if let result = json["results"] as? NSArray {
            if let geo = (result[0] as! NSDictionary)["geometry"] as? NSDictionary {
                if let ltng = geo["location"] as? NSDictionary {
                    print("**************")
                    print(ltng["lat"]!)
                    print(ltng["lng"]!)
                    point = PFGeoPoint(latitude: Double(ltng["lat"]! as! NSNumber), longitude: Double(ltng["lng"]! as! NSNumber))
                }
            }
        }
        return point!
    }
    
    func genreTapped(textView: AnyObject){
        // show genre selection
        genreDropdown.hidden = false
        grayLayer.hidden = false
    }
    
    func getUserBands(user: PFUser) -> [PFObject] {
        var bands = [PFObject]()
        let query = PFQuery(className: "UserBand")
        query.whereKey("user", equalTo: user)
        query.includeKey("band")
        do{
            var objs = [PFObject]()
            objs = try query.findObjects()
            for obj in objs {
                bands.append(obj.objectForKey("band") as! PFObject)
            }
        }
        catch{
            print("Band not found")
        }
        return bands
    }
    
    func loadImages() {
        
        var widthOfScrollView:CGFloat = 0.0
        for var i = 0 ; i < bandArray.count ; i++ {
            
            var xPos = 0
            xPos = 0 + (60 * i)
            
            let pfImageView = PFImageView(frame: CGRect(x: xPos, y: 0, width: 50, height: 50))
            
            let tapGestureRecognizer = UITapGestureRecognizer(target:self, action:Selector("imageTapped:"))
            pfImageView.userInteractionEnabled = true
            pfImageView.addGestureRecognizer(tapGestureRecognizer)
            pfImageView.tag = i
            bandScrollView.addSubview(pfImageView)
            
            if let imageFile = bandArray[i].objectForKey("photo") as? PFFile {
                pfImageView.file = imageFile
            }
            else{
                pfImageView.backgroundColor = UIColor.grayColor()
            }
            
            pfImageView.clipsToBounds = true
            pfImageView.contentMode = .ScaleAspectFill
            pfImageView.loadInBackground()
            pfImageView.layer.masksToBounds = false
            pfImageView.layer.cornerRadius = pfImageView.frame.size.width/2
            pfImageView.clipsToBounds = true
        }
        bandScrollView.contentSize = CGSize(width: widthOfScrollView + 50, height: 50)
        
    }
    
    func imageTapped(img: AnyObject) {
        print("imageTapped")
        
        for v in bandScrollView.subviews {
            v.layer.borderWidth = 0
        }
        
        img.view!!.layer.borderColor = AppearanceHelper.itemColor().CGColor
        img.view!!.layer.borderWidth = 3
        self.tappedImage = img.view! as! PFImageView
        self.tappedBand = bandArray[(tappedImage?.tag)!]
        print(tappedBand)
        
    }
    
    func isThere(var strArray:[String],str:String) -> Bool {
        var found = 0
        for var i = 0 ; i < strArray.count ; i++ {
            if strArray[i] == str{
                found++
            }
        }
        if found == 0 {
            return false
        }
        return true
    }
    
    func voxTapped(icon: AnyObject)
    {
        let inst = "Vocal"
        if vox.alpha == 1.0 {
            vox.alpha = 0.5
            if isThere(chosenInst,str: inst) == true{
                chosenInst = chosenInst.filter() {$0 != inst}
            }
        }
        else{
            vox.alpha = 1.0
            if isThere(chosenInst,str: inst) == false{
                chosenInst.append(inst)
            }
        }
        print(chosenInst)
    }
    
    func egtrTapped(icon: AnyObject)
    {
        let inst = "Electric Guitar"
        if egtr.alpha == 1.0 {
            egtr.alpha = 0.5
            if isThere(chosenInst,str: inst) == true{
                chosenInst = chosenInst.filter() {$0 != inst}
            }
        }
        else{
            egtr.alpha = 1.0
            if isThere(chosenInst,str: inst) == false{
                chosenInst.append(inst)
            }
        }
        print(chosenInst)
    }
    
    func bassTapped(icon: AnyObject)
    {
        let inst = "Bass"
        if bass.alpha == 1.0 {
            bass.alpha = 0.5
            if isThere(chosenInst,str: inst) == true{
                chosenInst = chosenInst.filter() {$0 != inst}
            }
        }
        else{
            bass.alpha = 1.0
            if isThere(chosenInst,str: inst) == false{
                chosenInst.append(inst)
            }
        }
        print(chosenInst)
    }
    
    func drumTapped(icon: AnyObject)
    {
        let inst = "Drum"
        if drum.alpha == 1.0 {
            drum.alpha = 0.5
            if isThere(chosenInst,str: inst) == true{
                chosenInst = chosenInst.filter() {$0 != inst}
            }
        }
        else{
            drum.alpha = 1.0
            if isThere(chosenInst,str: inst) == false{
                chosenInst.append(inst)
            }
        }
        print(chosenInst)
    }
    
    func keybTapped(icon: AnyObject)
    {
        let inst = "Keyboard"
        if keyb.alpha == 1.0 {
            keyb.alpha = 0.5
            if isThere(chosenInst,str: inst) == true{
                chosenInst = chosenInst.filter() {$0 != inst}
            }
        }
        else{
            keyb.alpha = 1.0
            if isThere(chosenInst,str: inst) == false{
                chosenInst.append(inst)
            }
        }
        print(chosenInst)
    }
    
    func agtrTapped(icon: AnyObject)
    {
        let inst = "Acoustic Guitar"
        if agtr.alpha == 1.0 {
            agtr.alpha = 0.5
            if isThere(chosenInst,str: inst) == true{
                chosenInst = chosenInst.filter() {$0 != inst}
            }
        }
        else{
            agtr.alpha = 1.0
            if isThere(chosenInst,str: inst) == false{
                chosenInst.append(inst)
            }
        }
        print(chosenInst)
    }
    
    func windTapped(icon: AnyObject)
    {
        let inst = "Wind"
        if wind.alpha == 1.0 {
            wind.alpha = 0.5
            if isThere(chosenInst,str: inst) == true{
                chosenInst = chosenInst.filter() {$0 != inst}
            }
        }
        else{
            wind.alpha = 1.0
            if isThere(chosenInst,str: inst) == false{
                chosenInst.append(inst)
            }
        }
        print(chosenInst)
    }
    
    func syntTapped(icon: AnyObject)
    {
        let inst = "Synthesizer"
        if synt.alpha == 1.0 {
            synt.alpha = 0.5
            if isThere(chosenInst,str: inst) == true{
                chosenInst = chosenInst.filter() {$0 != inst}
            }
        }
        else{
            synt.alpha = 1.0
            if isThere(chosenInst,str: inst) == false{
                chosenInst.append(inst)
            }
        }
        print(chosenInst)
    }
    
    func percTapped(icon: AnyObject)
    {
        let inst = "Percussion"
        if perc.alpha == 1.0 {
            perc.alpha = 0.5
            if isThere(chosenInst,str: inst) == true{
                chosenInst = chosenInst.filter() {$0 != inst}
            }
        }
        else{
            perc.alpha = 1.0
            if isThere(chosenInst,str: inst) == false{
                chosenInst.append(inst)
            }
        }
        print(chosenInst)
    }
    
    func othrTapped(icon: AnyObject)
    {
        let inst = "Other"
        if othr.alpha == 1.0 {
            othr.alpha = 0.5
            if isThere(chosenInst,str: inst) == true{
                chosenInst = chosenInst.filter() {$0 != inst}
            }
        }
        else{
            othr.alpha = 1.0
            if isThere(chosenInst,str: inst) == false{
                chosenInst.append(inst)
            }
        }
        print(chosenInst)
    }
    
    func doneClick() {
        var dateFormatter = NSDateFormatter()
        //dateFormatter.dateFormat = "dd-MM-yyyy"
        dateFormatter.dateStyle = .ShortStyle
        eventDate.text = dateFormatter.stringFromDate(datePicker.date)
        eventDate.resignFirstResponder()
        
        eDate = datePicker.date
    }
    
    func cancelClick() {
        eventDate.resignFirstResponder()
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        bandArray = getUserBands(PFUser.currentUser()!)
        loadImages()
        
        subject.delegate = self
        compen.delegate = self
        
        
        //http://stackoverflow.com/questions/26070242/move-view-with-keyboard-using-swift
        NSNotificationCenter.defaultCenter().addObserver(self, selector: Selector("keyboardWillShow:"), name: UIKeyboardWillShowNotification, object: nil)
        NSNotificationCenter.defaultCenter().addObserver(self, selector: Selector("keyboardWillHide:"), name: UIKeyboardWillHideNotification, object: nil)
        
        self.tabBarController?.tabBar.hidden = true
        self.navigationItem.setHidesBackButton(true, animated:false)
        self.navigationController?.navigationBar.setBackgroundImage(UIImage(), forBarMetrics: UIBarMetrics.Default)
        self.navigationController?.navigationBar.shadowImage = UIImage()
        self.navigationController?.navigationBar.translucent = true
        let stop = UIBarButtonItem(barButtonSystemItem: .Stop, target: self, action: "goBack")
        stop.tintColor = UIColor(red: 0.96862745, green: 0.05093039, blue: 0.32156862, alpha: 1.0)
        self.navigationItem.rightBarButtonItem = stop
        
        // Specifies intput type
        datePicker.datePickerMode = .Date
        
        // Creates the toolbar
        let toolBar = UIToolbar()
        toolBar.barStyle = .Default
        toolBar.translucent = true
        toolBar.tintColor = UIColor(red: 92/255, green: 216/255, blue: 255/255, alpha: 1)
        toolBar.sizeToFit()
        
        // Adds the buttons
        let doneButton = UIBarButtonItem(title: "Done", style: .Plain, target: self, action: "doneClick")
        let spaceButton = UIBarButtonItem(barButtonSystemItem: .FlexibleSpace, target: nil, action: nil)
        let cancelButton = UIBarButtonItem(title: "Cancel", style: .Plain, target: self, action: "cancelClick")
        toolBar.setItems([cancelButton, spaceButton, doneButton], animated: false)
        toolBar.userInteractionEnabled = true
        
        // Adds the toolbar to the view
        eventDate.inputView = datePicker
        eventDate.inputAccessoryView = toolBar
        
        let tapVox = UITapGestureRecognizer(target:self, action:Selector("voxTapped:"))
        vox.userInteractionEnabled = true
        vox.addGestureRecognizer(tapVox)
        
        let tapEgtr = UITapGestureRecognizer(target:self, action:Selector("egtrTapped:"))
        egtr.userInteractionEnabled = true
        egtr.addGestureRecognizer(tapEgtr)
        
        let tapBass = UITapGestureRecognizer(target:self, action:Selector("bassTapped:"))
        bass.userInteractionEnabled = true
        bass.addGestureRecognizer(tapBass)
        
        let tapDrum = UITapGestureRecognizer(target:self, action:Selector("drumTapped:"))
        drum.userInteractionEnabled = true
        drum.addGestureRecognizer(tapDrum)
        
        let tapKeyb = UITapGestureRecognizer(target:self, action:Selector("keybTapped:"))
        keyb.userInteractionEnabled = true
        keyb.addGestureRecognizer(tapKeyb)
        
        let tapAgtr = UITapGestureRecognizer(target:self, action:Selector("agtrTapped:"))
        agtr.userInteractionEnabled = true
        agtr.addGestureRecognizer(tapAgtr)
        
        let tapWind = UITapGestureRecognizer(target:self, action:Selector("windTapped:"))
        wind.userInteractionEnabled = true
        wind.addGestureRecognizer(tapWind)
        
        let tapSynt = UITapGestureRecognizer(target:self, action:Selector("syntTapped:"))
        synt.userInteractionEnabled = true
        synt.addGestureRecognizer(tapSynt)
        
        let tapPerc = UITapGestureRecognizer(target:self, action:Selector("percTapped:"))
        perc.userInteractionEnabled = true
        perc.addGestureRecognizer(tapPerc)
        
        let tapOthr = UITapGestureRecognizer(target:self, action:Selector("othrTapped:"))
        othr.userInteractionEnabled = true
        othr.addGestureRecognizer(tapOthr)
        
        let tapGenre = UITapGestureRecognizer(target:self, action:Selector("genreTapped:"))
        genreText.addGestureRecognizer(tapGenre)
        
        self.addPostButton.layer.borderWidth = 2
        self.addPostButton.layer.borderColor = AppearanceHelper.itemColor().CGColor
        self.addPostButton.layer.cornerRadius = 5
        
        self.confirmButton.layer.borderWidth = 2
        self.confirmButton.layer.borderColor = AppearanceHelper.itemColor().CGColor
        self.confirmButton.layer.cornerRadius = 5
        
        let tap: UITapGestureRecognizer = UITapGestureRecognizer(target: self, action: "dismissKeyboard")
        hiddenView.addGestureRecognizer(tap)
        
    }
    
    override func viewWillAppear(animated: Bool) {
        grayLayer.hidden = true
        locationPopup.hidden = true
        locationToolbar.backgroundColor = UIColor.clearColor()
    }
    
    func dismissKeyboard() {
        view.endEditing(true)
    }
    
    func textFieldShouldReturn(textField: UITextField) -> Bool {
        self.view.endEditing(true)
        return false
    }
    
    func keyboardWillShow(notification: NSNotification) {
        
        if let keyboardSize = (notification.userInfo?[UIKeyboardFrameBeginUserInfoKey] as? NSValue)?.CGRectValue() {
            self.view.frame.origin.y -= keyboardSize.height
        }
        
    }
    
    func keyboardWillHide(notification: NSNotification) {
        if let keyboardSize = (notification.userInfo?[UIKeyboardFrameBeginUserInfoKey] as? NSValue)?.CGRectValue() {
            self.view.frame.origin.y += keyboardSize.height
        }
    }

    func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return genres.count
    }
    
    func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCellWithIdentifier("genre") as UITableViewCell!
        cell.textLabel?.text = genres[indexPath.row]
        cell.textLabel?.textColor = AppearanceHelper.itemColor()
        cell.selectionStyle = UITableViewCellSelectionStyle.None
        return cell
    }
    
    func tableView(tableView: UITableView, didSelectRowAtIndexPath indexPath: NSIndexPath) {
        tableView.cellForRowAtIndexPath(indexPath)?.accessoryType = UITableViewCellAccessoryType.Checkmark
        //tableView.cellForRowAtIndexPath(indexPath)?.backgroundColor = AppearanceHelper.mainColor()
        if isThere(chosenGenres,str: (tableView.cellForRowAtIndexPath(indexPath)?.textLabel?.text)!) == false{
            chosenGenres.append((tableView.cellForRowAtIndexPath(indexPath)?.textLabel?.text!)!)
        }
        
        print(chosenGenres)
    }
    
    func tableView(tableView: UITableView, didDeselectRowAtIndexPath indexPath: NSIndexPath) {
        tableView.cellForRowAtIndexPath(indexPath)?.accessoryType = UITableViewCellAccessoryType.None
        if isThere(chosenGenres,str: (tableView.cellForRowAtIndexPath(indexPath)?.textLabel?.text)!) == true{
            
            
            chosenGenres = chosenGenres.filter() {$0 != (tableView.cellForRowAtIndexPath(indexPath)?.textLabel?.text!)!}
            print(chosenGenres)
        }
    }

}
