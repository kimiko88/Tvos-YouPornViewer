//
//  VideoController.swift
//  YoupornViewer
//
//  Created by kimiko88 on 04/10/15.
//  Copyright © 2015 kimiko88. All rights reserved.
//

import UIKit


class DownloadLink{
    var Link: String
    var Title: String
    init(link: String, title: String){
        Link = link
        Title = title
    }
}

class VideoController: UIViewController {
    
    var bounds = UIScreen.main.bounds
    var video: Video!
    
    var downloadLinks = [DownloadLink]()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        let url = URL(string: self.video.Link)
        let task = URLSession.shared.dataTask(with: url!, completionHandler: {(data, response, error) in
            let stringa = NSString(data: data!, encoding: String.Encoding.utf8.rawValue)!
            let strin = String(stringa)
            let splitted = strin.split{$0 == " "}.map(String.init)
            var i = 0
            while i < splitted.count
            {
                let oo = splitted[i]
                
                if (oo.range(of: "downloadOption") != nil){
                    var tempLink = ""
                    var tempTitle = ""
                    var start = false
                    i += 1
                    while((splitted[i].range(of: "/a>")) == nil)
                    {
                        i += 1
                        if(splitted[i].range(of: "|||") != nil){
                            tempLink = splitted[i].components(separatedBy: "|||")[1]
                        }
                        
                        if(splitted[i].range(of: "\'>") != nil && tempLink.count > 2){
                            start = true
                        }
                        if(start)
                        {
                            tempTitle += " " + splitted[i]
                        }
                        
                    }
                    let link = tempLink.replacingOccurrences(of: "href='", with: "")
                    let title = tempTitle.components(separatedBy: "\n")[1]
                    self.downloadLinks.append(DownloadLink(link: link, title: title))
                }
                i += 1
            }
            
            
            DispatchQueue.main.async{
                var i = 0
                
                for downloadLink in self.downloadLinks{
                    if(downloadLink.Title.range(of: "3GP") == nil)//AVPlayer for tvos can't play 3GP file
                    {
                        self.createButton(downloadLink,index: i)
                    }
                    i += 1;
                }
            }
        }) 
        task.resume()
    }
    
    
    @objc func tapped(_ sender: UIButton) {
        let object = self.downloadLinks[sender.tag]
        
        self.performSegue(withIdentifier: "SeeVideo", sender: object)
    }
    
    
    
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any!) {
        let video = sender as! DownloadLink
        if segue.identifier == "SeeVideo"{
            let vc = segue.destination as! AVVideoPlayerController
            vc.downloadVideo = video
        }
    }
    
    func createButton(_ download: DownloadLink, index: Int){
        let numImagePerRow = Int(bounds.width) / (Int(1600) + 20)
        let width = CGFloat(1600)
        let height = CGFloat(180)
        let x = (index % numImagePerRow) * Int(width) + 20 * (index % numImagePerRow)
        let y = index / numImagePerRow * Int(height) + 20 * (index / numImagePerRow)
        let button = UIButton(type: UIButtonType.system)
        button.frame =  CGRect(x: CGFloat(x), y: CGFloat(y), width: width, height: height)
        button.setTitle(download.Title, for: UIControlState())
        button.titleLabel?.text = download.Title
        button.tag = index
        button.addTarget(self, action: #selector(VideoController.tapped(_:)), for: .primaryActionTriggered)
        button.clipsToBounds = true
        self.view.addSubview(button)
        self.view.clipsToBounds = true
    }
    
    
    
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
    }
    
}


