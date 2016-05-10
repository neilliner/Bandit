//
//  MainTabBarController.swift
//  Bandit
//
//  Created by Piyoros Vephula on 2/20/16.
//  Copyright © 2016 Piyoros Vephula. All rights reserved.
//

import UIKit

class MainTabBarController: UITabBarController, UINavigationControllerDelegate  {
    
    @IBOutlet weak var mainTabBar: UITabBar!
    let tabBarItems = CGFloat(5)

    override func viewDidLoad() {
        super.viewDidLoad()
        
        // Sets the default color of the icon of the selected UITabBarItem and Title
        UITabBar.appearance().tintColor = UIColor.whiteColor()
        // Sets the default color of the background of the UITabBar
        UITabBar.appearance().barTintColor = AppearanceHelper.mainColor()
        
        UITabBarItem.appearance().setTitleTextAttributes([NSForegroundColorAttributeName: AppearanceHelper.subColorLight(),NSFontAttributeName: UIFont(name: "HelveticaNeue-Bold", size: 9)!], forState:.Normal)
        UITabBarItem.appearance().titlePositionAdjustment = UIOffset(horizontal: 0, vertical: -4)
        //UITabBarItem.appearance().setTitleTextAttributes([], forState: .Normal)
        UITabBarItem.appearance().setTitleTextAttributes([NSForegroundColorAttributeName: UIColor.whiteColor()], forState:.Selected)
        
        // Sets the background color of the selected UITabBarItem (using and plain colored UIImage with the width = 1/5 of the tabBar (if you have 5 items) and the height of the tabBar)
        UITabBar.appearance().selectionIndicatorImage = UIImage().makeImageWithColorAndSize(AppearanceHelper.subColor(), size: CGSizeMake(tabBar.frame.width/tabBarItems, tabBar.frame.height))
        
        // Uses the original colors for your images, so they aren't not rendered as grey automatically.
//        for item in self.mainTabBar.items! {
//            if let image = item.image {
//                item.image = image.imageWithRenderingMode(.AlwaysOriginal)
//            }
//        }
        
        for item in self.mainTabBar.items! as [UITabBarItem] {
            if let image = item.image {
                item.image = image.imageWithColor(AppearanceHelper.subColorLight()).imageWithRenderingMode(.AlwaysOriginal)
            }
        }
    }
}

extension UIImage {
    func makeImageWithColorAndSize(color: UIColor, size: CGSize) -> UIImage {
        UIGraphicsBeginImageContextWithOptions(size, false, 0)
        color.setFill()
        UIRectFill(CGRectMake(0, 0, size.width, size.height))
        var image = UIGraphicsGetImageFromCurrentImageContext()
        UIGraphicsEndImageContext()
        return image
    }
}

extension UIImage {
    func imageWithColor(tintColor: UIColor) -> UIImage {
        UIGraphicsBeginImageContextWithOptions(self.size, false, self.scale)
        
        let context = UIGraphicsGetCurrentContext()! as CGContextRef
        CGContextTranslateCTM(context, 0, self.size.height)
        CGContextScaleCTM(context, 1.0, -1.0);
        CGContextSetBlendMode(context, CGBlendMode.Normal)
        
        let rect = CGRectMake(0, 0, self.size.width, self.size.height) as CGRect
        CGContextClipToMask(context, rect, self.CGImage)
        tintColor.setFill()
        CGContextFillRect(context, rect)
        
        let newImage = UIGraphicsGetImageFromCurrentImageContext() as UIImage
        UIGraphicsEndImageContext()
        
        return newImage
    }
}
