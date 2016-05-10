//
//  ConfirmBandViewController.swift
//  Bandit
//
//  Created by Piyoros Vephula on 3/29/16.
//  Copyright © 2016 Piyoros Vephula. All rights reserved.
//

import UIKit
import Parse
import AVKit
import AVFoundation

class ConfirmBandViewController: UIViewController, UITableViewDataSource, UITableViewDelegate {
    
    // temporary use //
    let user = PFUser.currentUser()!
    
    @IBOutlet var bandTableView: UITableView!
    
    var bandObject:PFObject?
    
    var bandMemberArray = [PFObject]()
    
    var seekInstruments = [String]()
    
    var inboxObject:PFObject?
    var type:String?
    var status:String?
    var senderUser:PFUser?
    
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
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        //self.navigationItem.setHidesBackButton(true, animated:false)
        //getBandProfileObject(self.user)
        bandTableView.rowHeight = UITableViewAutomaticDimension
        bandTableView.estimatedRowHeight = 160.0
        
        getBandMember(bandObject!.objectId!)
        self.seekInstruments = self.getSeekInstruments(bandObject!)
        
        ///////////  temporary /////////////
        self.audioArray = self.getAudioObject(self.user)
        self.videoArray = self.getVideoObject(self.user)
        ///////////  temporary /////////////
    }
    
    override func viewWillAppear(animated: Bool) {
        self.tabBarController?.tabBar.hidden = false
        
        self.navigationController?.navigationBar.setBackgroundImage(UIImage(), forBarMetrics: UIBarMetrics.Default)
        self.navigationController?.navigationBar.shadowImage = UIImage()
        self.navigationController?.navigationBar.translucent = true
        
    }
    
    override func viewDidAppear(animated: Bool) {
        super.viewDidAppear(animated)
        navigationController?.hidesBarsOnSwipe = true
    }
    
    func cancelRequest(sender: AnyObject){
        print("cancelRequest")
        let alert = UIAlertController(title: "Cancel request", message: "Are you sure?", preferredStyle: UIAlertControllerStyle.Alert)
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
    
    func confirmToJoinBand(sender: AnyObject){
        print("confirmToJoinBand")
        let alert = UIAlertController(title: "Confirm", message: "Are you sure to join this band?", preferredStyle: UIAlertControllerStyle.Alert)
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
                    userBand["band"] = self.bandObject
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
    
    func rejectThisBand(sender: AnyObject){
        print("cancelRequest")
        let alert = UIAlertController(title: "Reject invitation", message: "Are you sure?", preferredStyle: UIAlertControllerStyle.Alert)
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
    
    func saveBandJoining(band: PFObject) {
        
        let bandJoining = PFObject(className: "Inbox")
        bandJoining["notificationType"] = "User Joins Band"
        bandJoining["senderUser"] = PFUser.currentUser()
        bandJoining["receiverBand"] = band
        //bandJoining["receiverUser"] = u
        bandJoining["status"] = "pending"
        bandJoining.saveInBackgroundWithBlock({
            (success: Bool, error: NSError?) -> Void in
            if error == nil {
                print("band invite class saved")
            }else {
                print(error)
            }
            if success {
                
                let alert = UIAlertController(title: "Joining request sent", message: "Please wait for the band to confirm.", preferredStyle: UIAlertControllerStyle.Alert)
                let ok = UIAlertAction(title: "OK", style: UIAlertActionStyle.Default, handler: { (action: UIAlertAction) -> Void in
                    self.navigationController?.popViewControllerAnimated(true)
                })
                alert.addAction(ok)
                
                self.presentViewController(alert, animated: true, completion: nil)
            }
        })
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
    
    func makeStringFromArray(array: [String], delim: String) -> String {
        var str = ""
        for el in array {
            var d = ""
            if str.characters.count > 0 { d = " \(delim) " }
            str = "\(str)\(d)\(el)"
        }
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
    
    func getBandMember(bandId: String){
        bandMemberArray = [PFObject]()
        print("###### \(bandMemberArray)")
        var members = [PFObject]()
        var bs = [PFObject]()
        let query = PFQuery(className: "UserBand")
        print("*************getBandMember************** \(bandId)")
        query.whereKey("band", equalTo: PFObject(withoutDataWithClassName: "Band", objectId: bandId))
        do {
            bs = try query.findObjects()
            //print(bs)
            for b in bs {
                members.append(b.objectForKey("user") as! PFObject)
                //self.bandMemberArray.append(band.objectForKey("user") )
                
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
    
    func numberOfSectionsInTableView(tableView: UITableView) -> Int {
        // if tableView.tag == 1{return 1}
        return 5
    }
    
    func tableView(tableView: UITableView, viewForHeaderInSection section: Int) -> UIView? {
        let title: UILabel = UILabel()
        title.text = ""
        title.textAlignment = NSTextAlignment.Center
        
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
        
        var row = 0
        
        switch section {
        case 0: // cover
            if bandObject == nil {
                row = 0
            }
            else {
                row = 1
            }
        case 1: //seek
            if seekInstruments.count == 0 {
                row = 0
            }
            else {
                row = 1
            }
        case 2: row = 1//member
        case 3: row = audioArray.count//music
        case 4: row = videoArray.count//video
        default: row = 0
        }
        return row
    }
    
    func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell {
        
        let bandGenre = makeStringFromArray(getBandGenres(bandObject!), delim: "•")
        if bandObject != nil {
            print("******* bandObject != nil *******")

        }
        
        if indexPath.section == 0 {
            let cell = tableView.dequeueReusableCellWithIdentifier("Band Profile") as! BandProfileCell!

            let imageFile = bandObject!.objectForKey("photo") as! PFFile
            imageFile.getDataInBackgroundWithBlock({
                (imageData: NSData?, error: NSError?) -> Void in
                if (error == nil) {
                    cell.bandProfileImage.image = UIImage(data:imageData!)
                }
            })
            let bname = bandObject!.objectForKey("bandname") as! String
            cell.bandName.setTitle(" \(bname) ", forState: .Normal)
            cell.genre.text = bandGenre.uppercaseString
            cell.actionBackground.hidden = false
            
            if senderUser == user { // I request to join this band
                if status == "pending" {
                    cell.confirmDescription.text = "Be patient. Band members are making a decision on you!"
                    cell.cancelButton.addTarget(self, action: "cancelRequest:", forControlEvents: .TouchUpInside)
                    cell.confirmButton.hidden = true
                    cell.rejectButton.hidden = true
                }
                else if status == "confirmed" {
                    cell.confirmDescription.text = "Congratulations! You have joined \(bname)."
                    cell.confirmButton.hidden = true
                    cell.rejectButton.hidden = true
                    cell.cancelButton.hidden = true
                }
                else if status == "rejected" {
                    cell.confirmDescription.text = "Sorry You were rejected."
                    cell.confirmButton.hidden = true
                    cell.rejectButton.hidden = true
                    cell.cancelButton.hidden = true
                }
                else if status == "cancelled" {
                    cell.confirmDescription.text = "You cancelled the request."
                    cell.confirmButton.hidden = true
                    cell.rejectButton.hidden = true
                    cell.cancelButton.hidden = true
                }
            }
            else{ // Band invites me to join them
                if status == "pending" {
                    cell.confirmDescription.text = "They are interested in you. Will you join them as a band member?"
                    cell.confirmButton.addTarget(self, action: "confirmToJoinBand:", forControlEvents: .TouchUpInside)
                    cell.rejectButton.addTarget(self, action: "rejectThisBand:", forControlEvents: .TouchUpInside)
                    cell.cancelButton.hidden = true
                }
                else if status == "confirmed" {
                    cell.confirmDescription.text = "You agreed to join \(bname)."
                    cell.confirmButton.hidden = true
                    cell.rejectButton.hidden = true
                    cell.cancelButton.hidden = true
                }
                else if status == "rejected" {
                    cell.confirmDescription.text = "You rejected \(bname)."
                    cell.confirmButton.hidden = true
                    cell.rejectButton.hidden = true
                    cell.cancelButton.hidden = true
                }
                else if status == "cancelled" {
                    cell.confirmDescription.text = "\(bname) cancelled the request."
                    cell.confirmButton.hidden = true
                    cell.rejectButton.hidden = true
                    cell.cancelButton.hidden = true
                }
            }
            
            return cell
        }
        else if indexPath.section == 1 {
            let cell = tableView.dequeueReusableCellWithIdentifier("Seeking") as! InstrumentCell!
            
            for view in cell.instView.subviews {
                view.removeFromSuperview()
            }
            
            if seekInstruments.count > 0 {
                cell.instArray = self.seekInstruments
                cell.loadImages()
                
            }
            return cell
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
            print(bandMemberArray)
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
    
    func tableView(tableView: UITableView, didSelectRowAtIndexPath indexPath: NSIndexPath) {
        
    }
    
    override func prepareForSegue(segue: UIStoryboardSegue, sender: AnyObject?) {
        if segue.identifier == "Band Info"{
            let bandInfoVC = segue.destinationViewController as! BandInfoViewController
            bandInfoVC.band = self.bandObject
        }
    }
    
}

