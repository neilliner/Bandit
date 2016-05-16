//
//  CreateBandViewController.swift
//  Bandit
//
//  Created by Piyoros Vephula on 3/25/16.
//  Copyright © 2016 Piyoros Vephula. All rights reserved.
//

import UIKit
import Parse

class CreateBandViewController: UIViewController, UITableViewDelegate, UITableViewDataSource {

    
    @IBOutlet weak var bandName: UITextField!
    
    @IBOutlet weak var genreBackground: UIView!
    @IBOutlet weak var genreDropdown: UIView!
    @IBOutlet weak var genreText: UITextView!
    @IBOutlet weak var genreTableView: UITableView!
    let genres = ["Pop","Rock","Jazz","Blues","Funk","Soul","Reggae","R&B","Country"]
    var chosenGenres = [String]()
    
    var chosenInst = [String]()
    
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
    
    @IBOutlet weak var infoText: UITextView!
    
    @IBOutlet weak var saveButton: UIButton!
    
    @IBAction func saveButtonTapped(sender: UIButton) {
        print("create band")
        
        // save data
        let band = PFObject(className: "Band")
        band["bandname"] = bandName.text
        band["info"] = infoText.text
        do {try band.save()} catch {}
//        band.saveInBackgroundWithBlock({
//            (success: Bool, error: NSError?) -> Void in
//            if error == nil {
//                print("band class saved")
//            }else {
//                print(error)
//            }
//            if success == true {
//                // saved
//            }
//        })
        
        let userBand = PFObject(className: "UserBand")
        userBand["user"] = PFUser.currentUser()!
        userBand["band"] = band
        do {try userBand.save()} catch {}
//        userBand.saveInBackgroundWithBlock({
//            (success: Bool, error: NSError?) -> Void in
//            if error == nil {
//                print("user band class saved")
//            }else {
//                print(error)
//            }
//            if success == true {
//                // saved
//            }
//        })
        
        var saveGenre = [PFObject]()
        
        for g in chosenGenres {
            let gnr = PFObject(className: "BandGenre")
            gnr["band"] = band
            gnr["genre"] = g
            saveGenre.append(gnr)
        }
        PFObject.saveAllInBackground(saveGenre)
        
        var saveInstNeeded = [PFObject]()
        for instru in chosenInst {
            let inst = PFObject(className: "BandSeek")
            inst["band"] = band
            inst["instrument"] = instru
            saveInstNeeded.append(inst)
        }
        PFObject.saveAllInBackground(saveInstNeeded)
        
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
    
    func genreTapped(textView: AnyObject){
        // show genre selection
        genreDropdown.hidden = false
        genreBackground.hidden = false
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
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        //http://stackoverflow.com/questions/26070242/move-view-with-keyboard-using-swift
        NSNotificationCenter.defaultCenter().addObserver(self, selector: Selector("keyboardWillShow:"), name: UIKeyboardWillShowNotification, object: nil)
        NSNotificationCenter.defaultCenter().addObserver(self, selector: Selector("keyboardWillHide:"), name: UIKeyboardWillHideNotification, object: nil)
        
        let tapGenre = UITapGestureRecognizer(target:self, action:Selector("genreTapped:"))
        genreText.addGestureRecognizer(tapGenre)

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
        
        saveButton.layer.borderWidth = 2
        saveButton.layer.borderColor = AppearanceHelper.itemColor().CGColor
        saveButton.layer.cornerRadius = 5

    }
    
    override func viewWillAppear(animated: Bool) {
        genreDropdown.hidden = true
        genreBackground.hidden = true
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

}
