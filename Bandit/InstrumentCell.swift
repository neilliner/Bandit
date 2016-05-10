//
//  InstrumentCell.swift
//  Bandit
//
//  Created by Piyoros Vephula on 11/28/15.
//  Copyright © 2015 Piyoros Vephula. All rights reserved.
//

import UIKit

class InstrumentCell: UITableViewCell {
    
    @IBOutlet weak var instView: UIView!
    var instArray = [String]()

    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

    override func setSelected(selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }
    
    func loadImages() {
        print(instArray)
        let imgWH = 30;
        let imgMar = 10;
        
        for var i = 0 ; i < instArray.count ; i++ {
            
            var xPos = 0
            xPos = (Int(instView.frame.width)/2) - ((imgWH + imgMar) * instArray.count)/2 + ((imgWH + imgMar) * i) + (imgMar/2)
            
            let imageViewObject = UIImageView(frame:CGRectMake(CGFloat(xPos), 0, CGFloat(imgWH), CGFloat(imgWH)))
            imageViewObject.image = AppearanceHelper.imageForInst(instArray[i])
            //imageViewObject.image = imageViewObject.image!.imageWithRenderingMode(UIImageRenderingMode.AlwaysTemplate)
            //imageViewObject.tintColor = AppearanceHelper.UIColorFromHex(0xAAAAAA)
            imageViewObject.contentMode = UIViewContentMode.ScaleAspectFill
            self.instView.addSubview(imageViewObject)
        }
    }

}
