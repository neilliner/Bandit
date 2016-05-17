//
//  Step1ViewController.swift
//  Bandit
//
//  Created by Piyoros Vephula on 2/21/16.
//  Copyright © 2016 Piyoros Vephula. All rights reserved.
//

import UIKit
import Parse

class Step1ViewController: UIViewController,UITableViewDelegate,UITableViewDataSource, UITextFieldDelegate {
    
    let baseUrl = "https://maps.googleapis.com/maps/api/geocode/json?"
    let apikey = "AIzaSyCg_xGAkvB3lYANPhF4oR1UAQduOmQEuac"
    
    @IBOutlet weak var point1: UIView!
    @IBOutlet weak var point2: UIView!
    @IBOutlet weak var point3: UIView!
    
    @IBOutlet weak var fullName: UITextField!
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
    
    @IBOutlet weak var genreText: UITextView!
    @IBOutlet weak var genreDropdown: UIView!
    @IBOutlet weak var genreBackground: UIView!
    @IBOutlet weak var genreTableView: UITableView!
    //@IBOutlet weak var genrePicker: UIPickerView!
    let genres = ["Pop","Rock","Jazz","Blues","Funk","Soul","Reggae","R&B","Country"]
    var chosenGenres = [String]()
    
    @IBOutlet weak var locationPopup: UIView!
    @IBOutlet weak var confirmButton: UIButton!
    
    var loc:String?
    @IBAction func chooseLocation(sender: UITextField) {
//        let alert = UIAlertController(title: "Set Your Location", message: "Enter location or tap \"Use GPS\"", preferredStyle: UIAlertControllerStyle.Alert)
//        alert.addTextFieldWithConfigurationHandler(configurationTextField)
//        let ok = UIAlertAction(title: "Confirm", style: UIAlertActionStyle.Default, handler: self.okActionTapped)
//        alert.addAction(ok)
//        let gps = UIAlertAction(title: "Use GPS", style: UIAlertActionStyle.Default, handler: self.searchLocation)
//        alert.addAction(gps)
//        let cancel = UIAlertAction(title: "Cancel", style: UIAlertActionStyle.Cancel, handler: { (action: UIAlertAction) -> Void in
//            print("Cancel Button Tapped")
//            
//            self.navigationController?.popToRootViewControllerAnimated(true)
//        })
//        alert.addAction(cancel)
//        
//        self.presentViewController(alert, animated: true, completion: nil)
        //loc =
        genreBackground.hidden = false
        locationPopup.hidden = false
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

    
//    func configurationTextField(textField: UITextField!)
//    {
//        print("generating the TextField")
//        textField.placeholder = "Enter a city or ZIP code"
//        //textField.borderStyle = UITextBorderStyle.RoundedRect
//        //tField = textField
//    }
    
    @IBAction func detectLocation(sender: UIButton) {
        
        locationInput.text = "94103"
    }
    
    @IBAction func closeLocationPopup(sender: UIBarButtonItem) {
        locationPopup.hidden = true
        genreBackground.hidden = true
    }
    
    @IBAction func locationConfirmed(sender: UIButton) {
        
        loc = getCityForZip(locationInput.text!)
        locationText.text = loc
        genreBackground.hidden = true
        locationPopup.hidden = true
    }
    
    @IBOutlet weak var dateText: UITextField!
    //@IBOutlet weak var datePicker: UIDatePicker!
    var datePicker = UIDatePicker()
    
    @IBOutlet weak var locationText: UITextField!
    @IBOutlet weak var locationInput: UITextField!
    
    @IBOutlet weak var locationToolbar: UIToolbar!
    
    @IBAction func next(sender: UIButton) {
        
        //let curUserId = PFUser.currentUser()?.objectId
        // save data
        let user = PFUser.currentUser()!
        user["fullName"] = fullName.text
        user["birth"] = dob
        user["location"] = loc
        user.saveInBackgroundWithBlock({
            (success: Bool, error: NSError?) -> Void in
            if error == nil {
                print("user class saved")
            }else {
                print(error)
            }
        })
        
//        let profile = PFObject(className: "Profile")
//        profile["user"] = curUserId
        
        var saveInst = [PFObject]()
        //inst["instrument"] = chosenInst
        for instru in chosenInst {
            let inst = PFObject(className: "UserInst")
            inst["user"] = PFUser.currentUser() //curUserId
            inst["instrument"] = instru
            saveInst.append(inst)
            
//            do{
//                try inst.save()
//                
//                print("##########################")
//            }
//            catch {
//                
//            }
        }
        PFObject.saveAllInBackground(saveInst)
        
        var saveGenre = [PFObject]()
        
        for g in chosenGenres {
            let gnr = PFObject(className: "UserGenre")
            gnr["user"] = PFUser.currentUser() //curUserId
            gnr["genre"] = g
            saveGenre.append(gnr)
//            do{
//                try gnr.save()
//                print("$$$$$$$$$$$$$$$$$$$$$$$$$$")
//            }
//            catch {
//                
//            }
        }
        PFObject.saveAllInBackground(saveGenre)
        
        //let gen = PFObject(className: "gender")
        
        self.performSegueWithIdentifier("ToStep2", sender: sender)
    }
    
    @IBAction func logout(sender: UIButton) {
        PFUser.logOut()
        performSegueWithIdentifier("logout from step1", sender: sender)
    }
    
    @IBAction func genreDoneSelection(sender: UIButton) {
        genreDropdown.hidden = true
        genreBackground.hidden = true
        genreText.text = ""
        var delim = ""
        for genre in chosenGenres {            
            genreText.text = "\(genreText.text)\(delim) \(genre)"
            delim = ","
        }
    }
    
    @IBAction func hideAgeChanged(sender: UISwitch) {
        print(sender.on)
    }
    
    @IBAction func genderChanged(sender: UISegmentedControl) {
        switch sender.selectedSegmentIndex {
        case 0:
            print("male")
        case 1:
            print("female")
        case 2:
            print("other")
        default:
            print("You shouldn't be here")
        }
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
    
    func genreTapped(textView: AnyObject){
        // show genre selection
        genreDropdown.hidden = false
        genreBackground.hidden = false
        // genrePicker.hidden = false
    }
    
//    func locationTapped(tv: AnyObject){
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
//    }
    
    func okActionTapped(obj: AnyObject) {
        
    }
    
    func searchLocation(obj: AnyObject) {
        
    }
    
    func dateTapped(tv: AnyObject){
        datePicker.hidden = false
        dateText.userInteractionEnabled = false
        print("show date picker")
    }
    
    var dob:NSDate?
    func doneClick() {
        var dateFormatter = NSDateFormatter()
        //dateFormatter.dateFormat = "dd-MM-yyyy"
        dateFormatter.dateStyle = .ShortStyle
        dateText.text = dateFormatter.stringFromDate(datePicker.date)
        dateText.resignFirstResponder()
        
        dob = datePicker.date
    }
    
    func cancelClick() {
        dateText.resignFirstResponder()
    }
    
    func numberOfSectionsInTableView(tableView: UITableView) -> Int {
        return 1
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
    
//    func tableView(tableView: UITableView, didSelectRowAtIndexPath indexPath: NSIndexPath) {
//        if let cell = tableView.cellForRowAtIndexPath(indexPath) {
//            if cell.accessoryType == .Checkmark
//            {
//                cell.accessoryType = .None
//                //checked[indexPath.row] = false
//            }
//            else
//            {
//                cell.accessoryType = .Checkmark
//                
//                chosenGenres.append((cell.textLabel?.text)!)
//                //checked[indexPath.row] = true
//            }
//        }
//    }
    
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
    
//    // returns the number of 'columns' to display.
//    func numberOfComponentsInPickerView(pickerView: UIPickerView) -> Int{
//        return 1
//    }
//    
//    // returns the # of rows in each component..
//    func pickerView(pickerView: UIPickerView, numberOfRowsInComponent component: Int) -> Int{
//        return genres.count
//    }
//    
//    func pickerView(pickerView: UIPickerView, titleForRow row: Int, forComponent component: Int) -> String? {
//        return genres[row]
//    }
//    
//    func pickerView(pickerView: UIPickerView, viewForRow row: Int, forComponent component: Int, reusingView view: UIView?) -> UIView {
//
//    }
//    
//    func pickerView(pickerView: UIPickerView, didSelectRow row: Int, inComponent component: Int)
//    {
//        genreText.text = genres[row]
//        //genrePicker.hidden = true;
//    }

    override func viewDidLoad() {
        super.viewDidLoad()
        
        //http://stackoverflow.com/questions/26070242/move-view-with-keyboard-using-swift
//        NSNotificationCenter.defaultCenter().addObserver(self, selector: Selector("keyboardWillShow:"), name: UIKeyboardWillShowNotification, object: nil)
//        NSNotificationCenter.defaultCenter().addObserver(self, selector: Selector("keyboardWillHide:"), name: UIKeyboardWillHideNotification, object: nil)
        
        self.fullName.delegate = self
        
        point1.layer.borderWidth = 2
        point1.layer.borderColor = AppearanceHelper.itemColor().CGColor
        
        point1.layer.cornerRadius = point1.frame.size.width/2
        point1.clipsToBounds = true
        
        point2.layer.cornerRadius = point2.frame.size.width/2
        point2.clipsToBounds = true
        
        point3.layer.cornerRadius = point3.frame.size.width/2
        point3.clipsToBounds = true
        
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
        
        let tap: UITapGestureRecognizer = UITapGestureRecognizer(target: self, action: "dismissKeyboard")
        locationPopup.addGestureRecognizer(tap)
        
//        let tapDate = UITapGestureRecognizer(target:self, action:Selector("dateTapped:"))
//        dateText.addGestureRecognizer(tapDate)
        //dateText.addTarget(self, action: "dateTapped:", forControlEvents: UIControlEvents.EditingDidBegin)
        
//        var pickerView = UIPickerView(frame: CGRectMake(0, 200, view.frame.width, 300))
//        pickerView.backgroundColor = .whiteColor()
//        pickerView.showsSelectionIndicator = true
//        
//        var toolBar = UIToolbar()
//        toolBar.barStyle = UIBarStyle.Default
//        toolBar.translucent = true
//        toolBar.tintColor = UIColor(red: 76/255, green: 217/255, blue: 100/255, alpha: 1)
//        toolBar.sizeToFit()
//        
//        
//        var doneButton = UIBarButtonItem(title: "Done", style: UIBarButtonItemStyle.Bordered, target: self, action: "donePicker")
//        var spaceButton = UIBarButtonItem(barButtonSystemItem: UIBarButtonSystemItem.FlexibleSpace, target: nil, action: nil)
//        var cancelButton = UIBarButtonItem(title: "Cancel", style: UIBarButtonItemStyle.Bordered, target: self, action: "canclePicker")
//        
//        toolBar.setItems([cancelButton, spaceButton, doneButton], animated: false)
//        toolBar.userInteractionEnabled = true
//        
//        dateText.inputView = pickerView
//        dateText.inputAccessoryView = toolBar
        // Sets up the "button"
        //dateText.text = "Pick a due date"
        //dateText.textAlignment = .Center
        
        // Removes the indicator of the UITextField
        //dateText.tintColor = UIColor.clearColor()
        
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
        dateText.inputView = datePicker
        dateText.inputAccessoryView = toolBar
        
//        let tapLocation = UITapGestureRecognizer(target:self, action:Selector("locationTapped:"))
//        locationText.addGestureRecognizer(tapLocation)
        
        self.confirmButton.layer.borderWidth = 2
        self.confirmButton.layer.borderColor = AppearanceHelper.itemColor().CGColor
        self.confirmButton.layer.cornerRadius = 5
    }
    
    override func viewWillAppear(animated: Bool) {
        genreDropdown.hidden = true
        genreBackground.hidden = true
        
        locationPopup.hidden = true
        locationToolbar.backgroundColor = UIColor.clearColor()
        
//        datePicker.backgroundColor = UIColor.whiteColor()
        //datePicker.hidden = true
    }

    func textFieldShouldReturn(textField: UITextField) -> Bool {
        self.view.endEditing(true)
        return false
    }
    
    func dismissKeyboard() {
        //Causes the view (or one of its embedded text fields) to resign the first responder status.
        view.endEditing(true)
    }
    
//    func keyboardWillShow(notification: NSNotification) {
//        
//        if let keyboardSize = (notification.userInfo?[UIKeyboardFrameBeginUserInfoKey] as? NSValue)?.CGRectValue() {
//            self.view.frame.origin.y -= keyboardSize.height
//        }
//        
//    }
//    
//    func keyboardWillHide(notification: NSNotification) {
//        if let keyboardSize = (notification.userInfo?[UIKeyboardFrameBeginUserInfoKey] as? NSValue)?.CGRectValue() {
//            self.view.frame.origin.y += keyboardSize.height
//        }
//    }


}
