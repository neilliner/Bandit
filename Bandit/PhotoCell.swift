//
//  PhotoCell.swift
//  Bandit
//
//  Created by Piyoros Vephula on 11/19/2558 BE.
//  Copyright © 2558 Piyoros Vephula. All rights reserved.
//

import UIKit
import Parse
import ParseUI

class PhotoCell:  UITableViewCell {

    @IBOutlet weak var photoScrollView: UIScrollView!
    
    var photoArray = [PFObject]()
    var widthOfScrollView:CGFloat = 0.0
    var shouldShowAddIcon = false
    var addIcon:UIImageView?
    
    override func awakeFromNib() {
        super.awakeFromNib()
    }
    
    func loadImages() {
        
        let imgWH = 125
        let imgMargin = 8
        
        var xPos = 0
        
        for var i = 0 ; i < photoArray.count ; i++ {
            
            
            xPos = imgMargin + ((imgWH + imgMargin) * i)
            
            let pfImageView = PFImageView(frame: CGRect(x: xPos, y: imgMargin, width: imgWH, height: imgWH))
            
            widthOfScrollView = CGFloat(xPos)
//            let widthConstraint = NSLayoutConstraint(item: pfImageView, attribute: NSLayoutAttribute.Width, relatedBy: NSLayoutRelation.Equal, toItem: nil, attribute: NSLayoutAttribute.NotAnAttribute, multiplier: 1, constant: 100)
//            let heightConstraint = NSLayoutConstraint(item: pfImageView, attribute: NSLayoutAttribute.Height, relatedBy: NSLayoutRelation.Equal, toItem: nil, attribute: NSLayoutAttribute.NotAnAttribute, multiplier: 1, constant: 100)
            
            
            photoScrollView.addSubview(pfImageView)
            //pfImageView.backgroundColor = UIColor.redColor()
            let imageFile = photoArray[i].objectForKey("photo") as! PFFile
            pfImageView.file = imageFile
            pfImageView.clipsToBounds = true
            pfImageView.contentMode = .ScaleAspectFill
            //pfImageView.addConstraint(widthConstraint)
            //pfImageView.addConstraint(heightConstraint)
            pfImageView.loadInBackground()
        }
        
        if shouldShowAddIcon == true {
            let iconSize = CGSize(width: imgWH, height: imgWH)
            xPos = xPos + imgMargin + imgWH
            addIcon = UIImageView(frame: CGRect(origin: CGPoint(x: xPos, y: imgMargin), size: iconSize))
            //addIcon.image = addIcon.image!.imageWithRenderingMode(UIImageRenderingMode.AlwaysTemplate)
            //addIcon.tintColor = UIColor.redColor()
            var image = drawSquare(iconSize)
            image = textToImage("Add Photo", inImage: image, atPoint: CGPointMake(32, (iconSize.height/2) - CGFloat(imgMargin)))
            addIcon!.image = image
            
            self.photoScrollView.addSubview(addIcon!)
            widthOfScrollView = CGFloat(xPos)
        }
        
        //photoScrollView.bounds = CGRectInset(photoScrollView.frame, 10.0, 10.0);
        photoScrollView.contentSize = CGSize(width: widthOfScrollView + CGFloat(imgWH + imgMargin), height: CGFloat(imgWH))
        
    }
    
    func drawSquare(size: CGSize) -> UIImage {
        // Setup our context
        let bounds = CGRect(origin: CGPoint.zero, size: size)
        let opaque = false
        let scale: CGFloat = 0
        UIGraphicsBeginImageContextWithOptions(size, opaque, scale)
        let context = UIGraphicsGetCurrentContext()
        
        // Setup complete, do drawing here
        CGContextSetStrokeColorWithColor(context, AppearanceHelper.itemColor().CGColor)
        CGContextSetLineWidth(context, 3.0)
        
        CGContextStrokeRect(context, bounds)
        
        CGContextBeginPath(context)
        CGContextMoveToPoint(context, CGRectGetMinX(bounds), CGRectGetMinY(bounds))
        //CGContextAddLineToPoint(context, CGRectGetMaxX(bounds), CGRectGetMaxY(bounds))
        CGContextMoveToPoint(context, CGRectGetMaxX(bounds), CGRectGetMinY(bounds))
        //CGContextAddLineToPoint(context, CGRectGetMinX(bounds), CGRectGetMaxY(bounds))
        CGContextStrokePath(context)
        
        // Drawing complete, retrieve the finished image and cleanup
        let image = UIGraphicsGetImageFromCurrentImageContext()
        UIGraphicsEndImageContext()
        return image
    }
    
    func textToImage(drawText: NSString, inImage: UIImage, atPoint:CGPoint) -> UIImage {
        
        // Setup the font specific variables
        let textColor: UIColor = AppearanceHelper.itemColor()
        let textFont: UIFont = UIFont(name: "Helvetica Bold", size: 12)!
        
        //Setup the image context using the passed image.
        UIGraphicsBeginImageContext(inImage.size)
        
        //Setups up the font attributes that will be later used to dictate how the text should be drawn
        let textFontAttributes = [
            NSFontAttributeName: textFont,
            NSForegroundColorAttributeName: textColor,
        ]
        
        //Put the image into a rectangle as large as the original image.
        inImage.drawInRect(CGRectMake(0, 0, inImage.size.width, inImage.size.height))
        
        // Creating a point within the space that is as bit as the image.
        let rect: CGRect = CGRectMake(atPoint.x, atPoint.y, inImage.size.width, inImage.size.height)
        
        //Now Draw the text into an image.
        drawText.drawInRect(rect, withAttributes: textFontAttributes)
        
        // Create a new image out of the images we have created
        let newImage: UIImage = UIGraphicsGetImageFromCurrentImageContext()
        
        // End the context now that we have the image we need
        UIGraphicsEndImageContext()
        
        //And pass it back up to the caller.
        return newImage
        
    }

}


