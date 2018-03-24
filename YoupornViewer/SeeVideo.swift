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

class AVVideoPlayerController: AVPlayerViewController{
        var downloadVideo: DownloadLink!
    
    override func viewDidLoad() {
        super.viewDidLoad()

    let url = URL(string:  String(htmlEncodedString: downloadVideo.Link))
    player = AVPlayer(url: url!)
    player?.play()
        Timer.scheduledTimer(timeInterval: 2, target: self, selector: #selector(AVVideoPlayerController.tick), userInfo: nil, repeats: true)
       
    }

    
    @objc func tick() {//Failed case
        if(player!.status == .failed)
        {
                let url = URL(string:  String(htmlEncodedString: downloadVideo.Link))
            let item = AVPlayerItem(url: url!)
            player?.replaceCurrentItem(with: item)
        }
    }
}


extension String {
    init(htmlEncodedString: String) {
        let encodedData = htmlEncodedString.data(using: String.Encoding.utf8)!
        let attributedOptions: [ NSAttributedString.DocumentReadingOptionKey: AnyObject ] = [ NSAttributedString.DocumentReadingOptionKey.documentType: NSAttributedString.DocumentType.html as AnyObject, NSAttributedString.DocumentReadingOptionKey.characterEncoding: NSNumber(value: String.Encoding.utf8.rawValue) as AnyObject ]

        var attributedString = NSAttributedString()
        do{
            attributedString = try NSAttributedString(data: encodedData, options: attributedOptions, documentAttributes: nil)
            
        }catch{
            print("error")
        }
        self.init(attributedString.string)
    }
}
