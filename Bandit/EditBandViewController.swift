//
//  EditBandViewController.swift
//  Bandit
//
//  Created by Piyoros Vephula on 3/26/16.
//  Copyright © 2016 Piyoros Vephula. All rights reserved.
//

import UIKit
import Parse
import ParseUI

class EditBandViewController: UIViewController, UITableViewDelegate, UITableViewDataSource {
    
    var band:PFObject?
    @IBOutlet weak var bandName: UITextField!
    
    @IBOutlet weak var genreBackground: UIView!
    @IBOutlet weak var genreDropdown: UIView!
    @IBOutlet weak var genreText: UITextView!
    @IBOutlet weak var genreTableView: UITableView!
    let genres = ["Pop","Rock","Jazz","Blues","Funk","Soul","Reggae","R&B","Country"]
    var chosenGenres = [String]()
    
    var chosenInst = [String]()
    var seekInstruments = [String]()
    
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
    
    @IBOutlet weak var memberScrollView: UIScrollView!
    var bandMemberArray = [PFObject]()
    var widthOfScrollView:CGFloat = 0.0
    
    @IBOutlet weak var infoText: UITextView!
    
    @IBOutlet weak var saveButton: UIButton!
    @IBOutlet weak var quitBandButton: UIButton!
    
    var selectedMemberToSack: PFImageView?
    
    @IBAction func saveButtonTapped(sender: UIButton) {
        print("create band")
        
        // save data
        if let bn = bandName.text{
            band!["bandname"] = bn
        }
        if let info = infoText.text{
            band!["info"] = info
        }
        band!.saveInBackgroundWithBlock({
            (success: Bool, error: NSError?) -> Void in
            if error == nil {
                print("band class saved")
            }else {
                print(error)
            }
        })
        
        let deleteInst = PFQuery(className: "BandSeek")
        deleteInst.whereKey("band", equalTo: band!)
        deleteInst.findObjectsInBackgroundWithBlock({ (objects : [PFObject]?, error: NSError?) -> Void in
            if error == nil {
                for object in objects! {
                    object.deleteInBackground()
                    //do{ try object.delete() } catch{}
                }
            }
        })
        
        let deleteGenre = PFQuery(className: "BandGenre")
        deleteGenre.whereKey("band", equalTo: band!)
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
            let inst = PFObject(className: "BandSeek")
            inst["band"] = band!
            inst["instrument"] = instru
            saveInst.append(inst)
        }
        do{ try PFObject.saveAll(saveInst) } catch{}
        
        var saveGenre = [PFObject]()
        for g in chosenGenres {
            let gnr = PFObject(className: "BandGenre")
            gnr["band"] = band!
            gnr["genre"] = g
            saveGenre.append(gnr)
        }
        do{ try PFObject.saveAll(saveGenre) } catch{}
        
        self.navigationController?.popViewControllerAnimated(true)
        
    }
    
    @IBAction func quitBandButtonTapped(sender: UIButton) {
        let alert = UIAlertController(title: "Quit Band", message: "Are you sure you want to quit this band?", preferredStyle: UIAlertControllerStyle.Alert)
        let ok = UIAlertAction(title: "OK", style: UIAlertActionStyle.Default, handler: self.quitBand)
        alert.addAction(ok)
        
        let cancel = UIAlertAction(title: "Cancel", style: UIAlertActionStyle.Cancel, handler: { (action: UIAlertAction) -> Void in
            print("Cancel Button Tapped")
        })
        alert.addAction(cancel)
        self.presentViewController(alert, animated: true, completion: nil)
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
    
    func memberPressed(sender: UILongPressGestureRecognizer){
        print("member pressed")
        print(sender)
        selectedMemberToSack = sender.view as! PFImageView
        
        let alert = UIAlertController(title: "Sack Member", message: "Are you sure to sack this member?", preferredStyle: UIAlertControllerStyle.Alert)
        let ok = UIAlertAction(title: "OK", style: UIAlertActionStyle.Default, handler: self.okActionTapped)
        alert.addAction(ok)
        
        let cancel = UIAlertAction(title: "Cancel", style: UIAlertActionStyle.Cancel, handler: { (action: UIAlertAction) -> Void in
            print("Cancel Button Tapped")
            //self.navigationController?.popViewControllerAnimated(true)
        })
        alert.addAction(cancel)
        self.presentViewController(alert, animated: true, completion: nil)

    }
    
    func quitBand(obj: AnyObject){
        let query = PFQuery(className: "UserBand")
        query.whereKey("user", equalTo: PFUser.currentUser()!)
        query.whereKey("band", equalTo: band!)
        query.findObjectsInBackgroundWithBlock({ (objects : [PFObject]?, error: NSError?) -> Void in
            if error == nil {
                for object in objects! {
                    do { try object.delete() } catch {}
                    // delete the band if no member
//                    let q = PFQuery(className: "UserBand")
//                    q.whereKey("band", equalTo: band!)
//                    q.findObjectsInBackgroundWithBlock({ (objects : [PFObject]?, error: NSError?) -> Void in
//                        if error == nil {
//                            for object in objects! {
//                                
//                            }
//                        }
//                    })
                    self.navigationController?.popToRootViewControllerAnimated(true)
                }
            }
        })
    }
    
    func okActionTapped(obj: AnyObject){
        // sack him
        print("Sack him!")
        //print(obj)
        var userToSack:PFUser?
        
        let queryUser = PFQuery(className: "_User")
        queryUser.whereKey("image", equalTo: (selectedMemberToSack?.file!.name)!)
        queryUser.findObjectsInBackgroundWithBlock({ (objects : [PFObject]?, error: NSError?) -> Void in
            if error == nil {
                for object in objects! {
                    
                    userToSack = object as! PFUser
                    //object.deleteInBackground()
                    //self.navigationController?.popViewControllerAnimated(true)
                    let query = PFQuery(className: "UserBand")
                    query.whereKey("user", equalTo: userToSack!)
                    query.findObjectsInBackgroundWithBlock({ (objects : [PFObject]?, error: NSError?) -> Void in
                        if error == nil {
                            for object in objects! {
                                do { try object.delete() } catch {}
                                for view in self.memberScrollView.subviews {
                                    view.removeFromSuperview()
                                }
                                self.getBandMember(self.band!)
                                self.loadImages()
                                //self.loadView()
                                //self.navigationController?.popViewControllerAnimated(true)
                            }
                        }
                    })
                }
            }
        })
    }
    
    func fillInTheBlank() {
        bandName.text = band!["bandname"] as? String
        // inst
        chosenInst = getSeekInstruments(band!)
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
        chosenGenres = getBandGenres(band!)
        genreText.text = ""
        var delim = ""
        for genre in chosenGenres {
            genreText.text = "\(genreText.text)\(delim) \(genre)"
            delim = ","
        }
        
        infoText.text = band!["info"] as? String
    }
    
    func genreTapped(textView: AnyObject){
        // show genre selection
        genreDropdown.hidden = false
        genreBackground.hidden = false
    }
    
    func getBandGenres(band: PFObject) -> [String] {
        var genres = [String]()
        var genresObj = [PFObject]()
        let query = PFQuery(className: "BandGenre")
        query.whereKey("band", equalTo: band)
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
    
    func getSeekInstruments(band: PFObject) -> [String] {
        
        seekInstruments = [String]()
//        print("###################")
//        print(seekInstruments)
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
        //print("###### \(bandMemberArray)")
        var members = [PFObject]()
        var bs = [PFObject]()
        let query = PFQuery(className: "UserBand")
        query.whereKey("band", equalTo: band)
    
        do {
            bs = try query.findObjects()
            //print(bs)
            for b in bs {
                members.append(b.objectForKey("user") as! PFObject)
            }
            bandMemberArray = members
            print(bandMemberArray)
        }
        catch {
            // error
            print("Member not found")
        }
        //print(members)
    }
    
    func loadImages() {
        
        let imgWH = 65;
        let imgMargin = 10;
        var xPos = 0
        
        for var i = 0 ; i < bandMemberArray.count ; i++ {
            
            
            xPos = ((imgWH + imgMargin) * i)
            
            let pfImageView = PFImageView(frame: CGRect(x: xPos, y: 0, width: imgWH, height: imgWH))
            
            let longPressGestureRecognizer = UILongPressGestureRecognizer(target:self, action:Selector("memberPressed:"))
            pfImageView.userInteractionEnabled = true
            pfImageView.addGestureRecognizer(longPressGestureRecognizer)
            
            widthOfScrollView = CGFloat(xPos)
            
            //memberScrollView.addSubview(pfImageView)
            memberScrollView.insertSubview(pfImageView, belowSubview: genreBackground)
            //pfImageView.backgroundColor = UIColor.redColor()
            let imageFile = bandMemberArray[i].objectForKey("image") as! PFFile
            pfImageView.file = imageFile
            
            print("\(bandMemberArray)")
            
            pfImageView.loadInBackground()
            pfImageView.layer.masksToBounds = false
            pfImageView.layer.cornerRadius = pfImageView.frame.size.width/2
            pfImageView.clipsToBounds = true
        }
        
        memberScrollView.contentSize = CGSize(width: widthOfScrollView + CGFloat(imgWH), height: CGFloat(imgWH))
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
        
        fillInTheBlank()
        getBandMember(band!)
        //loadImages()
        
        
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
        
        quitBandButton.layer.borderWidth = 2
        quitBandButton.layer.borderColor = AppearanceHelper.itemColor().CGColor
        quitBandButton.layer.cornerRadius = 5
    }
    
    override func viewWillAppear(animated: Bool) {
        
        genreDropdown.hidden = true
        genreBackground.hidden = true
    }
    
    override func viewDidAppear(animated: Bool) {
        loadImages()
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
