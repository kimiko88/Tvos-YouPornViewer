//
//  SeeVideo.swift
//  YoupornViewer
//
//  Created by fabrizio chimienti on 12/11/15.
//  Copyright © 2015 fabrizio chimienti. All rights reserved.
//

import Foundation
import AVKit
import AVFoundation

class AVVideoPlayerController: NSViewController{
    var downloadVideo: DownloadLink!
    var timer = NSTimer()
     @IBOutlet weak var play: AVPlayerView!
    override func viewDidLoad() {
        super.viewDidLoad()
        
        let url = NSURL(string:  String(htmlEncodedString: downloadVideo.Link))
        play.player = AVPlayer(URL: url!)
        play.player!.play()
        play.showsFullScreenToggleButton = true
        play.showsFrameSteppingButtons = true
        timer = NSTimer.scheduledTimerWithTimeInterval(2, target: self, selector: "tick", userInfo: nil, repeats: true)
    }
    
    override func viewDidDisappear() {
        play.player?.pause()
        play.player?.cancelPendingPrerolls()
        play.player = nil
        timer.invalidate()
    
    }
    
    func tick() {//Failed case
        
        if(play.player!.status == .Failed)
        {
            let url = NSURL(string:  String(htmlEncodedString: downloadVideo.Link))
            let item = AVPlayerItem(URL: url!)
            play.player!.replaceCurrentItemWithPlayerItem(item)
        }
    }
}