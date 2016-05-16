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
    var saved = false
    var playing = false
    
    @IBOutlet weak var userImage: UIImageView!
    @IBOutlet weak var fullName: UILabel!
    @IBOutlet weak var userGenre: UILabel!
    @IBOutlet weak var saveButton: UIButton!
    @IBOutlet weak var playButton: UIButton!
    
    @IBAction func saveUser(sender: UIButton) {
        print("save user")
        if(saved == false){
            saved = true
            saveButton.setTitle("Saved", forState: UIControlState.Normal)
            saveButton.setTitleColor(AppearanceHelper.itemColor(), forState: UIControlState.Normal)
        }
        else{
            saved = false
            saveButton.setTitle("Save", forState: UIControlState.Normal)
            saveButton.setTitleColor(UIColor.whiteColor(), forState: UIControlState.Normal)
        }
    }
    
    @IBAction func playDemo(sender: UIButton) {
        print("play demo")
        if(playing == false){
            playing = true
            playButton.setTitle("Stop Playing", forState: UIControlState.Normal)
            playButton.setTitleColor(AppearanceHelper.itemColor(), forState: UIControlState.Normal)
        }
        else{
            playing = false
            playButton.setTitle("Play Demo", forState: UIControlState.Normal)
            playButton.setTitleColor(UIColor.whiteColor(), forState: UIControlState.Normal)
        }
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
