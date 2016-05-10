//
//  AudioCell.swift
//  Bandit
//
//  Created by Piyoros Vephula on 11/19/2558 BE.
//  Copyright © 2558 Piyoros Vephula. All rights reserved.
//

import UIKit
import Parse
import AVKit
import AVFoundation

//public var player = AVPlayer()

// This protocol allows communication between the message button, and switch in the cell.
//protocol AudioCellDelegate: class {
//    func didPlayAudio(sender: AudioCell, playing: Bool)
//    func moveSlider(sender: AudioCell)
//}

class AudioCell: UITableViewCell {
    
    //weak var delegate: AudioCellDelegate?
    
    var audioURLString: String?
    
    var displayLink = CADisplayLink()
    var isPlaying: Bool = false

    @IBOutlet weak var title: UILabel!
    @IBOutlet weak var cover: UIImageView!
    @IBOutlet weak var slider: UISlider!
    
    @IBOutlet weak var playButton: UIButton!
    
    @IBAction func playAudio(sender: UIButton) {
        if isPlaying == false {
            let url = NSURL(string: audioURLString!)
            player = AVPlayer(URL: url!)
            player.play()
            displayLink = CADisplayLink(target: self, selector: ("updateSliderProgress"))
            displayLink.addToRunLoop(NSRunLoop.currentRunLoop(), forMode: NSDefaultRunLoopMode)
            //indicator.hidden = false
            isPlaying = true
            //playButton.setTitle("Pause", forState: .Normal)
            playButton.setImage(UIImage(named: "bandit-button-02.png"), forState: UIControlState.Normal)
        } else {
            player.pause()
            displayLink.invalidate()
            isPlaying = false
            //playButton.setTitle("Play", forState: .Normal)
            playButton.setImage(UIImage(named: "bandit-button-01.png"), forState: UIControlState.Normal)
        }
    }
    
    @IBAction func sliderMove(sender: UISlider) {
        let value = sender.value
        let du = Float(CMTimeGetSeconds(player.currentItem!.duration))
        let ct = value * du
        let ctInt = Float64(ct)
        let preferredTimeScale : Int32 = 1
        player.currentItem?.seekToTime(CMTimeMakeWithSeconds(ctInt, preferredTimeScale))
    }
    
    
    func updateSliderProgress() {
        let ct = Float(CMTimeGetSeconds(player.currentTime()))
        let du = Float(CMTimeGetSeconds(player.currentItem!.duration))
        let progress = ct / du
        
        slider.value = progress
        
//        if progress.isNaN || progress == 0.0 {
//            indicator.hidden = false
//        } else {
//            indicator.hidden = true
//        }
    }
    
    
    
}
