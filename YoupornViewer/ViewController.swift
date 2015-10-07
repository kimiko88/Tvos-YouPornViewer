//
//  ViewController.swift
//  YoupornViewer
//
//  Created by fabrizio chimienti on 04/10/15.
//  Copyright © 2015 fabrizio chimienti. All rights reserved.
//

import UIKit
import Foundation



class Video{
    var Link: String
    var ImageLink: String
    var Title: String
    init(link: String, imageLink: String, title: String)
    {
        Link = link
        ImageLink = imageLink
        Title = title
    }
}

class ViewController: UIViewController {
        var videos = [Video]()
    var actualPage = 1;
    var bounds = UIScreen.mainScreen().bounds
    var scroll = UIScrollView()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.view = self.scroll;
        showPage(actualPage)
        
    }
    
    
    

    func showPage(actualPage: Int){
        videos = [Video]()
        let subViews = self.scroll.subviews
        for subview in subViews{
            subview.removeFromSuperview()
        }
        let url = NSURL(string: "http://www.youporn.com/?page=\(actualPage)")
        
        let task = NSURLSession.sharedSession().dataTaskWithURL(url!) {(data, response, error) in
            let stringa = NSString(data: data!, encoding: NSUTF8StringEncoding)!
            let strin = String(stringa)
            let splitted = strin.characters.split{$0 == " "}.map(String.init)
            
            for (var i = 0; i < splitted.count; i++)
            {
                let oo = splitted[i]
                if (oo.rangeOfString("href=\"/watch/") != nil && splitted[i + 1].rangeOfString("class='video-box-image'") != nil){
                    let link = oo.stringByReplacingOccurrencesOfString("href=\"",withString: "http://www.youporn.com").stringByReplacingOccurrencesOfString("\"", withString: "").stringByReplacingOccurrencesOfString("\">", withString: "")
                    var tempTitle = ""
                    var start = false
                    i++
                    while((splitted[i].rangeOfString("\">")) == nil)
                    {
                        i++
                        if(splitted[i].rangeOfString("title=\"") != nil){
                            start = true
                        }
                        if(start){
                            tempTitle += " " + splitted[i]
                        }
                    }
                    let title = tempTitle.stringByReplacingOccurrencesOfString(" title=\"", withString: "").stringByReplacingOccurrencesOfString("\">\n<img", withString: "")
                    let img = splitted[i+1].stringByReplacingOccurrencesOfString("src=\"", withString: "").stringByReplacingOccurrencesOfString("\"", withString: "")
                    let video = Video(link: link, imageLink: img, title: title)
                    self.videos.append(video)
                }
            }
            dispatch_async(dispatch_get_main_queue()){
                var i = 0;
                for video in self.videos{
                    self.chargeImageAsync(video.ImageLink,index :i, video: video)
                    i++;
                }
                
                
                self.nextButton(i)
                i++;
                if(actualPage > 1){
                    self.previousButton(i)
                }
            }
        }
        task.resume()
    }
    
    
    func nextButton(index: Int){
        let numImagePerRow = Int(bounds.width) / (Int(300) + 20)
        let width = CGFloat(300)
        let height =  CGFloat(169)
        let x = (index % numImagePerRow) * Int(width) + 20 * (index % numImagePerRow)
        let y = index / numImagePerRow * Int(height) + 20 * (index / numImagePerRow)
        let button = UIButton(type: UIButtonType.System)
        button.backgroundColor = UIColor.blackColor()
        button.frame =  CGRectMake(CGFloat(x), CGFloat(y), width, height)
        button.setTitle("Next Page", forState: .Normal)
        button.tag = index
        button.addTarget(self, action: "next:", forControlEvents: .PrimaryActionTriggered)
        button.clipsToBounds = true
        scroll.addSubview(button)
        scroll.contentSize = CGSize(width: bounds.width, height: CGFloat(x + 180))
        scroll.scrollEnabled = true
    }
    
    
    func previousButton(index: Int){
        let numImagePerRow = Int(bounds.width) / (Int(300) + 20)
        let width = CGFloat(300)
        let height =  CGFloat(169)
        let x = (index % numImagePerRow) * Int(width) + 20 * (index % numImagePerRow)
        let y = index / numImagePerRow * Int(height) + 20 * (index / numImagePerRow)
        let button = UIButton(type: UIButtonType.System)
        button.frame =  CGRectMake(CGFloat(x), CGFloat(y), width, height)
        button.setTitle("Previous Page", forState: .Normal)
        button.tag = index
        button.addTarget(self, action: "previous:", forControlEvents: .PrimaryActionTriggered)
        button.clipsToBounds = true
        scroll.addSubview(button)
//        scroll.clipsToBounds = true
    }
    
    func tapped(sender: UIButton) {
        let object = self.videos[sender.tag]
        self.performSegueWithIdentifier("Video", sender: object)
    }
    
    func next(sender: UIButton) {
        actualPage++
        self.showPage(actualPage)
    }
    
    
    func previous(sender: UIButton) {
        actualPage--
        self.showPage(actualPage)
    }
    
    
    override func prepareForSegue(segue: UIStoryboardSegue, sender: AnyObject!) {
        let video = sender as! Video
        if segue.identifier == "Video"{
            let vc = segue.destinationViewController as! VideoController
            vc.video = video
        }
    }
    
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }

    
    func createButton(image: UIImage, index: Int,video: Video){
        let numImagePerRow = Int(bounds.width) / (Int(image.size.width) + 20)
        
        let width = image.size.width
        let height = image.size.height
        let x = (index % numImagePerRow) * Int(width) + 20 * (index % numImagePerRow)
        let y = index / numImagePerRow * Int(height) + 20 * (index / numImagePerRow)
        let button = UIButton(type: UIButtonType.System)
         button.frame =  CGRectMake(CGFloat(x), CGFloat(y), width, height)
        button.setImage(image, forState: .Normal)
        button.setTitle(video.Title, forState: .Normal)
        button.imageView?.contentMode = UIViewContentMode.ScaleAspectFit
        button.tag = index
        button.addTarget(self, action: "tapped:", forControlEvents: .PrimaryActionTriggered)
        button.clipsToBounds = true
        scroll.addSubview(button)
//        scroll.clipsToBounds = true
        }
    
    
    func chargeImageAsync(image: String, index: Int, video: Video){
        let url = NSURL(string: image)
        let task = NSURLSession.sharedSession().dataTaskWithURL(url!) {(data, response, error) in
            let image = UIImage(data: data!)
             dispatch_async(dispatch_get_main_queue()){
            self.createButton(image!,index: index,video: video)
            }
        }
        task.resume()
    }


}

