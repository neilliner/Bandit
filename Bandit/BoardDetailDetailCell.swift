//
//  BoardDetailDetailCell.swift
//  Bandit
//
//  Created by Piyoros Vephula on 2/8/16.
//  Copyright © 2016 Piyoros Vephula. All rights reserved.
//

import UIKit
import ParseUI

class BoardDetailDetailCell: PFTableViewCell {

    @IBOutlet weak var detail: UITextView!
    var bg:UIColor?
    
    override func awakeFromNib() {
        super.awakeFromNib()
        bg = self.contentView.backgroundColor
    }
    
    override func setSelected(selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)
        
        self.contentView.backgroundColor = bg
    }
    
    override func setHighlighted(highlighted: Bool, animated: Bool) {
        
        self.contentView.backgroundColor = bg
        
    }

}
