//
//  InboxCell.swift
//  Bandit
//
//  Created by Piyoros Vephula on 3/29/16.
//  Copyright © 2016 Piyoros Vephula. All rights reserved.
//

import UIKit

class InboxCell: UITableViewCell {
    
    @IBOutlet weak var img: UIImageView!
    @IBOutlet weak var name: UILabel!
    @IBOutlet weak var type: UILabel!
    @IBOutlet weak var date: UILabel!
    @IBOutlet weak var detail: UITextView!

    override func awakeFromNib() {
        super.awakeFromNib()
        self.selectionStyle = .None
        // Initialization code
    }

    override func setSelected(selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)
        //self.backgroundColor = AppearanceHelper.backgroundDark()
        // Configure the view for the selected state
    }

}
