//
//  SeekCell.swift
//  Bandit
//
//  Created by Piyoros Vephula on 2/9/16.
//  Copyright © 2016 Piyoros Vephula. All rights reserved.
//

import UIKit
import Parse
import ParseUI

class SeekCell: PFTableViewCell {
    
    var userArray = [PFObject]()
    var object:PFObject?
    
    @IBOutlet weak var userImage: UIImageView!
    @IBOutlet weak var fullName: UILabel!
    @IBOutlet weak var userGenre: UILabel!
    
    @IBAction func saveUser(sender: UIButton) {
        print("save user")
    }
    
    override func awakeFromNib() {
        super.awakeFromNib()
        //userImage.contentMode = .ScaleAspectFill
    }
    
    override func setSelected(selected: Bool, animated: Bool) {
        
    }
    
    override func setHighlighted(highlighted: Bool, animated: Bool) {
        
    }

    /*
    // Only override drawRect: if you perform custom drawing.
    // An empty implementation adversely affects performance during animation.
    override func drawRect(rect: CGRect) {
        // Drawing code
    }
    */

}
