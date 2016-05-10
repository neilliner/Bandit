//
//  BoardViewController.swift
//  Bandit
//
//  Created by Piyoros Vephula on 11/17/2558 BE.
//  Copyright © 2558 Piyoros Vephula. All rights reserved.
//

import UIKit
import Parse
import ParseUI

class BoardViewController: PFQueryTableViewController{


    @IBOutlet var boardTableView: UITableView!
    @IBOutlet weak var segctrlSwitch: UISegmentedControl!
    
    var boardObj = [PFObject]()
    var subjectId = [String]()
    var subjectIdIndex:Int?
    var selectedBoard:PFObject?
    
    override init(style: UITableViewStyle, className: String!) {
        super.init(style: style, className: className)
    }

    required init!(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
        
        // Configure the PFQueryTableView
        self.parseClassName = "Board"
        self.textKey = "subject"
        self.pullToRefreshEnabled = true
        self.paginationEnabled = false
    }
    
    // Define the query that will provide the data for the table view
    override func queryForTable() -> PFQuery{
        let query = PFQuery(className: "Board")
        //query.orderByAscending("nameEnglish")
        query.includeKey("user")
        query.includeKey("band")
        query.includeKey("instrument")
        query.includeKey("genre")
        return query
    }
    
    override func prepareForSegue(segue: UIStoryboardSegue, sender: AnyObject?) {
        if segue.identifier == "Open Board Detail"{
            print(self.subjectId[subjectIdIndex!])
            let boardDetailVC = segue.destinationViewController as! BoardDetailViewController
            
            // try sending the whole object selected not just the object ID
            // so it doesn't need to reload everything again
            // search for PFTableView, it might have method to handle this
            boardDetailVC.boardObject = self.selectedBoard
            //boardDetailVC.subjectId = self.subjectId[subjectIdIndex!]
            
//            if let = tableView.indexPathForSelectedRow() { // this will return the index of the row selected
//                
//            }
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
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        self.boardTableView.contentInset = UIEdgeInsetsMake(20, 0, 0, 0)
        
        //let navbg = AppearanceHelper.UIColorFromHex(0x03032B).CGColor
        //navigationController!.navigationBar.barTintColor = UIColor(CGColor: navbg)
        
        self.navigationController?.navigationBar.setBackgroundImage(UIImage(), forBarMetrics: UIBarMetrics.Default)
        self.navigationController?.navigationBar.shadowImage = UIImage()
        self.navigationController?.navigationBar.translucent = true
        
//        segctrlSwitch.layer.borderColor = AppearanceHelper.itemColor().CGColor;
//        segctrlSwitch.layer.cornerRadius = 0.0;
//        segctrlSwitch.layer.borderWidth = 1.5;

        // Uncomment the following line to preserve selection between presentations
        // self.clearsSelectionOnViewWillAppear = false

        // Uncomment the following line to display an Edit button in the navigation bar for this view controller.
        // self.navigationItem.rightBarButtonItem = self.editButtonItem()
        
        
    }
    
    override func viewWillAppear(animated: Bool) {
        self.tabBarController?.tabBar.hidden = false
        segctrlSwitch.removeBorders()
        segctrlSwitch.setTitleTextAttributes([NSForegroundColorAttributeName: UIColor.whiteColor(),NSFontAttributeName: UIFont(name: "HelveticaNeue-Bold", size: 14)!], forState:.Normal)
        segctrlSwitch.setTitleTextAttributes([NSForegroundColorAttributeName: AppearanceHelper.itemColor(),NSFontAttributeName: UIFont(name: "HelveticaNeue-Bold", size: 14)!], forState:.Selected)
        
        
        self.loadObjects()
    }
    
    override func viewDidAppear(animated: Bool) {
        //super.viewDidAppear(animated)
        navigationController?.hidesBarsOnSwipe = true
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    override func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath, object: PFObject?) -> PFTableViewCell {
        
        //print(object)
        // cell.object = object
        
        var cell = tableView.dequeueReusableCellWithIdentifier("BoardCell") as! BoardCell!
        if cell == nil {
            cell = BoardCell(style: UITableViewCellStyle.Default, reuseIdentifier: "BoardCell")
        }
        print("@@@@@@@@@@@@@@@@@@@")
        print(object)
        print("@@@@@@@@@@@@@@@@@@@")

        cell.instArray = getInstrumentsForBoard(object!)
        cell.loadImages()

        // Extract values from the PFObject to display in the table cell
        if let type = object?["boardType"] as? String {
            cell.boardType.text = type
            cell.changeLabel(type)
        }
        
        
        if let subject = object?["subject"] as? String {
            cell.subject.text = "  \(subject) ".uppercaseString
            //cell.subject.text = subject
            var found = 0
            for var i = 0 ; i < self.subjectId.count ; i++ {
                if self.subjectId[i] == object?.objectId as! String!{
                    found++
                }
            }
            if found == 0 {
                
                //TODO:- change this to append the whole object
                self.boardObj.append(object!)
                
                self.subjectId.append(object?.objectId as! String!)
            }
            print(self.subjectId)
        }
        
//        if let board = object {
//            cell.boardObj = board
//        }
        
//        if let creator = object?["user"].objectForKey("fullName") as? String {
//            cell.creator.text = creator
//        }
        
//        if let band = object?["band"].objectForKey("bandname") as? String {
//            cell.band.text = band
//        }
        
        //if let instrument = object?["instrument"].objectForKey("instrument") as? String {
            //let instrument = "Instrument"
         //   cell.instrument.text = instrument
        //}
        
        let genre = makeStringFromArray(getBoardGenres(object!), delim: "•")
        //if let genre = object?["genre"].objectForKey("genre") as? String {
            cell.genre.text = "  \(genre) ".lowercaseString
        //}
        
        if let exp = object?["exp"] as? String {
            cell.exp.text = exp
        }
        
        if let date = object?["date"] {
            let dateFormatter = NSDateFormatter()
            dateFormatter.dateStyle = .ShortStyle
            cell.dateComp.text = dateFormatter.stringFromDate(date as! NSDate)
        }
        
        if let compensation = object?["compensation"] as? Int {
            let comp = "$\(compensation)"
            let sentence = "\(cell.dateComp.text!) - \(comp)"
            
            //let sentence = "Do you want this person to join your band \(bandname)?"
            
            let wordRange = (sentence as NSString).rangeOfString(comp)
            let attributedString = NSMutableAttributedString(string: sentence, attributes: [NSFontAttributeName : UIFont.systemFontOfSize(18, weight: UIFontWeightThin)])
            
            attributedString.setAttributes([NSFontAttributeName : UIFont.systemFontOfSize(18, weight: UIFontWeightBold), NSForegroundColorAttributeName : AppearanceHelper.itemColor()], range: wordRange)
            
            cell.dateComp.attributedText = attributedString
        }
        
        // Display image
        
        //in case jam, get image from user
        if let imageFile = object?["band"].objectForKey("photo") as? PFFile {
            imageFile.getDataInBackgroundWithBlock({
                (imageData: NSData?, error: NSError?) -> Void in
                if (error == nil) {
                    cell.boardImage.image = UIImage(data:imageData!)
                }
            })
        }
        else{            
            let imageFile = object?["user"].objectForKey("image") as! PFFile
                imageFile.getDataInBackgroundWithBlock({
                    (imageData: NSData?, error: NSError?) -> Void in
                    if (error == nil) {
                        cell.boardImage.image = UIImage(data:imageData!)
                    }
                })
        }
        
//        cell.contentView.backgroundColor = UIColor.clearColor()
//        
//        let whiteRoundedView : UIView = UIView(frame: CGRectMake(0, 10, self.view.frame.size.width, 350))
//        
//        whiteRoundedView.layer.backgroundColor = CGColorCreate(CGColorSpaceCreateDeviceRGB(), [1.0, 1.0, 1.0, 1.0])
//        whiteRoundedView.layer.masksToBounds = false
//        whiteRoundedView.layer.cornerRadius = 2.0
//        whiteRoundedView.layer.shadowOffset = CGSizeMake(-1, 1)
//        whiteRoundedView.layer.shadowOpacity = 0.2
//        
//        cell.contentView.addSubview(whiteRoundedView)
//        cell.contentView.sendSubviewToBack(whiteRoundedView)
        
        return cell
    }
    
    override func tableView(tableView: UITableView, didSelectRowAtIndexPath indexPath: NSIndexPath) {

        self.subjectIdIndex = indexPath.row
        self.selectedBoard = boardObj[indexPath.row]
        performSegueWithIdentifier("Open Board Detail", sender: self)
        if let cell = tableView.cellForRowAtIndexPath(indexPath) {
            // cell.object
        }
        
    }

    // MARK: - Table view data source

//    override func numberOfSectionsInTableView(tableView: UITableView) -> Int {
//        // #warning Incomplete implementation, return the number of sections
//        return 0
//    }

//    override func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
//        // #warning Incomplete implementation, return the number of rows
//        return 0
//    }

    /*
    override func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCellWithIdentifier("reuseIdentifier", forIndexPath: indexPath)

        // Configure the cell...

        return cell
    }
    */

    /*
    // Override to support conditional editing of the table view.
    override func tableView(tableView: UITableView, canEditRowAtIndexPath indexPath: NSIndexPath) -> Bool {
        // Return false if you do not want the specified item to be editable.
        return true
    }
    */

    /*
    // Override to support editing the table view.
    override func tableView(tableView: UITableView, commitEditingStyle editingStyle: UITableViewCellEditingStyle, forRowAtIndexPath indexPath: NSIndexPath) {
        if editingStyle == .Delete {
            // Delete the row from the data source
            tableView.deleteRowsAtIndexPaths([indexPath], withRowAnimation: .Fade)
        } else if editingStyle == .Insert {
            // Create a new instance of the appropriate class, insert it into the array, and add a new row to the table view
        }    
    }
    */

    /*
    // Override to support rearranging the table view.
    override func tableView(tableView: UITableView, moveRowAtIndexPath fromIndexPath: NSIndexPath, toIndexPath: NSIndexPath) {

    }
    */

    /*
    // Override to support conditional rearranging of the table view.
    override func tableView(tableView: UITableView, canMoveRowAtIndexPath indexPath: NSIndexPath) -> Bool {
        // Return false if you do not want the item to be re-orderable.
        return true
    }
    */

    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepareForSegue(segue: UIStoryboardSegue, sender: AnyObject?) {
        // Get the new view controller using segue.destinationViewController.
        // Pass the selected object to the new view controller.
    }
    */

}
