//
//  BoardDetailHeaderCell.swift
//  Bandit
//
//  Created by Piyoros Vephula on 12/5/15.
//  Copyright © 2015 Piyoros Vephula. All rights reserved.
//

import UIKit
//import Parse
import ParseUI

class BoardDetailHeaderCell: PFTableViewCell {
    
    
    @IBOutlet weak var creatorImage: PFImageView!
    @IBOutlet weak var profileImage: UIImageView!
    @IBOutlet weak var subject: UILabel!
    @IBOutlet weak var creator: UILabel!
    @IBOutlet weak var genre: UILabel!
    @IBOutlet weak var instrument: UILabel!
    @IBOutlet weak var instView: UIView!
    @IBOutlet weak var level: UILabel!
    @IBOutlet weak var compensation: UILabel!
    @IBOutlet weak var dateTime: UILabel!
    @IBOutlet weak var profileButton: UIButton!
    @IBOutlet weak var applyButton: UIButton!
    
    var instArray = [String]()
    
    override func setSelected(selected: Bool, animated: Bool) {
        
        // prevent labels' background color disappearing after selected(tapped)
        let bg = AppearanceHelper.mainColor()
        
        self.subject.backgroundColor = bg
        self.creator.backgroundColor = bg
        self.instrument.backgroundColor = bg
        self.genre.backgroundColor = bg
        self.level.backgroundColor = bg
        self.compensation.backgroundColor = UIColor.clearColor()
        self.dateTime.backgroundColor = UIColor.clearColor()
    }
    
    override func setHighlighted(highlighted: Bool, animated: Bool) {
        
        // prevent labels' background color disappearing after selected(tapped)
        let bg = AppearanceHelper.mainColor()
        
        self.subject.backgroundColor = bg
        self.creator.backgroundColor = bg
        self.instrument.backgroundColor = bg
        self.genre.backgroundColor = bg
        self.level.backgroundColor = bg
        self.compensation.backgroundColor = UIColor.clearColor()
        self.dateTime.backgroundColor = UIColor.clearColor()
    }
    
    let gradientLayer = CAGradientLayer()
    
    override func awakeFromNib() {
        super.awakeFromNib()
        
        gradientLayer.frame = creatorImage.bounds
        
        let color1 = AppearanceHelper.UIColorFromHex(0x6248FF).CGColor as CGColorRef
        let color2 = AppearanceHelper.UIColorFromHex(0x5547FF).CGColor as CGColorRef
        let color3 = AppearanceHelper.UIColorFromHex(0x1B1172).CGColor as CGColorRef
        let color4 = AppearanceHelper.UIColorFromHex(0x100044).CGColor as CGColorRef
        
        gradientLayer.colors = [color1, color2, color3, color4]
        gradientLayer.locations = [0.0, 0.25, 0.75, 1.0]
        
        self.contentView.layer.insertSublayer(gradientLayer, below: self.creatorImage.layer)
        
        //profileImage.layer.borderColor = UIColor.whiteColor().CGColor
        //profileImage.layer.borderWidth = 2.5
        
//        gradientLayer.frame = creatorImage.bounds
//        
//        let color1 = UIColor.blackColor().CGColor as CGColorRef
//        let color2 = UIColor(red: 0.0, green: 0, blue: 0, alpha: 0.0).CGColor as CGColorRef
//        gradientLayer.colors = [color1, color2]
//        gradientLayer.locations = [0.0, 0.5]
//        
//        self.creatorImage.layer.addSublayer(gradientLayer)
        
        self.applyButton.layer.borderWidth = 2
        self.applyButton.layer.borderColor = AppearanceHelper.itemColor().CGColor
        self.applyButton.layer.cornerRadius = 5
        
        self.profileButton.layer.borderWidth = 2
        self.profileButton.layer.borderColor = AppearanceHelper.itemColor().CGColor
        self.profileButton.layer.cornerRadius = 5
    
        //self.subject.text?.uppercaseString
    }
    
    /*
    // Only override drawRect: if you perform custom drawing.
    // An empty implementation adversely affects performance during animation.
    override func drawRect(rect: CGRect) {
        // Drawing code
    }
    */
    
    func loadImages() {
        print(instArray)

        let imgWH = 30;
        let imgMar = 10;
        

        for var i = 0 ; i < instArray.count ; i++ {
            
            var xPos = 0
            xPos = (Int(instView.frame.width)/2) - ((imgWH + imgMar) * instArray.count)/2 + ((imgWH + imgMar) * i) + (imgMar/2)

            
            let imageViewObject = UIImageView(frame:CGRectMake(CGFloat(xPos), 0, CGFloat(imgWH), CGFloat(imgWH)))
            imageViewObject.image = AppearanceHelper.imageForInst(instArray[i])
//            imageViewObject.image = imageViewObject.image!.imageWithRenderingMode(UIImageRenderingMode.AlwaysTemplate)
//            imageViewObject.tintColor = AppearanceHelper.UIColorFromHex(0xAAAAAA)
            imageViewObject.contentMode = UIViewContentMode.ScaleAspectFill
            self.instView.addSubview(imageViewObject)
            

        }
        

    }

}
