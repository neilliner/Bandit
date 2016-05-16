//
//  BandProfileCell.swift
//  Bandit
//
//  Created by Piyoros Vephula on 11/28/15.
//  Copyright © 2015 Piyoros Vephula. All rights reserved.
//

import UIKit

class BandProfileCell: UITableViewCell {
    
    
    @IBOutlet weak var bandProfileImage: UIImageView!
    
    @IBOutlet weak var bandPopover: KFPopupSelector!
    @IBOutlet weak var bandName: UIButton!
    @IBOutlet weak var genre: UILabel!
    @IBOutlet weak var location: UILabel!
    
    @IBOutlet weak var joinButton: UIButton!
    @IBOutlet weak var cameraToolBar: UIToolbar!
    @IBOutlet weak var buttonBackground: UIView!
    
    @IBOutlet weak var actionBackground: UIView!
    @IBOutlet weak var cancelButton: UIButton!
    @IBOutlet weak var confirmButton: UIButton!
    @IBOutlet weak var rejectButton: UIButton!
    @IBOutlet weak var confirmDescription: UILabel!
    
    let gradientLayer = CAGradientLayer()
    
    override func awakeFromNib() {
        super.awakeFromNib()
        
        gradientLayer.frame = bandProfileImage.bounds
        
        let color1 = AppearanceHelper.UIColorFromHexWithAlpha(0x000000, opac: 0.5).CGColor as CGColorRef
        let color2 = UIColor.clearColor().CGColor as CGColorRef
        
        gradientLayer.colors = [color1, color2]
        gradientLayer.locations = [0.0, 1.0]
        
        self.bandProfileImage.layer.insertSublayer(gradientLayer, below: self.bandProfileImage.layer)
        
        //let color = bandName.currentTitleColor.CGColor
        let color = UIColor.blackColor().CGColor
        bandName.titleLabel!.layer.shadowColor = color
        bandName.titleLabel!.layer.shadowRadius = 4.0
        bandName.titleLabel!.layer.shadowOpacity = 0.9
        bandName.titleLabel!.layer.shadowOffset = CGSizeZero
        bandName.titleLabel!.layer.masksToBounds = false
        
        genre.layer.shadowColor = color
        genre.layer.shadowRadius = 4.0
        genre.layer.shadowOpacity = 0.9
        genre.layer.shadowOffset = CGSizeZero
        genre.layer.masksToBounds = false
        
        location.layer.shadowColor = color
        location.layer.shadowRadius = 4.0
        location.layer.shadowOpacity = 0.9
        location.layer.shadowOffset = CGSizeZero
        location.layer.masksToBounds = false
        
        if cameraToolBar != nil {
            self.cameraToolBar.setBackgroundImage(UIImage(),
                forToolbarPosition: UIBarPosition.Any,
                barMetrics: UIBarMetrics.Default)
            self.cameraToolBar.setShadowImage(UIImage(),
                forToolbarPosition: UIBarPosition.Any)
        }
        
        if self.joinButton != nil {
            self.joinButton.layer.borderWidth = 2
            self.joinButton.layer.borderColor = AppearanceHelper.itemColor().CGColor
            self.joinButton.layer.cornerRadius = 5
            self.buttonBackground.hidden = false
        }
        
        if self.cancelButton != nil {
            self.cancelButton.layer.borderWidth = 2
            self.cancelButton.layer.borderColor = AppearanceHelper.itemColor().CGColor
            self.cancelButton.layer.cornerRadius = 5
            //self.buttonBackground.hidden = false
        }
        
        if self.confirmButton != nil {
            self.confirmButton.layer.borderWidth = 2
            self.confirmButton.layer.borderColor = AppearanceHelper.itemColor().CGColor
            self.confirmButton.layer.cornerRadius = 5
            //self.buttonBackground.hidden = false
        }
        
        if self.rejectButton != nil {
            self.rejectButton.layer.borderWidth = 2
            self.rejectButton.layer.borderColor = AppearanceHelper.itemColor().CGColor
            self.rejectButton.layer.cornerRadius = 5
            //self.buttonBackground.hidden = false
        }
    }
    
    override func setSelected(selected: Bool, animated: Bool) {
        
        // prevent labels' background color disappearing after selected(tapped)
        //let wbg = UIColor.whiteColor()
        //let bg = AppearanceHelper.mainColor()
        
        //self.genre.backgroundColor = bg
    }
    
    override func setHighlighted(highlighted: Bool, animated: Bool) {
        
        // prevent labels' background color disappearing after selected(tapped)
        //let wbg = UIColor.whiteColor()
        //let bg = AppearanceHelper.mainColor()
        
        //self.genre.backgroundColor = bg
    }

}
