//
//  SeeVideo.swift
//  YoupornViewer
//
//  Created by fabrizio chimienti on 07/10/15.
//  Copyright © 2015 fabrizio chimienti. All rights reserved.
//

import Foundation
import UIKit
import AVKit
import AVFoundation

class AVVideoPlayerController: AVPlayerViewController{
    var downloadVideo: DownloadLink!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        let url = NSURL(string:  String(htmlEncodedString: downloadVideo.Link))
        player = AVPlayer(URL: url!)
        player?.play()
        NSTimer.scheduledTimerWithTimeInterval(2, target: self, selector: "tick", userInfo: nil, repeats: true)
    }
    
    
    func tick() {//Failed case
        if(player!.status == .Failed)
        {
            let url = NSURL(string:  String(htmlEncodedString: downloadVideo.Link))
            let item = AVPlayerItem(URL: url!)
            player?.replaceCurrentItemWithPlayerItem(item)
        }
    }
}


extension String {
    init(htmlEncodedString: String) {
        let encodedData = htmlEncodedString.dataUsingEncoding(NSUTF8StringEncoding)!
        let attributedOptions : [String: AnyObject] = [
            NSDocumentTypeDocumentAttribute: NSHTMLTextDocumentType,
            NSCharacterEncodingDocumentAttribute: NSUTF8StringEncoding
        ]
        var attributedString = NSAttributedString()
        do{
            attributedString = try NSAttributedString(data: encodedData, options: attributedOptions, documentAttributes: nil)
            
        }catch{
            print("error")
        }
        self.init(attributedString.string)
    }
}
