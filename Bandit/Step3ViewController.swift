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
        
        let tap: UITapGestureRecognizer = UITapGestureRecognizer(target: self, action: "dismissKeyboard")
        view.addGestureRecognizer(tap)

        point1.layer.cornerRadius = point1.frame.size.width/2
        point1.clipsToBounds = true
        
        point2.layer.cornerRadius = point2.frame.size.width/2
        point2.clipsToBounds = true
        
        point3.layer.borderWidth = 2
        point3.layer.borderColor = AppearanceHelper.itemColor().CGColor
        
        point3.layer.cornerRadius = point3.frame.size.width/2
        point3.clipsToBounds = true
    }

    func dismissKeyboard() {
        view.endEditing(true)
    }

}
