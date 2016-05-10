//
//  BoardDetailCommentCell.swift
//  Bandit
//
//  Created by Piyoros Vephula on 2/8/16.
//  Copyright © 2016 Piyoros Vephula. All rights reserved.
//

import UIKit
import ParseUI

class BoardDetailCommentCell: PFTableViewCell {
    
    @IBOutlet weak var userImage: UIImageView!
    @IBOutlet weak var comment: UITextView!
    @IBOutlet weak var userName: UILabel!
    @IBOutlet weak var dateTime: UILabel!
    var bg:UIColor?
    
    override func awakeFromNib() {
        super.awakeFromNib()
        bg = self.contentView.backgroundColor
        
        if userImage != nil {
            userImage.layer.cornerRadius = userImage.frame.size.width/2
            userImage.clipsToBounds = true
        }
    }
    
    override func setSelected(selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        self.contentView.backgroundColor = bg
    }
    
    override func setHighlighted(highlighted: Bool, animated: Bool) {

        self.contentView.backgroundColor = bg
        
    }

    /*
    // Only override drawRect: if you perform custom drawing.
    // An empty implementation adversely affects performance during animation.
    override func drawRect(rect: CGRect) {
        // Drawing code
    }
    */

}
