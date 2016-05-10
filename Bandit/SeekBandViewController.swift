//
//  SeekBandViewController.swift
//  Bandit
//
//  Created by Piyoros Vephula on 2/21/16.
//  Copyright © 2016 Piyoros Vephula. All rights reserved.
//

import UIKit
import Parse
import ParseUI

class SeekBandViewController: PFQueryTableViewController {

    override init(style: UITableViewStyle, className: String!) {
        super.init(style: style, className: className)
    }
    
    required init!(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
        
        // Configure the PFQueryTableView
        self.parseClassName = "Band"
        self.textKey = "bandname"
        self.pullToRefreshEnabled = true
        self.paginationEnabled = false
    }
    
    //var userArray = [PFObject]()
    var cellObject:PFObject?
    
    @IBOutlet weak var toggleModeSwitch: UISegmentedControl!
    @IBOutlet var seekBandTableView: UITableView!
    
    @IBAction func toggleMode(sender: UISegmentedControl) {
        switch sender.selectedSegmentIndex {
        case 0:
            print("Seek Individual")
            self.navigationController?.popToRootViewControllerAnimated(false)
            //performSegueWithIdentifier("Seek Individual", sender: self)
        case 1:
            print("Seek Band")
            //performSegueWithIdentifier("Seek Band", sender: self)
        default:
            print("You shouldn't be here")
        }
    }
    
    // Define the query that will provide the data for the table view
    override func queryForTable() -> PFQuery{
        let query = PFQuery(className: "Band")
        //query.includeKey("user")
        //query.includeKey("band")
        //query.includeKey("instrument")
        query.includeKey("genre")
        print("queryForTable()")
        return query
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
    
    override func viewDidLoad() {
        super.viewDidLoad()
        print("SeekBandView")
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
    
    override func viewWillAppear(animated: Bool) {
        
        self.navigationController?.navigationBar.setBackgroundImage(UIImage(), forBarMetrics: UIBarMetrics.Default)
        self.navigationController?.navigationBar.shadowImage = UIImage()
        self.navigationController?.navigationBar.translucent = true
        
        self.navigationItem.setHidesBackButton(true, animated:false)
        toggleModeSwitch.selectedSegmentIndex = 1
        
//        toggleModeSwitch.layer.borderColor = AppearanceHelper.itemColor().CGColor;
//        toggleModeSwitch.layer.cornerRadius = 0.0;
//        toggleModeSwitch.layer.borderWidth = 1.5;
        toggleModeSwitch.removeBorders()
        toggleModeSwitch.setTitleTextAttributes([NSForegroundColorAttributeName: UIColor.whiteColor(),NSFontAttributeName: UIFont(name: "HelveticaNeue-Bold", size: 14)!], forState:.Normal)
        toggleModeSwitch.setTitleTextAttributes([NSForegroundColorAttributeName: AppearanceHelper.itemColor(),NSFontAttributeName: UIFont(name: "HelveticaNeue-Bold", size: 14)!], forState:.Selected)
        
        self.tabBarController?.tabBar.hidden = false
    }
    
    override func viewDidAppear(animated: Bool) {
        super.viewDidAppear(animated)
    }
    
    override func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath, object: PFObject?) -> PFTableViewCell? {
        //print("*****************************")
        //print(object)
        //print("*****************************")
        
        
        var bandGenre:String?
        bandGenre = makeStringFromArray(getBandGenres(object!), delim: "•").lowercaseString
        
        var cell = tableView.dequeueReusableCellWithIdentifier("Seek Band Cell") as! SeekBandCell!
        //        if cell == nil {
        //            cell = SeekCell(style: UITableViewCellStyle.Default, reuseIdentifier: "Seek Cell")
        //        }
        
        cell.object = object
        // Extract values from the PFObject to display in the table cell
        if let bandName = object?["bandname"] as? String {
            cell.bandName.text = "  \(bandName) ".uppercaseString
            //            var found = 0
            //            for var i = 0 ; i < self.subjectId.count ; i++ {
            //                if self.subjectId[i] == object?.objectId as! String!{
            //                    found++
            //                }
            //            }
            //            if found == 0 {
            //
            //                //TODO:- change this to append the whole object
            //
            //                self.subjectId.append(object?.objectId as! String!)
            //            }
            //            print(self.subjectId)
        }
        
        if let genre = bandGenre {
            //let spaces = String(count: 5, repeatedValue: (" " as Character))
            cell.genre.text = "   \(genre) "
        }
        
        // Display image
        if let imageFile = object?["photo"] as? PFFile {
            imageFile.getDataInBackgroundWithBlock({
                (imageData: NSData?, error: NSError?) -> Void in
                if (error == nil) {
                    cell.bandImage.image = UIImage(data:imageData!)
                }
            })
        }
    
        return cell
    }
    
    override func tableView(tableView: UITableView, didSelectRowAtIndexPath indexPath: NSIndexPath) {
        if let cell = tableView.cellForRowAtIndexPath(indexPath) as! SeekBandCell!{
            print(cell.object)
            cellObject = cell.object
            performSegueWithIdentifier("Open Band Profile", sender: self)
        }
    }
    
    override func prepareForSegue(segue: UIStoryboardSegue, sender: AnyObject?) {
        if(segue.identifier == "Open Band Profile") {
            
            let backItem = UIBarButtonItem()
            backItem.title = ""
            navigationItem.backBarButtonItem = backItem
            
            let vc = (segue.destinationViewController as! SeekBandProfileViewController)
            vc.bandObject = cellObject
        }
    }


}
