//
//  EditProfileViewController.swift
//  Bandit
//
//  Created by Piyoros Vephula on 3/24/16.
//  Copyright © 2016 Piyoros Vephula. All rights reserved.
//

import UIKit
import Parse

class EditProfileViewController: UIViewController,UITableViewDelegate,UITableViewDataSource {
    
    let user = PFUser.currentUser()!
    
    let baseUrl = "https://maps.googleapis.com/maps/api/geocode/json?"
    let apikey = "AIzaSyCg_xGAkvB3lYANPhF4oR1UAQduOmQEuac"
    
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
    let genres = ["Pop","Rock","Jazz","Blues","Funk","Soul","Reggae","R&B","Country"]
    var chosenGenres = [String]()
    
    @IBOutlet weak var locationPopup: UIView!
    @IBOutlet weak var confirmButton: UIButton!
    
    var dob:NSDate?
    var loc:String?
    
    @IBAction func chooseLocation(sender: UITextField) {
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
    
    @IBAction func detectLocation(sender: UIButton) {
        
        locationInput.text = "94103"
    }
    
    @IBAction func locationConfirmed(sender: UIButton) {
        
        loc = getCityForZip(locationInput.text!)
        locationText.text = loc
        genreBackground.hidden = true
        locationPopup.hidden = true
    }
    
    @IBOutlet weak var dateText: UITextField!
    var datePicker = UIDatePicker()
    
    @IBOutlet weak var locationText: UITextField!
    @IBOutlet weak var locationInput: UITextField!
    
    @IBOutlet weak var locationToolbar: UIToolbar!
    
    @IBAction func saveData(sender: UIButton) {
        
        
        // save data
        if fullName.text != nil {
            user["fullName"] = fullName.text
        }
        if dob != nil {
            user["birth"] = dob
        }
        if loc != nil {
            user["location"] = loc
        }
        user.saveInBackgroundWithBlock({
            (success: Bool, error: NSError?) -> Void in
            if error == nil {
                print("user class saved")
            }else {
                print(error)
            }
        })
        
        let deleteInst = PFQuery(className: "UserInst")
        deleteInst.whereKey("user", equalTo: user)
        deleteInst.findObjectsInBackgroundWithBlock({ (objects : [PFObject]?, error: NSError?) -> Void in
            if error == nil {
                for object in objects! {
                    object.deleteInBackground()
                    //do{ try object.delete() } catch{}
                }
            }
        })
        
        let deleteGenre = PFQuery(className: "UserGenre")
        deleteGenre.whereKey("user", equalTo: user)
        deleteGenre.findObjectsInBackgroundWithBlock({ (objects : [PFObject]?, error: NSError?) -> Void in
            if error == nil {
                for object in objects! {
                    object.deleteInBackground()
                    //do{ try object.delete() } catch{}
                }
            }
        })
        
        var saveInst = [PFObject]()
        for instru in chosenInst {
            let inst = PFObject(className: "UserInst")
            inst["user"] = PFUser.currentUser() //curUserId
            inst["instrument"] = instru
            saveInst.append(inst)
        }
        do{ try PFObject.saveAll(saveInst) } catch{}
        
        var saveGenre = [PFObject]()
        for g in chosenGenres {
            let gnr = PFObject(className: "UserGenre")
            gnr["user"] = PFUser.currentUser() //curUserId
            gnr["genre"] = g
            saveGenre.append(gnr)
        }
        do{ try PFObject.saveAll(saveGenre) } catch{}
        
        self.navigationController?.popViewControllerAnimated(true)
        
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
        chosenGenres = [String]()
        genreDropdown.hidden = false
        genreBackground.hidden = false
    }
    
    func okActionTapped(obj: AnyObject) {
        
    }
    
    func searchLocation(obj: AnyObject) {
        
    }
    
    func dateTapped(tv: AnyObject){
        datePicker.hidden = false
        dateText.userInteractionEnabled = false
        print("show date picker")
    }
    
    func doneClick() {
        let dateFormatter = NSDateFormatter()
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
    
    func tableView(tableView: UITableView, didSelectRowAtIndexPath indexPath: NSIndexPath) {
        tableView.cellForRowAtIndexPath(indexPath)?.accessoryType = UITableViewCellAccessoryType.Checkmark
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
    
    func fillInTheBlank() {
        fullName.text = user["fullName"] as! String
        // inst
        chosenInst = getInstruments(user)
        for i in chosenInst {
            switch i {
                case "Vocal"            : vox.alpha = 1.0
                case "Electric Guitar"  : egtr.alpha = 1.0
                case "Bass"             : bass.alpha = 1.0
                case "Drum"             : drum.alpha = 1.0
                case "Keyboard"         : keyb.alpha = 1.0
                case "Acoustic Guitar"  : agtr.alpha = 1.0
                case "Wind"             : wind.alpha = 1.0
                case "Synthesizer"      : synt.alpha = 1.0
                case "Percussion"       : perc.alpha = 1.0
                default                 : othr.alpha = 1.0
            }
        }
        chosenGenres = getGenres(user)
        genreText.text = ""
        var delim = ""
        for genre in chosenGenres {
            genreText.text = "\(genreText.text)\(delim) \(genre)"
            delim = ","
        }
        dob = user["birth"] as! NSDate
        let dateFormatter = NSDateFormatter()
        dateFormatter.dateStyle = .ShortStyle
        dateText.text = dateFormatter.stringFromDate(dob!)
        locationText.text = user["location"] as! String
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        fillInTheBlank()
        
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
        
        self.confirmButton.layer.borderWidth = 2
        self.confirmButton.layer.borderColor = AppearanceHelper.itemColor().CGColor
        self.confirmButton.layer.cornerRadius = 5
    }
    
    override func viewWillAppear(animated: Bool) {
        genreDropdown.hidden = true
        genreBackground.hidden = true
        
        locationPopup.hidden = true
        locationToolbar.backgroundColor = UIColor.clearColor()

    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
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
