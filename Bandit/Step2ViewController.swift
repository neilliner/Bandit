//
//  Step2ViewController.swift
//  Bandit
//
//  Created by Piyoros Vephula on 2/22/16.
//  Copyright © 2016 Piyoros Vephula. All rights reserved.
//

import UIKit
import Parse

class Step2ViewController: UIViewController, UIImagePickerControllerDelegate, UINavigationControllerDelegate {
    
    @IBOutlet weak var point1: UIView!
    
    @IBOutlet weak var point2: UIView!
    
    @IBOutlet weak var point3: UIView!
    
    @IBOutlet weak var profileImage: UIImageView!
    
    @IBAction func uploadImage(sender: UIButton) {
        chooseImage()
    }
    
    func imagePickerController(picker: UIImagePickerController, didFinishPickingImage image: UIImage!, editingInfo: [NSObject : AnyObject]!) {
        profileImage.image = image
        self.dismissViewControllerAnimated(true, completion: nil)
        
        //uploadImageText.titleLabel?.text = "Change"
    }
    
    @IBAction func next(sender: UIButton) {
        
        // save data
        let user = PFUser.currentUser()!
        let imageData = UIImageJPEGRepresentation(self.profileImage.image!, 0.5)
        
        //create a parse file to store in cloud
        let parseImageFile = PFFile(name: "profile_image.jpg", data: imageData!)
        user["image"] = parseImageFile
        user.saveInBackgroundWithBlock({
            (success: Bool, error: NSError?) -> Void in
            if error == nil {
                print("data uploaded")
                self.performSegueWithIdentifier("ToStep3", sender: sender)
            }else {
                print(error)
            }
        })
        
    }
    
    @IBAction func back(sender: UIButton) {
        print("back")
        self.navigationController?.popViewControllerAnimated(true)
    }
    
    // TODO:- Add action to imageView
    func imageTapped(img: AnyObject) {
        chooseImage()
    }
    
    func chooseImage() {
        let imagePicker = UIImagePickerController()
        imagePicker.delegate = self
        if Platform.isSimulator {
            imagePicker.sourceType = UIImagePickerControllerSourceType.PhotoLibrary
        }
        else {
            imagePicker.sourceType = UIImagePickerControllerSourceType.Camera
        }
        imagePicker.allowsEditing = false
        self.presentViewController(imagePicker, animated: true, completion: nil)
    }
    
    // TODO:- Save image to Parse
    
    override func viewDidLoad() {
        super.viewDidLoad()

        point1.layer.cornerRadius = point1.frame.size.width/2
        point1.clipsToBounds = true
        
        point2.layer.borderWidth = 2
        point2.layer.borderColor = AppearanceHelper.itemColor().CGColor
        
        point2.layer.cornerRadius = point2.frame.size.width/2
        point2.clipsToBounds = true
        
        point3.layer.cornerRadius = point3.frame.size.width/2
        point3.clipsToBounds = true
        
        profileImage.layer.cornerRadius = profileImage.frame.size.width/2
        profileImage.clipsToBounds = true
        
        let tapGestureRecognizer = UITapGestureRecognizer(target:self, action:Selector("imageTapped:"))
        profileImage.userInteractionEnabled = true
        profileImage.addGestureRecognizer(tapGestureRecognizer)
        
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
    
    // To check if it's running on simulator or device
    struct Platform {
        static let isSimulator: Bool = {
            var isSim = false
            #if arch(i386) || arch(x86_64)
                isSim = true
            #endif
            return isSim
        }()
    }

}
