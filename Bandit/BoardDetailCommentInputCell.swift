//
//  BoardDetailCommentInputCell.swift
//  Bandit
//
//  Created by Piyoros Vephula on 3/6/16.
//  Copyright © 2016 Piyoros Vephula. All rights reserved.
//

import UIKit
import ParseUI

class BoardDetailCommentInputCell: PFTableViewCell, UITextViewDelegate {

    @IBOutlet weak var submitButton: UIButton!
    
    @IBOutlet weak var commentText: UITextView!
    var bg:UIColor?
    var tvbg:UIColor?
    
    override func awakeFromNib() {
        super.awakeFromNib()
        
        bg = self.contentView.backgroundColor
        tvbg = commentText.backgroundColor
        
//        commentText.delegate = self
//        commentText.text = "Your Comment Here"
//        commentText.textColor = UIColor.lightGrayColor()
        
        self.submitButton.layer.borderWidth = 2
        self.submitButton.layer.borderColor = AppearanceHelper.itemColor().CGColor
        self.submitButton.layer.cornerRadius = 5
    }
    
//    func textViewDidBeginEditing(textView: UITextView) {
//        
//        print("Begin Editing")
//        if textView.textColor == UIColor.lightGrayColor() {
//            textView.text = nil
//            textView.textColor = AppearanceHelper.itemColor()
//        }
//    }
//    
//    func textViewDidEndEditing(textView: UITextView) {
//        print("End Editing")
//        if textView.text.isEmpty {
//            textView.text = "Your Comment Here"
//            textView.textColor = UIColor.lightGrayColor()
//        }
//    }
    
    override func setSelected(selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)
        
        // Configure the view for the selected state
        //let bg = self.contentView.backgroundColor
        commentText.backgroundColor = tvbg
        self.contentView.backgroundColor = bg
    }
    
    override func setHighlighted(highlighted: Bool, animated: Bool) {
        //let bg = AppearanceHelper.mainColorDark()
        commentText.backgroundColor = tvbg
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
