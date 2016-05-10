//
//  SeekViewController.swift
//  Bandit
//
//  Created by Piyoros Vephula on 12/6/15.
//  Copyright © 2015 Piyoros Vephula. All rights reserved.
//

import UIKit
import Parse
import ParseUI

class SeekViewController: PFQueryTableViewController {

    override init(style: UITableViewStyle, className: String!) {
        super.init(style: style, className: className)
    }
    
    required init!(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
        
        // Configure the PFQueryTableView
        self.parseClassName = "User"
        self.textKey = "fullName"
        self.pullToRefreshEnabled = true
        self.paginationEnabled = false
    }
    
    var userArray = [PFObject]()
    var cellObject:PFObject?
    
    @IBOutlet weak var toggleModeSwitch: UISegmentedControl!
    @IBOutlet var seekTableView: UITableView!
    
    @IBAction func toggleMode(sender: UISegmentedControl) {
        switch sender.selectedSegmentIndex {
        case 0:
            print("Seek Individual")
            //performSegueWithIdentifier("Seek Individual", sender: self)
        case 1:
            print("Seek Band")
            performSegueWithIdentifier("Seek Band", sender: self)
        default:
            print("You shouldn't be here")
        }
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
    
    func makeStringFromArray(array: [String], delim: String) -> String {
        var str = ""
        for el in array {
            var d = ""
            if str.characters.count > 0 { d = " \(delim) " }
            str = "\(str)\(d)\(el)"
        }
        return str
    }
    
    // Define the query that will provide the data for the table view
    override func queryForTable() -> PFQuery{
        let query = PFQuery(className: "_User")
        //query.includeKey("user")
        //query.includeKey("band")
        //query.includeKey("instrument")
        //query.includeKey("genre")
        print("queryForTable()")
        return query
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        print("SeekView")
    }
    
    override func viewWillAppear(animated: Bool) {
        
        self.navigationController?.navigationBar.setBackgroundImage(UIImage(), forBarMetrics: UIBarMetrics.Default)
        self.navigationController?.navigationBar.shadowImage = UIImage()
        self.navigationController?.navigationBar.translucent = true
        
        toggleModeSwitch.selectedSegmentIndex = 0
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
        print("*****************************")
        print(object)
        print("*****************************")
        var cell = tableView.dequeueReusableCellWithIdentifier("Seek Cell") as! SeekCell!
//        if cell == nil {
//            cell = SeekCell(style: UITableViewCellStyle.Default, reuseIdentifier: "Seek Cell")
//        }
        cell.object = object!
        // Extract values from the PFObject to display in the table cell
        if let fullName = object?["fullName"] as? String {
            cell.fullName.text = fullName
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
        
        var ug = makeStringFromArray(getGenres(object as! PFUser), delim: "•")
        if ug == "" {
            ug = "Genre not set"
        }
            
        cell.userGenre.text = ug.lowercaseString
        
        // Display image
        let imageFile = object?["image"] as! PFFile
        imageFile.getDataInBackgroundWithBlock({
            (imageData: NSData?, error: NSError?) -> Void in
            if (error == nil) {
                cell.userImage.image = UIImage(data:imageData!)
            }
        })
        
        return cell
    }
    
    override func tableView(tableView: UITableView, didSelectRowAtIndexPath indexPath: NSIndexPath) {
                
        if let cell = tableView.cellForRowAtIndexPath(indexPath) as! SeekCell!{
            print(cell.object)
            cellObject = cell.object
            performSegueWithIdentifier("Open Person Profile", sender: self)
        }
    }
    
    override func prepareForSegue(segue: UIStoryboardSegue, sender: AnyObject?) {
        if(segue.identifier == "Open Person Profile") {
            
            let backItem = UIBarButtonItem()
            backItem.title = ""
            navigationItem.backBarButtonItem = backItem
            
            let vc = (segue.destinationViewController as! SeekPersonProfileViewController)
            vc.user = cellObject as! PFUser!
        }
    }
}
