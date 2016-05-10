//
//  BandSelectCell.swift
//  Bandit
//
//  Created by Piyoros Vephula on 11/29/15.
//  Copyright © 2015 Piyoros Vephula. All rights reserved.
//

import UIKit

class BandSelectCell: UITableViewCell {
    
    @IBOutlet weak var bandImage: UIImageView!
    @IBOutlet weak var bandname: UILabel!
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
        
    }

    override func setSelected(selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }

}
