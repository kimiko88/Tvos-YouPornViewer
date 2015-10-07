//
//  VideoController.swift
//  YoupornViewer
//
//  Created by fabrizio chimienti on 04/10/15.
//  Copyright © 2015 fabrizio chimienti. All rights reserved.
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

    var bounds = UIScreen.mainScreen().bounds
    var video: Video!
    
    var downloadLinks = [DownloadLink]()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        let url = NSURL(string: self.video.Link)
        let task = NSURLSession.sharedSession().dataTaskWithURL(url!) {(data, response, error) in
            let stringa = NSString(data: data!, encoding: NSUTF8StringEncoding)!
            let strin = String(stringa)
            let splitted = strin.characters.split{$0 == " "}.map(String.init)
            for (var i = 0; i < splitted.count; i++)
            {
                let oo = splitted[i]

                if (oo.rangeOfString("downloadOption") != nil){
                    var tempLink = ""
                    var tempTitle = ""
                    var start = false
                    i++
                    while((splitted[i].rangeOfString("/a>")) == nil)
                    {
                        i++
                        if(splitted[i].rangeOfString("href=") != nil){
                           tempLink = splitted[i]
                        }
                        
                        if(splitted[i].rangeOfString("\'>") != nil && tempLink.characters.count > 2){
                            start = true
                        }
                        if(start)
                        {
                           tempTitle += " " + splitted[i]
                        }
                     
                    }
                    let link = tempLink.stringByReplacingOccurrencesOfString("href='", withString: "")
                    let title = tempTitle.stringByReplacingOccurrencesOfString(" Video'>", withString: "").stringByReplacingOccurrencesOfString("</a>\n<span", withString: "")
                    self.downloadLinks.append(DownloadLink(link: link, title: title))
                }
            }
            
            
            dispatch_async(dispatch_get_main_queue()){
            var i = 0
            
            for downloadLink in self.downloadLinks{
                if(downloadLink.Title.rangeOfString("3GP") == nil)//AVPlayer for tvos can't play 3GP file
                {
                                   self.createButton(downloadLink,index: i)
                }
                                    i++;
                                }
            }
        }
        task.resume()
    }
    
    
    func tapped(sender: UIButton) {
        let object = self.downloadLinks[sender.tag]

       self.performSegueWithIdentifier("SeeVideo", sender: object)
    }

  
    
    
    override func prepareForSegue(segue: UIStoryboardSegue, sender: AnyObject!) {
        let video = sender as! DownloadLink
        if segue.identifier == "SeeVideo"{
            let vc = segue.destinationViewController as! AVVideoPlayerController
            vc.downloadVideo = video
        }
    }
    
    func createButton(download: DownloadLink, index: Int){
        let numImagePerRow = Int(bounds.width) / (Int(1600) + 20)
        let width = CGFloat(1600)
        let height = CGFloat(180)
        let x = (index % numImagePerRow) * Int(width) + 20 * (index % numImagePerRow)
        let y = index / numImagePerRow * Int(height) + 20 * (index / numImagePerRow)
        let button = UIButton(type: UIButtonType.System)
        button.frame =  CGRectMake(CGFloat(x), CGFloat(y), width, height)
        button.setTitle(download.Title, forState: .Normal)
        button.tag = index
        button.addTarget(self, action: "tapped:", forControlEvents: .PrimaryActionTriggered)
        button.clipsToBounds = true
        self.view.addSubview(button)
        self.view.clipsToBounds = true
    }
    
    
    
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
    }
    
}


