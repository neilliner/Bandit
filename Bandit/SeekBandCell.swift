//
//  SeekBandCell.swift
//  Bandit
//
//  Created by Piyoros Vephula on 2/21/16.
//  Copyright © 2016 Piyoros Vephula. All rights reserved.
//

import UIKit
import Parse
import ParseUI

class SeekBandCell: PFTableViewCell {
    
    var object:PFObject?
    
    @IBOutlet weak var bandImage: UIImageView!
    
    @IBOutlet weak var bandName: UILabel!

    @IBOutlet weak var genre: UILabel!
    
    override func setSelected(selected: Bool, animated: Bool) {
    
    }
    
    override func setHighlighted(highlighted: Bool, animated: Bool) {

    }
}
