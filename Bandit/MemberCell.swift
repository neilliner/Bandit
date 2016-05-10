//
//  MemberCell.swift
//  Bandit
//
//  Created by Piyoros Vephula on 11/28/15.
//  Copyright © 2015 Piyoros Vephula. All rights reserved.
//

import UIKit
import Parse
import ParseUI

class MemberCell: UITableViewCell {
    
    @IBOutlet weak var memberScrollView: UIScrollView!
    
    var memberArray = [PFObject]()
    var widthOfScrollView:CGFloat = 0.0

    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }
    
    func loadImages() {
        
        let imgWH = 65;
        let imgMar = 10;
        
        for var i = 0 ; i < memberArray.count ; i++ {
            
            var xPos = 0
            xPos = (Int(memberScrollView.frame.width)/2) - ((imgWH + imgMar) * memberArray.count)/2 + ((imgWH + imgMar) * i)
            
            let pfImageView = PFImageView(frame: CGRect(x: xPos+(imgMar/2), y: 0, width: imgWH, height: imgWH))
            
            
            memberScrollView.addSubview(pfImageView)
            pfImageView.backgroundColor = UIColor.redColor()
            print(memberArray[i])
            let imageFile = memberArray[i].objectForKey("image") as? PFFile
            pfImageView.file = imageFile
            
           
            print(" ******* MemberCell ********** \(memberArray)")
            
            //pfImageView.contentMode = .ScaleAspectFill
            pfImageView.loadInBackground()
            pfImageView.layer.masksToBounds = false
            pfImageView.layer.cornerRadius = pfImageView.frame.size.width/2
            pfImageView.clipsToBounds = true
        }
        
        memberScrollView.contentSize = CGSize(width: widthOfScrollView + CGFloat(imgWH), height: CGFloat(imgWH))
    }

    override func setSelected(selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }

}
