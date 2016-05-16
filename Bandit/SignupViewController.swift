//
//  SignupViewController.swift
//  Bandit
//
//  Created by Piyoros Vephula on 5/15/16.
//  Copyright © 2016 Piyoros Vephula. All rights reserved.
//

import UIKit
import Parse

class SignupViewController: UIViewController {

    @IBOutlet weak var username: UITextField!
    @IBOutlet weak var email1: UITextField!
    @IBOutlet weak var email2: UITextField!
    @IBOutlet weak var password1: UITextField!
    @IBOutlet weak var password2: UITextField!
    @IBOutlet weak var signupButton: UIButton!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        signupButton.layer.borderWidth = 2
        signupButton.layer.borderColor = AppearanceHelper.itemColor().CGColor
        signupButton.layer.cornerRadius = 5
    }

    @IBAction func signup(sender: UIButton) {
        if username.text != "" && email1.text != "" && email1.text == email2.text && password1.text != nil && password1.text == password2.text {
            print("email and password matched")

            let user = PFUser()

            user.username = username.text
            user.password = password1.text
            user.email = email1.text
            user["didFirstTimeSetup"] = false

            user.signUpInBackgroundWithBlock { succeeded, error in
                if (succeeded) {
                    
                    let alert = UIAlertController(title: "You're signed up.", message: "Please log in with your username.", preferredStyle: UIAlertControllerStyle.Alert)
                    let ok = UIAlertAction(title: "OK", style: UIAlertActionStyle.Default, handler: { (action: UIAlertAction) -> Void in
                        PFUser.logOut()
                        self.performSegueWithIdentifier("back to login", sender: sender)
                    })
                    alert.addAction(ok)
                    self.presentViewController(alert, animated: true, completion: nil)
                } else if let error = error {
                    print(error)
                }
            }
        }
    }

    
}
