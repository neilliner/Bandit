//
//  BandInfoViewController.swift
//  Bandit
//
//  Created by Piyoros Vephula on 11/28/15.
//  Copyright © 2015 Piyoros Vephula. All rights reserved.
//

import UIKit
import Parse

class BandInfoViewController: UIViewController {
    
    var band:PFObject?

    @IBOutlet weak var bandInfo: UITextView!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.tabBarController?.tabBar.hidden = true
        self.navigationItem.setHidesBackButton(true, animated:false)
        self.navigationController?.navigationBar.setBackgroundImage(UIImage(), forBarMetrics: UIBarMetrics.Default)
        self.navigationController?.navigationBar.shadowImage = UIImage()
        self.navigationController?.navigationBar.translucent = true
        self.navigationController?.hidesBarsOnSwipe = false
        let stop = UIBarButtonItem(barButtonSystemItem: .Stop, target: self, action: "goBack")
        stop.tintColor = UIColor(red: 0.96862745, green: 0.05093039, blue: 0.32156862, alpha: 1.0)
        self.navigationItem.rightBarButtonItem = stop
        
        if let info = band!["info"] as? String{
            bandInfo.text = info
        }
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    func goBack(){
        self.navigationController?.popViewControllerAnimated(true)
    }

    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepareForSegue(segue: UIStoryboardSegue, sender: AnyObject?) {
        // Get the new view controller using segue.destinationViewController.
        // Pass the selected object to the new view controller.
    }
    */

}
