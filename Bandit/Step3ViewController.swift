//
//  Step3ViewController.swift
//  Bandit
//
//  Created by Piyoros Vephula on 2/22/16.
//  Copyright © 2016 Piyoros Vephula. All rights reserved.
//

import UIKit
import Parse

class Step3ViewController: UIViewController {

    @IBOutlet weak var point1: UIView!
    @IBOutlet weak var point2: UIView!
    @IBOutlet weak var point3: UIView!
    
    @IBOutlet weak var aboutMe: UITextView!
    
    @IBAction func finish(sender: UIButton) {
        // save data
        let user = PFUser.currentUser()!
        user["about"] = aboutMe.text
        user["didFirstTimeSetup"] = true
        user.saveInBackgroundWithBlock({
            (success: Bool, error: NSError?) -> Void in
            if error == nil {
                print(self.aboutMe.text)
                self.performSegueWithIdentifier("ToMainView", sender: sender)
            }else {
                print(error)
            }
        })
        
    }
    
    @IBAction func back(sender: UIButton) {
        
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()

        point1.layer.cornerRadius = point1.frame.size.width/2
        point1.clipsToBounds = true
        
        point2.layer.cornerRadius = point2.frame.size.width/2
        point2.clipsToBounds = true
        
        point3.layer.borderWidth = 2
        point3.layer.borderColor = AppearanceHelper.itemColor().CGColor
        
        point3.layer.cornerRadius = point3.frame.size.width/2
        point3.clipsToBounds = true
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
