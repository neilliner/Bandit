//
//  BoardCell.swift
//  Bandit
//
//  Created by Piyoros Vephula on 11/18/2558 BE.
//  Copyright © 2558 Piyoros Vephula. All rights reserved.
//

import UIKit
import Parse
import ParseUI

class BoardCell:  PFTableViewCell {
    
    var instArray = [String]()
    var genreArray = [String]()
    var boardObj:PFObject?
    
    @IBOutlet weak var boardImage: UIImageView!
    @IBOutlet weak var boardType: UILabel!
    @IBOutlet weak var subject: UILabel!
    @IBOutlet weak var creator: UILabel!
    @IBOutlet weak var instrument: UILabel!
    @IBOutlet weak var genre: UILabel!
    @IBOutlet weak var exp: UILabel!
    @IBOutlet weak var dateCompLabel: UILabel!
    @IBOutlet weak var dateComp: UILabel!
    @IBOutlet weak var instView: UIView!
    
    let gradientLayer = CAGradientLayer()
    
    
    override func awakeFromNib() {
        super.awakeFromNib()
        //print("^^^^^^^^^^^^^^^^^^")
        //print(boardObj)
        //print("^^^^^^^^^^^^^^^^^^")

        //instArray = getInstrumentsForBoard(boardObj!)
        ///loadImages()
        //self.contentView.layer.cornerRadius = 3.0
        //self.contentView.layer.borderWidth = 0.5
        
        gradientLayer.frame = boardImage.bounds
        
        let color1 = UIColor.blackColor().CGColor as CGColorRef
        let color2 = UIColor(red: 0.0, green: 0, blue: 0, alpha: 0.0).CGColor as CGColorRef
        gradientLayer.colors = [color1, color2]
        gradientLayer.locations = [0.0, 0.5]
        
        self.boardImage.layer.addSublayer(gradientLayer)
        
    }
    
    override func setSelected(selected: Bool, animated: Bool) {
        
        // prevent labels' background color disappearing after selected(tapped)
        let wbg = UIColor.whiteColor()
        let bg = AppearanceHelper.mainColor()
        
        self.subject.backgroundColor = bg
        //self.creator.backgroundColor = bg
        //self.instrument.backgroundColor = bg
        self.genre.backgroundColor = bg
        //self.exp.backgroundColor = bg
    }
    
    override func setHighlighted(highlighted: Bool, animated: Bool) {
        
        // prevent labels' background color disappearing after selected(tapped)
        let wbg = UIColor.whiteColor()
        let bg = AppearanceHelper.mainColor()
        
        self.subject.backgroundColor = bg
        //self.creator.backgroundColor = bg
        //self.instrument.backgroundColor = bg
        self.genre.backgroundColor = bg
        //self.exp.backgroundColor = bg
    }
    
    func changeLabel(type: String) {
        switch type {
            case "Audition": dateCompLabel.text = "audition date"
            case "Gig": dateCompLabel.text = "gig date & compensation "
            case "Jam": dateCompLabel.text = "Jam date & fee"
            case "Permanent": dateCompLabel.text = "hiring until"
            default: dateCompLabel.text = "date & compensation"
        }
    }
    
    func getInstrumentsForBoard(boardItem: PFObject) -> [String] {
        var instruments = [String]()
        var instrumentsObj = [PFObject]()
        let query = PFQuery(className: "BoardInst")
        query.whereKey("boardId", equalTo: boardItem)
        do{
            instrumentsObj = try query.findObjects()
        }
        catch{
            print("Instrument not found")
        }
        
        for i in instrumentsObj {
            instruments.append(i.objectForKey("instrument") as! String)
        }
        print("$$$$$$$$$$$$$")
        print(instruments)
        return instruments
    }
    
    func loadImages() {
        print(instArray)
        //var widthOfScrollView:CGFloat = 0.0
        let imgWH = 30;
        let imgMar = 10;
        
        var xPos = 0
        for var i = 0 ; i < instArray.count ; i++ {
            
            //var xPos = 0
            xPos = imgMar + ((imgWH + imgMar) * i)
            //xPos = (Int(instView.frame.width)/2) - ((imgWH + imgMar) * instArray.count)/2 + ((imgWH + imgMar) * i) + (imgMar/2)
            //xPos = (Int(instView.frame.width)/2) - ((imgWH + imgMar))/2 + ((imgWH + imgMar))
            
            //let pfImageView = PFImageView(frame: CGRect(x: xPos+(imgMar/2), y: 0, width: imgWH, height: imgWH))
            
            let imageViewObject = UIImageView(frame:CGRectMake(CGFloat(xPos), 0, CGFloat(imgWH), CGFloat(imgWH)))
            imageViewObject.image = AppearanceHelper.imageForInst(instArray[i])
            //imageViewObject.image = imageViewObject.image!.imageWithRenderingMode(UIImageRenderingMode.AlwaysTemplate)
            //imageViewObject.tintColor = AppearanceHelper.UIColorFromHex(0xAAAAAA)
            imageViewObject.contentMode = UIViewContentMode.ScaleAspectFill
            self.instView.addSubview(imageViewObject)
            
            //memberScrollView.addSubview(pfImageView)
            //let imageFile = memberArray[i].objectForKey("image") as! PFFile
            //pfImageView.file = imageFile
            
            //pfImageView.contentMode = .ScaleAspectFill
            //pfImageView.loadInBackground()
            //pfImageView.layer.masksToBounds = false
            //pfImageView.layer.cornerRadius = pfImageView.frame.size.width/2
            //pfImageView.clipsToBounds = true
        }
    }
}
