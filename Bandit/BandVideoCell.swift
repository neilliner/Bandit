//
//  BandVideoCell.swift
//  Bandit
//
//  Created by Piyoros Vephula on 3/20/16.
//  Copyright © 2016 Piyoros Vephula. All rights reserved.
//

import UIKit

class BandVideoCell: UITableViewCell{
    
    @IBOutlet weak var title: UILabel!
    @IBOutlet weak var videoiframe: UIWebView!
    
    let youTubeEmbedURL = "https://www.youtube.com/embed/"
    let youTubeOption = "?rel=0&amp;controls=0&amp;showinfo=0"
    //var videoId:String!
    
    override func awakeFromNib() {
        super.awakeFromNib()
        //let vdoURL = youTubeEmbedURL + videoId
        
        //videoId = "FV0YNSKyJ8o"
        //if videoId != nil {
        videoiframe.allowsInlineMediaPlayback = true
        videoiframe.scrollView.scrollEnabled = false
        videoiframe.scrollView.bounces = false
        
        //print(videoId)
        //}
        
    }
    
    func loadYouTube(videoId: String){
        videoiframe.loadHTMLString("<body style=\"margin:0;\"><iframe width=\"\(videoiframe.frame.width)\" height=\"\(videoiframe.frame.height)\" src=\"\(youTubeEmbedURL)\(videoId)\(youTubeOption)\"frameborder=\"0\" allowfullscreen></iframe></body>", baseURL: nil)
    }
    
    
}
