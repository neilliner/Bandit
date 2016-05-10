//
//  FullScreenImageViewController.swift
//  Bandit
//
//  Created by Piyoros Vephula on 3/25/16.
//  Copyright © 2016 Piyoros Vephula. All rights reserved.
//

import UIKit
import Parse
import ParseUI

class FullScreenImageViewController: UIViewController {

    let user = PFUser.currentUser()!
    var img:PFImageView?
    
    @IBOutlet weak var fullScreenImage: PFImageView!
    
    @IBAction func deleteImage(sender: UIBarButtonItem) {
        
        let deleteImg = PFQuery(className: "UserPhoto")
        deleteImg.whereKey("user", equalTo: user)
        deleteImg.whereKey("photo", equalTo: img!.file!.name)
        deleteImg.findObjectsInBackgroundWithBlock({ (objects : [PFObject]?, error: NSError?) -> Void in
            if error == nil {
                for object in objects! {
                    object.deleteInBackground()
                    self.navigationController?.popViewControllerAnimated(true)
                }
            }
        })
    }
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        print(img)
        // Do any additional setup after loading the view.
        fullScreenImage.image = img?.image!
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
