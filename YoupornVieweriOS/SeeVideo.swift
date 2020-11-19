//
//  SeeVideo.swift
//  YoupornViewer
//
//  Created by kimiko88 on 07/10/15.
//  Copyright © 2015 kimiko88. All rights reserved.
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
        player = AVPlayer(url: url! as URL)
        player?.play()
        Timer.scheduledTimer(timeInterval: 2, target: self, selector: Selector(("tick")), userInfo: nil, repeats: true)
    }
    
    
    func tick() {//Failed case
        if(player!.status == .failed)
        {
            let url = NSURL(string:  String(htmlEncodedString: downloadVideo.Link))
            let item = AVPlayerItem(url: url! as URL)
            player?.replaceCurrentItem(with: item)
        }
    }
}


extension String {
    init(htmlEncodedString: String) {
        let encodedData = htmlEncodedString.data(using: String.Encoding.utf8)!
        let attributedOptions: [ NSAttributedString.DocumentReadingOptionKey: AnyObject ] = [ NSAttributedString.DocumentReadingOptionKey(rawValue: NSAttributedString.DocumentAttributeKey.documentType.rawValue): NSAttributedString.DocumentType.html as AnyObject, NSAttributedString.DocumentReadingOptionKey(rawValue: NSAttributedString.DocumentAttributeKey.characterEncoding.rawValue): NSNumber(value: String.Encoding.utf8.rawValue) as AnyObject ]

        var attributedString = NSAttributedString()
        do{
            attributedString = try NSAttributedString(data: encodedData, options: attributedOptions, documentAttributes: nil)
            
        }catch{
            print("error")
        }
        self.init(attributedString.string)
    }
}
