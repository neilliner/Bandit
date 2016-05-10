//
//  AppearanceHelper.swift
//  Bandit
//
//  Created by Piyoros Vephula on 2/20/16.
//  Copyright © 2016 Piyoros Vephula. All rights reserved.
//

import Foundation
import UIKit

class AppearanceHelper {
    
    static func mainColor() -> UIColor {
        return AppearanceHelper.UIColorFromHex(0x03032B)
    }
    
    static func mainColorDark() -> UIColor {
        return AppearanceHelper.UIColorFromHex(0x03022B)
    }
    
    static func itemColor() -> UIColor {
        return AppearanceHelper.UIColorFromHex(0xFC0D52)
    }
    
    static func subColor() -> UIColor {
        return AppearanceHelper.UIColorFromHex(0x5547FF)
    }
    
    static func subColorLight() -> UIColor {
        return AppearanceHelper.UIColorFromHex(0x9C9CAD)
    }
    
    static func backgroundDark() -> UIColor {
        return AppearanceHelper.UIColorFromHex(0x2C2C35)
    }

    static func UIColorFromHex(rgbValue: UInt) -> UIColor {
        return UIColor(
            red: CGFloat((rgbValue & 0xFF0000) >> 16) / 255.0,
            green: CGFloat((rgbValue & 0x00FF00) >> 8) / 255.0,
            blue: CGFloat(rgbValue & 0x0000FF) / 255.0,
            alpha: CGFloat(1.0)
        )
    }
    
    static func UIColorFromHexWithAlpha(rgbValue: UInt, opac: CGFloat) -> UIColor {
        return UIColor(
            red: CGFloat((rgbValue & 0xFF0000) >> 16) / 255.0,
            green: CGFloat((rgbValue & 0x00FF00) >> 8) / 255.0,
            blue: CGFloat(rgbValue & 0x0000FF) / 255.0,
            alpha: CGFloat(opac)
        )
    }
    
    static func imageForInst(ins: String) -> UIImage {
        var img:UIImage?
        switch ins {
        case "Vocal"            : img = UIImage(named: "inst-icon-01.png")
        case "Electric Guitar"  : img = UIImage(named: "inst-icon-02.png")
        case "Bass"             : img = UIImage(named: "inst-icon-03.png")
        case "Drum"             : img = UIImage(named: "inst-icon-04.png")
        case "Keyboard"         : img = UIImage(named: "inst-icon-05.png")
        case "Acoustic Guitar"  : img = UIImage(named: "inst-icon-06.png")
        case "Wind"             : img = UIImage(named: "inst-icon-07.png")
        case "Synthesizer"      : img = UIImage(named: "inst-icon-08.png")
        case "Percussion"       : img = UIImage(named: "inst-icon-09.png")
        default                 : img = UIImage(named: "inst-icon-10.png")
        }
        return img!
    }
    
}

extension UISegmentedControl {
    func removeBorders() {
        setBackgroundImage(imageWithColor(UIColor.clearColor()), forState: .Normal, barMetrics: .Default)
        setBackgroundImage(imageWithColor(UIColor.clearColor()), forState: .Selected, barMetrics: .Default)
        setDividerImage(imageWithColorSize(tintColor!,size: 3.0), forLeftSegmentState: .Normal, rightSegmentState: .Normal, barMetrics: .Default)
        //setDividerImage(imageWithColorSize(tintColor!,size: 2.0), forLeftSegmentState: .Selected, rightSegmentState: .Selected, barMetrics: .Default)
    }
    
    // create a 1x1 image with this color
    private func imageWithColor(color: UIColor) -> UIImage {
        let rect = CGRectMake(0.0, 0.0, 1.0, 1.0)
        UIGraphicsBeginImageContext(rect.size)
        let context = UIGraphicsGetCurrentContext()
        CGContextSetFillColorWithColor(context, color.CGColor);
        CGContextFillRect(context, rect);
        let image = UIGraphicsGetImageFromCurrentImageContext();
        UIGraphicsEndImageContext();
        return image
    }
    
    private func imageWithColorSize(color: UIColor, size: Float) -> UIImage {
        let rect = CGRectMake(-1.0, 0.0, CGFloat(size), CGFloat(size))
        UIGraphicsBeginImageContext(rect.size)
        let context = UIGraphicsGetCurrentContext()
        CGContextSetFillColorWithColor(context, color.CGColor);
        CGContextFillRect(context, rect);
        let image = UIGraphicsGetImageFromCurrentImageContext();
        UIGraphicsEndImageContext();
        return image
    }
}

// Ed Gamble - SOF
extension Array {
    func isIndexNotOver (i:Int) -> Element? {
        return 0 <= i && i < count ? self[i] : nil
    }
}
