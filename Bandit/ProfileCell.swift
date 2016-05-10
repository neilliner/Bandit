//
//  ProfileCell.swift
//  Bandit
//
//  Created by Piyoros Vephula on 11/18/2558 BE.
//  Copyright © 2558 Piyoros Vephula. All rights reserved.
//

import UIKit
import Parse
import ParseUI

class ProfileCell:  UITableViewCell {
    
    @IBOutlet weak var background: UIView!
    @IBOutlet weak var coverImage: UIImageView!
    
    @IBOutlet weak var profileImage: PFImageView!
    @IBOutlet weak var fullName: UILabel!
    @IBOutlet weak var exp: UILabel!
    @IBOutlet weak var instrument: UILabel!
    @IBOutlet weak var genre: UILabel!
    //@IBOutlet weak var band: UILabel!
    @IBOutlet weak var location: UILabel!
    
    @IBOutlet weak var instView: UIView!
    
    @IBOutlet weak var inviteButton: UIButton!
    
    @IBOutlet weak var confirmButton: UIButton!
    
    @IBOutlet weak var rejectButton: UIButton!
    
    @IBOutlet weak var confirmDescription: UILabel!
    
    @IBOutlet weak var cancelButton: UIButton!
    
    var instArray = [String]()
    
    let gradientLayer = CAGradientLayer()
    
    override func awakeFromNib() {
        super.awakeFromNib()
        
        gradientLayer.frame = coverImage.bounds
        
        let color1 = AppearanceHelper.UIColorFromHex(0x6248FF).CGColor as CGColorRef
        let color2 = AppearanceHelper.UIColorFromHex(0x5547FF).CGColor as CGColorRef
        let color3 = AppearanceHelper.UIColorFromHex(0x1B1172).CGColor as CGColorRef
        let color4 = AppearanceHelper.UIColorFromHex(0x100044).CGColor as CGColorRef
        
        gradientLayer.colors = [color1, color2, color3, color4]
        gradientLayer.locations = [0.0, 0.25, 0.75, 1.0]
        
        self.background.layer.insertSublayer(gradientLayer, below: self.coverImage.layer)
        
        profileImage.layer.borderColor = UIColor.whiteColor().CGColor
        profileImage.layer.borderWidth = 2.5
        
        location.text = location.text!.uppercaseString
        
        if self.inviteButton != nil {
            self.inviteButton.layer.borderWidth = 2
            self.inviteButton.layer.borderColor = AppearanceHelper.itemColor().CGColor
            self.inviteButton.layer.cornerRadius = 5
        }
        
        if self.confirmButton != nil {
            self.confirmButton.layer.borderWidth = 2
            self.confirmButton.layer.borderColor = AppearanceHelper.itemColor().CGColor
            self.confirmButton.layer.cornerRadius = 5
        }
        
        if self.rejectButton != nil {
            self.rejectButton.layer.borderWidth = 2
            self.rejectButton.layer.borderColor = AppearanceHelper.itemColor().CGColor
            self.rejectButton.layer.cornerRadius = 5
        }
        
        if self.cancelButton != nil {
            self.cancelButton.layer.borderWidth = 2
            self.cancelButton.layer.borderColor = AppearanceHelper.itemColor().CGColor
            self.cancelButton.layer.cornerRadius = 5
        }
    }
    
//    func getInstruments(user: PFUser) -> [String] {
//        var instruments = [String]()
//        var instrumentsObj = [PFObject]()
//        let query = PFQuery(className: "UserInst")
//        query.whereKey("user", equalTo: user)
//        do{
//            
//            instrumentsObj = try query.findObjects()
//        }
//        catch{
//            print("Instrument not found")
//        }
//        
//        for i in instrumentsObj {
//            instruments.append(i.objectForKey("instrument") as! String)
//        }
//        return instruments
//    }
    
    func loadImages() {
        print(instArray)
        //var widthOfScrollView:CGFloat = 0.0
        let imgWH = 30;
        let imgMar = 10;
        
        //var xPos = 0
        for var i = 0 ; i < instArray.count ; i++ {
            
            var xPos = 0
            xPos = (Int(instView.frame.width)/2) - ((imgWH + imgMar) * instArray.count)/2 + ((imgWH + imgMar) * i) + (imgMar/2)
            //xPos = (Int(instView.frame.width)/2) - ((imgWH + imgMar))/2 + ((imgWH + imgMar))
            
            //let pfImageView = PFImageView(frame: CGRect(x: xPos+(imgMar/2), y: 0, width: imgWH, height: imgWH))
            
            let imageViewObject = UIImageView(frame:CGRectMake(CGFloat(xPos), 0, CGFloat(imgWH), CGFloat(imgWH)))
            imageViewObject.image = AppearanceHelper.imageForInst(instArray[i])
            imageViewObject.image = imageViewObject.image!.imageWithRenderingMode(UIImageRenderingMode.AlwaysTemplate)
            imageViewObject.tintColor = AppearanceHelper.UIColorFromHex(0xAAAAAA)
            imageViewObject.contentMode = UIViewContentMode.ScaleAspectFill
            self.instView.addSubview(imageViewObject)
            
            //memberScrollView.addSubview(pfImageView)
            //let imageFile = memberArray[i].objectForKey("image") as! PFFile
            //pfImageView.file = imageFile
            
            //pfImageView.contentMode = .ScaleAspectFill
            //pfImageView.loadInBackground()
            //pfImageView.layer.masksToBounds = false
            //pfImageView.layer.cornerRadius = pfImageView.frame.size.width/2
            //pfImageView.clipsToBounds = true
        }
        
        //instView.contentSize = CGSize(width: widthOfScrollView + CGFloat(imgWH), height: CGFloat(imgWH))
    }
    
//    func imageForInst(ins: String) -> UIImage {
//        var img:UIImage?
//        switch ins {
//            case "Vocal"            : img = UIImage(named: "inst-icon-01.png")
//            case "Electric Guitar"  : img = UIImage(named: "inst-icon-02.png")
//            case "Bass"             : img = UIImage(named: "inst-icon-03.png")
//            case "Drum"             : img = UIImage(named: "inst-icon-04.png")
//            case "Keyboard"         : img = UIImage(named: "inst-icon-05.png")
//            case "Acoustic Guitar"  : img = UIImage(named: "inst-icon-06.png")
//            case "Wind"             : img = UIImage(named: "inst-icon-07.png")
//            case "Synthesizer"      : img = UIImage(named: "inst-icon-08.png")
//            case "Percussion"       : img = UIImage(named: "inst-icon-09.png")
//            default                 : img = UIImage(named: "inst-icon-10.png")
//        }
//        return img!
//    }
}
