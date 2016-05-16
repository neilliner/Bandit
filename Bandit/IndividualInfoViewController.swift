//
//  IndividualInfoViewController.swift
//  Bandit
//
//  Created by Piyoros Vephula on 11/28/15.
//  Copyright © 2015 Piyoros Vephula. All rights reserved.
//

import UIKit
import Parse
import ParseUI

class IndividualInfoViewController: UIViewController {

    let user = PFUser.currentUser()!
    var bandArray = [PFObject]()
    var widthOfScrollView:CGFloat = 0.0
    
    @IBOutlet weak var bands: UILabel!
    @IBOutlet weak var bandScrollView: UIScrollView!
    @IBOutlet weak var about: UILabel!
    @IBOutlet weak var infoText: UITextView!
    @IBOutlet weak var exp: UILabel!
    @IBOutlet weak var location: UILabel!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.tabBarController?.tabBar.hidden = true
        self.navigationItem.setHidesBackButton(true, animated:false)
        self.navigationController?.navigationBar.setBackgroundImage(UIImage(), forBarMetrics: UIBarMetrics.Default)
        self.navigationController?.navigationBar.shadowImage = UIImage()
        self.navigationController?.navigationBar.translucent = true
        self.navigationController?.hidesBarsOnSwipe = false
        let stop = UIBarButtonItem(barButtonSystemItem: .Stop, target: self, action: "goBack")
        stop.tintColor = UIColor(red: 0.96862745, green: 0.05093039, blue: 0.32156862, alpha: 1.0)
        self.navigationItem.rightBarButtonItem = stop
        bandArray = getUserBands(user)
        loadImages()
        //self.automaticallyAdjustsScrollViewInsets = false
        
        if let about = user["about"] as? String {
            self.infoText.text = about //user["about"] as! String
        }
    }
    
    func goBack(){
        self.navigationController?.popToRootViewControllerAnimated(true)
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
        
        for var i = 0 ; i < bandArray.count ; i++ {
            
            var xPos = 0
            xPos = 0 + (60 * i)
            
            let pfImageView = PFImageView(frame: CGRect(x: xPos, y: 0, width: 50, height: 50))
            
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
            pfImageView.contentMode = UIViewContentMode.ScaleAspectFill
        }
        bandScrollView.contentSize = CGSize(width: widthOfScrollView + 50, height: 50)
        
    }

}
