//
//  BoardDetailViewController.swift
//  Bandit
//
//  Created by Piyoros Vephula on 12/5/15.
//  Copyright © 2015 Piyoros Vephula. All rights reserved.
//

import UIKit
import Parse
//import ParseUI

class BoardDetailViewController: UITableViewController, UITextViewDelegate {

    @IBOutlet var boardDetailTableView: UITableView!
    let user = PFUser.currentUser()!
    //var subjectId:String?
    var commentArray = [PFObject]()
    var commentCount = 0
    var boardObject:PFObject?
    var myComment = ""
    var placeholderDeleted = false
    
//    override init(style: UITableViewStyle, className: String!) {
//        super.init(style: style, className: className)
//    }
//    
//    required init!(coder aDecoder: NSCoder) {
//        super.init(coder: aDecoder)
//        
//        // Configure the PFQueryTableView
//        self.parseClassName = "Board"
//        self.textKey = "subject"
//        self.pullToRefreshEnabled = true
//        self.paginationEnabled = false
//    }
//    
//    // Define the query that will provide the data for the table view
//    override func queryForTable() -> PFQuery{
//        let query = PFQuery(className: "Board")
//        query.whereKey("objectId", equalTo: subjectId!)
//        query.includeKey("user")
//        query.includeKey("band")
//        query.includeKey("instrument")
//        query.includeKey("genre")
//        return query
//    }
    
    
    func textViewDidChange(textView: UITextView) {
        //print("textViewDidChange")
        myComment = textView.text
        print(myComment)
    }
    func textViewDidBeginEditing(textView: UITextView) {
        
        print("Begin Editing")
        //if textView.textColor == UIColor.lightGrayColor() {
        if placeholderDeleted == false {
            textView.text = ""
            textView.textColor = AppearanceHelper.itemColor()
            placeholderDeleted = true
        }
    }
    
    func textViewDidEndEditing(textView: UITextView) {
        print("End Editing")
        if textView.text.isEmpty {
            textView.text = "Your Comment Here"
            textView.textColor = UIColor.lightGrayColor()
            placeholderDeleted = false
        }
    }
    
    func submitComment(sender: AnyObject){
        
        let boardObj = PFObject(className: "BoardComment")
        boardObj["board"] = boardObject
        boardObj["comment"] = myComment
        boardObj["user"] = user
        boardObj.saveInBackgroundWithBlock({
            (success: Bool, error: NSError?) -> Void in
            if error == nil {
                print("board comment class saved")
            }else {
                print(error)
            }
            if success {
                self.tableView.reloadData()
            }
        })
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        //http://stackoverflow.com/questions/26070242/move-view-with-keyboard-using-swift
        NSNotificationCenter.defaultCenter().addObserver(self, selector: Selector("keyboardWillShow:"), name: UIKeyboardWillShowNotification, object: nil)
        NSNotificationCenter.defaultCenter().addObserver(self, selector: Selector("keyboardWillHide:"), name: UIKeyboardWillHideNotification, object: nil)
        
        boardDetailTableView.rowHeight = UITableViewAutomaticDimension
        boardDetailTableView.estimatedRowHeight = 160.0
        
        self.navigationController?.navigationBar.setBackgroundImage(UIImage(), forBarMetrics: UIBarMetrics.Default)
        self.navigationController?.navigationBar.shadowImage = UIImage()
        self.navigationController?.navigationBar.translucent = true
        //self.navigationController?.title = "AUDITION"
        //self.navigationItem.setHidesBackButton(true, animated: false)
        //self.navigationController?.navigationBar.backItem?.title = ""
        self.navigationController?.navigationBar.topItem?.title = ""
        self.navigationItem.title = boardObject!["boardType"] as! String
        self.navigationController?.navigationBar.titleTextAttributes = [NSForegroundColorAttributeName:AppearanceHelper.itemColor()]
        //self.navigationItem.titleView?.tintColor = AppearanceHelper.itemColor()        
        //self.navigationController?.navigationBar.tintColor = AppearanceHelper.itemColor()
        
    }
    
    override func viewWillAppear(animated: Bool) {
        self.tabBarController?.tabBar.hidden = true
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
    
    func getInstrumentsForBoard(boardItem: PFObject) -> [String] {
        var instruments = [String]()
        var instrumentsObj = [PFObject]()
        let query = PFQuery(className: "BoardInst")
        query.whereKey("boardId", equalTo: boardItem)
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
    
    func getBoardGenres(boardItem: PFObject) -> [String] {
        var genres = [String]()
        var genresObj = [PFObject]()
        let query = PFQuery(className: "BoardGenre")
        query.whereKey("boardObject", equalTo: boardItem)
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
    
    func getComment(boardItem: PFObject) -> [PFObject] {
        //var comments = [String]()
        var commentsObj = [PFObject]()
        let query = PFQuery(className: "BoardComment")
        query.whereKey("board", equalTo: boardItem)
        do{
            
            commentsObj = try query.findObjects()
        }
        catch{
            print("Comment not found")
        }
        
//        for g in commentsObj {
//            comments.append(g.objectForKey("genre") as! String)
//        }
        return commentsObj
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
    
    func applyToJob(obj: AnyObject){
        print("applyToJob")
        
        let alert = UIAlertController(title: "Job applied", message: "Please wait for confirmation.", preferredStyle: UIAlertControllerStyle.Alert)
        let ok = UIAlertAction(title: "OK", style: UIAlertActionStyle.Default, handler: { (action: UIAlertAction) -> Void in
            self.navigationController?.popViewControllerAnimated(true)
        })
        alert.addAction(ok)
        self.presentViewController(alert, animated: true, completion: nil)
    }
    
    override func numberOfSectionsInTableView(tableView: UITableView) -> Int {
        return 6
    }
    
    override func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        if section == 0 {
            return 1
        }
        else if section == 1{
            return 1
        }
        else if section == 2{
            return 1
        }
        else if section == 3{
            return 1
        }
        else if section == 4{
            return getComment(boardObject!).count
        }
        else if section == 5{
            return 1
        }
        else{
            return 1
        }
    }
    override func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell {
        if indexPath.section == 0{
            var cell = tableView.dequeueReusableCellWithIdentifier("Board Detail Header") as! BoardDetailHeaderCell!
            if cell == nil {
                cell = BoardDetailHeaderCell(style: UITableViewCellStyle.Default, reuseIdentifier: "Board Detail Header")
            }
            
            let imageFile = boardObject?["band"].objectForKey("photo") as! PFFile
            imageFile.getDataInBackgroundWithBlock({
                (imageData: NSData?, error: NSError?) -> Void in
                if (error == nil) {
                    cell.creatorImage.image = UIImage(data:imageData!)
                    cell.profileImage.image = UIImage(data:imageData!)
                }
            })
            
            if let subject = boardObject?["subject"] as? String {
                //cell.subject.text = "  \(subject) ".uppercaseString
                cell.subject.text = subject.uppercaseString
            }
            
            if let creator = boardObject?["band"].objectForKey("bandname") as? String {
                cell.creator.text = " \(creator) "
            }
            
//            if let instrument = object?["instrument"].objectForKey("instrument") as? String {
//                cell.instrument.text = instrument
//            }
            
//            if let genre = object?["genre"].objectForKey("genre") as? String {
//                cell.genre.text = genre
//            }
            
            for view in cell.instView.subviews {
                view.removeFromSuperview()
            }
            
            //if self.instArray.count > 0 {
                cell.instArray = getInstrumentsForBoard(boardObject!)
                cell.loadImages()
            //}
            
            
            let genre = makeStringFromArray(getBoardGenres(boardObject!), delim: "•")
            //cell.genre.text = " \(genre) ".lowercaseString
            cell.creator.text = " \(cell.creator.text!) -  \(genre) "
            
//            if let exp = object?["exp"] as? String {
//                cell.level.text = exp
//            }
            
            //cell.dateTime.text = "12/9/15 19:00"
            //cell.compensation.text = "$200"
            
            if let date = boardObject?["date"] {
                let dateFormatter = NSDateFormatter()
                dateFormatter.dateStyle = .ShortStyle
                dateFormatter.timeStyle = .ShortStyle
                cell.dateTime.text = dateFormatter.stringFromDate(date as! NSDate)
            }
            
            if let compensation = boardObject?["compensation"] as? Int {
                cell.compensation.text = "$\(compensation)"
            }
            else{
                cell.compensation.text = ""
            }
            
            cell.applyButton.addTarget(self, action: "applyToJob:", forControlEvents: .TouchUpInside)
        
            return cell
        }
        else if indexPath.section == 1{
            var cell = tableView.dequeueReusableCellWithIdentifier("Board Detail Location") as! LocationCell!

            return cell
        }
        else if indexPath.section == 2{
            var cell = tableView.dequeueReusableCellWithIdentifier("Board Detail Detail") as! BoardDetailDetailCell!
            
            if let detail = boardObject?["detail"] as? String {
                cell.detail.text = detail
            }
            
            return cell
        }
        else if indexPath.section == 4{
            var cell = tableView.dequeueReusableCellWithIdentifier("Board Detail Comment") as! BoardDetailCommentCell!
            
            //get BoardComment Object then assign image and comment to cell
        
            if let comments = getComment(boardObject!) as? [PFObject] {
                commentCount = comments.count
                
                let u = comments[indexPath.row].objectForKey("user") as! PFUser
                let imageFile = u["image"] as! PFFile
                imageFile.getDataInBackgroundWithBlock({
                    (imageData: NSData?, error: NSError?) -> Void in
                    if (error == nil) {
                        cell.userImage.image = UIImage(data:imageData!)
                    }
                })
                
                let user = comments[indexPath.row].objectForKey("user") as! PFUser
                cell.userName.text = user.username
                
                cell.comment.text = comments[indexPath.row].objectForKey("comment") as! String
                
                let date = comments[indexPath.row].createdAt! as NSDate
                let dateFormatter = NSDateFormatter()
                dateFormatter.dateStyle = .ShortStyle
                dateFormatter.timeStyle = .ShortStyle
                cell.dateTime.text = dateFormatter.stringFromDate(date as! NSDate)
                
                print(comments)
            }
            //print(comments)
            
            return cell
        }
        else if indexPath.section == 5{
            var cell = tableView.dequeueReusableCellWithIdentifier("Board Detail Comment Input") as! BoardDetailCommentInputCell!
            
                cell.submitButton.addTarget(self, action: "submitComment:", forControlEvents: .TouchUpInside)
            
                cell.commentText.delegate = self
            return cell
        }
        else{
            var cell = tableView.dequeueReusableCellWithIdentifier("Comment Label") as UITableViewCell!
            return cell
        }
    }
}
