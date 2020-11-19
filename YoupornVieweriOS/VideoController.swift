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
        
        let url = NSURL(string: self.video.Link)
        let task = URLSession.shared.dataTask(with: url! as URL) {(data, response, error) in
            let stringa = NSString(data: data!, encoding: String.Encoding.utf8.rawValue)!
            let strin = String(stringa)
            let splitted = strin.split{$0 == " "}.map(String.init)
            for var i in 0..<splitted.count
            {
                let oo = splitted[i]
                
                if (oo.contains("downloadOption")){
                    var tempLink = ""
                    var tempTitle = ""
                    var start = false
                    i+=1
                    while(!splitted[i].contains("/a>"))
                    {
                        i+=1
                        if(splitted[i].contains("href=")){
                            tempLink = splitted[i]
                        }
                        
                        if(splitted[i].contains("\'>") && tempLink.count > 2){
                            start = true
                        }
                        if(start)
                        {
                            tempTitle += " " + splitted[i]
                        }
                        
                    }
                    let link = tempLink.replacingOccurrences(of: "href='", with: "")
                    let title = tempTitle.replacingOccurrences(of:" Video'>", with: "").replacingOccurrences(of: "</a>\n<span", with: "")
                    self.downloadLinks.append(DownloadLink(link: link, title: title))
                }
            }
            
            
            DispatchQueue.main.async(execute: {
                var i = 0
                
                for downloadLink in self.downloadLinks{
                   if(!downloadLink.Title.contains("3GP"))//AVPlayer for tvos can't play 3GP file
                   {
                    self.createButton(download: downloadLink,index: i)
                         i+=1
                    }
               
                }
                self.createHomeButton(index: i)
            })
        }
        task.resume()
        self.view.backgroundColor = UIColor.black
    }
    
    
    func tapped(sender: UIButton) {
        let object = self.downloadLinks[sender.tag]
        
        self.performSegue(withIdentifier: "SeeVideo", sender: object)
    }
    
    func home(sender: UIButton) {
        
        self.performSegue(withIdentifier: "BackHome", sender: nil)
    }
    
    
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if segue.identifier == "BackHome"{
            _ = segue.destination as! ViewController
        }else{
        let video = sender as! DownloadLink
        if segue.identifier == "SeeVideo"{
            let vc = segue.destination as! AVVideoPlayerController
            vc.downloadVideo = video
        }
        }
    }
    
    func createButton(download: DownloadLink, index: Int){
        let numImagePerRow = Int(bounds.width) / (Int(300) + 20)
        let width = CGFloat(300)
        let height = CGFloat(50)
        let x = (index % numImagePerRow) * Int(width) + 20 * (index % numImagePerRow)
        let y = index / numImagePerRow * Int(height) + 20 * (index / numImagePerRow)
        let button = UIButton(type: UIButton.ButtonType.system)
        button.frame =  CGRect(x: CGFloat(x), y: CGFloat(y), width: width, height: height)
        button.setTitle(download.Title,for: UIControl.State.normal)
        button.tag = index
        button.addTarget(self, action: Selector(("tapped:")), for: .primaryActionTriggered)
        button.clipsToBounds = true
        self.view.addSubview(button)
        self.view.clipsToBounds = true
    }
    
    func createHomeButton(index: Int){
        let numImagePerRow = Int(bounds.width) / (Int(300) + 20)
        let width = CGFloat(300)
        let height = CGFloat(50)
        let x = (index % numImagePerRow) * Int(width) + 20 * (index % numImagePerRow)
        let y = index / numImagePerRow * Int(height) + 20 * (index / numImagePerRow)
        let button = UIButton(type: UIButton.ButtonType.system)
        button.frame =  CGRect(x: CGFloat(x), y: CGFloat(y), width: width, height: height)
        button.setTitle("Home",for: UIControl.State.normal)
        button.tag = index
        button.addTarget(self, action: Selector(("home:")), for: .primaryActionTriggered)
        button.clipsToBounds = true
        self.view.addSubview(button)
        self.view.clipsToBounds = true
    }
    
    
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
    }
    
}


