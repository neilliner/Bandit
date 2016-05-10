//
//  ViewController.swift
//  Bandit
//
//  Created by Piyoros Vephula on 11/17/2558 BE.
//  Copyright © 2558 Piyoros Vephula. All rights reserved.
//

import UIKit
import Parse

class LoginViewController: UIViewController {

    @IBOutlet weak var user: UITextField!
    @IBOutlet weak var pass: UITextField!
    //@IBOutlet weak var email: UITextField!
    @IBOutlet weak var loginButton: UIButton!
    
    @IBOutlet weak var warningMessage: UILabel!
    //@IBOutlet weak var greeting: UILabel!
    
    var username: String!
    var password: String!
    var emailVar: String!
    var signUpClicked: Bool! = false
    
    @IBAction func doLogin(sender: UIButton) {
        username = user.text
        
        if isValidEmail(username){
            let query : PFQuery = PFUser.query()!
            
            // check if email is matching any username
            query.whereKey("email",  equalTo: username)
            query.getFirstObjectInBackgroundWithBlock({ (object: PFObject?, error: NSError?) -> Void in
                let username = object!.objectForKey("username") as! String
                //self.username = username
                self.login(username, password: self.pass.text!)
            })
        }else{
            
            //password = pass.text
            self.login(username, password: self.pass.text!)
//            if PFUser.objectForKey("didFirstTimeSetup") == nil {
//                self.performSegueWithIdentifier("FirstTimeSetup", sender: sender)
//            }
        }
        
        
    }
    
//    @IBAction func loginAsNeil(sender: UIButton) {
//        login("Neil", password: "1234")
//    }
    
    
    func login(username: String, password: String) {
        PFUser.logInWithUsernameInBackground(username, password: password) {
            (user: PFUser?, error: NSError?) -> Void in
            if user != nil {
                print("Logging in.")
                
                if (user!.objectForKey("didFirstTimeSetup") == nil || user!.objectForKey("didFirstTimeSetup") as! Bool == false) {
                    self.performSegueWithIdentifier("FirstTimeSetup", sender: self)
                } else {
                    self.performSegueWithIdentifier("LoginToMainView", sender: self)
                }
            } else {
                print("Incorrect username, email or password.")
                self.warningMessage.text = "Incorrect username, email or password."
            }
        }
    }
    
//    func signup() {
//        let userSignup = PFUser()
//        userSignup.username = user.text
//        userSignup.password = pass.text
//        userSignup.email = emailVar
//        
//        userSignup.signUpInBackgroundWithBlock {
//            (succeeded: Bool, error: NSError?) -> Void in
//            if let error = error {
//                let errorString = error.userInfo["error"] as? NSString
//                // Show the errorString somewhere and let the user try again.
//                print(errorString)
//            } else {
//                // Hooray! Let them use the app now.
//                self.login(self.user.text!, password: self.pass.text!)
//            }
//        }
//    }
    
    func isValidEmail(str:String) -> Bool {
        
        //print("validate emilId: \(str)")
        
        let emailRegEx = "[A-Z0-9a-z._%+-]+@[A-Za-z0-9.-]+\\.[A-Za-z]{2,4}"
        
        let emailTest = NSPredicate(format:"SELF MATCHES %@", emailRegEx)
        
        let result = emailTest.evaluateWithObject(str)
        
        return result
        
    }
    
//    @IBAction func doSignup(sender: UIButton) {
//        self.emailVar = self.email.text
//        print("sign up button clicked")
//        if signUpClicked == true {
//            print("signUpClicked == true")
//            if isValidEmail(self.emailVar){
//                print("Email \(self.emailVar) is valid")
//                signup()
//                self.email.hidden = true
//                self.user.placeholder = "username or email"
//            } else {
//                self.warningMessage.text = "Invalid Email"
//                print("Invalid Email")
//            }
//        } else {
//            self.email.hidden = false
//            self.user.placeholder = "username"
//            signUpClicked = true
//        }
//    }
    
    
//    override func prepareForSegue(segue: UIStoryboardSegue, sender: AnyObject?) {
//        
//        if(segue.identifier == "LoginToMainView") {
//            
//            let vc = (segue.destinationViewController as! NewsFeedViewController)
//            vc.username = username
//        }
//    }
    
    func UIColorFromHex(rgbValue: UInt) -> UIColor {
        return UIColor(
            red: CGFloat((rgbValue & 0xFF0000) >> 16) / 255.0,
            green: CGFloat((rgbValue & 0x00FF00) >> 8) / 255.0,
            blue: CGFloat(rgbValue & 0x0000FF) / 255.0,
            alpha: CGFloat(1.0)
        )
    }
    
    //view.backgroundColor = UIColorFromRGB(0x209624)
    
    override func viewDidLoad() {
        super.viewDidLoad()
        let bWidth:CGFloat = 2.0
  
        warningMessage.text = ""
        
//        self.user.layer.borderWidth = bWidth
//        self.user.layer.borderColor = UIColor.redColor().CGColor
//        
//        self.pass.layer.borderWidth = bWidth
//        self.pass.layer.borderColor = UIColor.redColor().CGColor
        
        self.loginButton.layer.borderWidth = bWidth
        self.loginButton.layer.borderColor = UIColorFromHex(0xFC0D52).CGColor
        
        //greeting.text = "Welcome to Band Seeker!"
    }
    
    override func viewWillAppear(animated: Bool) {
        self.view.hidden = true
    }
    
    override func viewDidAppear(animated: Bool) {
        let currentUser = PFUser.currentUser()?.username
        if currentUser != nil {
            // redirect to next view
            print(currentUser)
            performSegueWithIdentifier("LoginToMainView", sender: self)
        } else {
            self.view.hidden = false
        }
    }


    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }


}

