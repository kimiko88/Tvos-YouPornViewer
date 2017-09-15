//
//  ViewController.swift
//  YoupornViewer
//
//  Created by kimiko88 on 04/10/15.
//  Copyright © 2015 kimiko88. All rights reserved.
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
    var bounds = UIScreen.main.bounds
    var scroll = UIScrollView()
    var field = UITextField()
    var isSearch: Bool = false
    var isSorted: Bool = false
    var selectedSort: String = "rating"
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.view = self.scroll;
        self.scroll.backgroundColor = UIColor.black
        showPage(actualPage)
        
    }
    
    
    
    func showPage(_ actualPage: Int){
        videos = [Video]()
        self.isSearch = false
        let subViews = self.scroll.subviews
        for subview in subViews{
            subview.removeFromSuperview()
        }
        let url = URL(string: "http://www.youporn.com/?page=\(actualPage)")
        
        let task = URLSession.shared.dataTask(with: url!, completionHandler: {(data, response, error) in
            let stringa = NSString(data: data!, encoding: String.Encoding.utf8.rawValue)!
            let strin = String(stringa)
            let splitted = strin.characters.split{$0 == " "}.map(String.init)
            
            var i = 0
            while i < splitted.count
            {
                let oo = splitted[i]
                if (oo.range(of: "href=\"/watch/") != nil && splitted[i + 1].range(of: "class='video-box-image'") != nil){
                    let link = oo.replacingOccurrences(of: "href=\"",with: "http://www.youporn.com").replacingOccurrences(of: "\"", with: "").replacingOccurrences(of: "\">", with: "")
                    var tempTitle = ""
                    var start = false
                    i += 1
                    while((splitted[i].range(of: "\n")) == nil)
                    {
                        i += 1
                        if(splitted[i].range(of: "title=\"") != nil){
                            start = true
                        }
                        if(start){
                            tempTitle += " " + splitted[i]
                        }
                    }
                    let title = tempTitle.replacingOccurrences(of: " title=\"", with: "").replacingOccurrences(of: "\">\n<img", with: "")
                    let img = splitted[i+1].replacingOccurrences(of: "src=\"", with: "").replacingOccurrences(of: "\"", with: "")
                        print(img)
                    let video = Video(link: link, imageLink: img, title: title)
                    self.videos.append(video)
                }
                i += 1
            }
            DispatchQueue.main.async{
                var i = 1;
                self.TextField(i)
                i += 3
                self.searchButton(i)
                i += 3
//                
//                self.sortButton(i,text: "relevance:")
//                i++
                self.sortButton(i,text: #selector(ViewController.views(_:)))
                 i += 1
                self.sortButton(i,text: #selector(ViewController.rating(_:)))
                 i += 1
                self.sortButton(i,text: #selector(ViewController.duration(_:)))
                 i += 1
                self.sortButton(i,text: #selector(ViewController.date(_:)))
                 i += 2
                for video in self.videos{
                    self.chargeImageAsync(video.ImageLink,index :i, video: video)
                    i += 1;
                }
                
                
                self.nextButton(i)
                i += 1;
                if(actualPage > 1){
                    self.previousButton(i)
                    i += 1
                }
                
                self.homeButton(i)
                i += 1
                
                self.scroll.contentSize = CGSize(width: self.bounds.width, height: CGFloat(self.calculatePosition(i).maxY + 180))
                self.scroll.isScrollEnabled = true
            }
        }) 
        task.resume()
    }
    
    func searchText(_ textToSearch: String){
        videos = [Video]()
        let subViews = self.scroll.subviews
        for subview in subViews{
            subview.removeFromSuperview()
        }
        self.isSearch = true
        self.selectedSort = "relevance"
        let url = URL(string: "http://www.youporn.com/search/?query=\(textToSearch.replacingOccurrences(of: " ", with: "+"))&page=\(actualPage)")
        
        let task = URLSession.shared.dataTask(with: url!, completionHandler: {(data, response, error) in
            let stringa = NSString(data: data!, encoding: String.Encoding.utf8.rawValue)!
            let strin = String(stringa)
            let splitted = strin.characters.split{$0 == " "}.map(String.init)
            
            var i = 0
            while i < splitted.count
            {
                let oo = splitted[i]
                if (oo.range(of: "href=\"/watch/") != nil && splitted[i + 1].range(of: "class='video-box-image'") != nil){
                    let link = oo.replacingOccurrences(of: "href=\"",with: "http://www.youporn.com").replacingOccurrences(of: "\"", with: "").replacingOccurrences(of: "\">", with: "")
                    var tempTitle = ""
                    var start = false
                    i += 1
                    while((splitted[i].range(of: "\n")) == nil)
                    {
                        i += 1
                        if(splitted[i].range(of: "title=\"") != nil){
                            start = true
                        }
                        if(start){
                            tempTitle += " " + splitted[i]
                        }
                    }
                    let title = tempTitle.replacingOccurrences(of: " title=\"", with: "").replacingOccurrences(of: "\">\n<img", with: "")
                    let img = splitted[i+1].replacingOccurrences(of: "src=\"", with: "").replacingOccurrences(of: "\"", with: "")
                    let video = Video(link: link, imageLink: img, title: title)
                    self.videos.append(video)
                }
                i+=1
            }
            DispatchQueue.main.async{
                var i = 1;
                self.TextField(i)
                i += 3
                self.searchButton(i)
                i += 3

                self.sortButton(i,text: #selector(ViewController.relevance(_:)))
                i += 1
                self.sortButton(i,text: #selector(ViewController.views(_:)))
                i += 1
                self.sortButton(i,text: #selector(ViewController.rating(_:)))
                i += 1
                self.sortButton(i,text: #selector(ViewController.duration(_:)))
                i += 1
                self.sortButton(i,text: #selector(ViewController.date(_:)))
                i += 1
                for video in self.videos{
                    self.chargeImageAsync(video.ImageLink,index :i, video: video)
                    i += 1;
                }
                
                self.nextButton(i)
                i += 1;
                if(self.actualPage > 1){
                    self.previousButton(i)
                    i += 1
                }
                self.homeButton(i)
                i += 1
                self.scroll.contentSize = CGSize(width: self.bounds.width, height: CGFloat(self.calculatePosition(i).maxY + 180))
                self.scroll.isScrollEnabled = true
            }
        }) 
        task.resume()
    }
    
    
    
    func SortByHome(_ howSort: String){
        videos = [Video]()
        let subViews = self.scroll.subviews
        for subview in subViews{
            subview.removeFromSuperview()
        }
        let url = URL(string: "http://www.youporn.com/browse/\(howSort)/?page=\(actualPage)")
        
        let task = URLSession.shared.dataTask(with: url!, completionHandler: {(data, response, error) in
            let stringa = NSString(data: data!, encoding: String.Encoding.utf8.rawValue)!
            let strin = String(stringa)
            let splitted = strin.characters.split{$0 == " "}.map(String.init)
            
            var i = 0
            while i < splitted.count
            {
                let oo = splitted[i]
                if (oo.range(of: "href=\"/watch/") != nil && splitted[i + 1].range(of: "class='video-box-image'") != nil){
                    let link = oo.replacingOccurrences(of: "href=\"",with: "http://www.youporn.com").replacingOccurrences(of: "\"", with: "").replacingOccurrences(of: "\">", with: "")
                    var tempTitle = ""
                    var start = false
                    i += 1
                    while((splitted[i].range(of: "\n")) == nil)
                    {
                        i += 1
                        if(splitted[i].range(of: "title=\"") != nil){
                            start = true
                        }
                        if(start){
                            tempTitle += " " + splitted[i]
                        }
                    }
                    let title = tempTitle.replacingOccurrences(of: " title=\"", with: "").replacingOccurrences(of: "\">\n<img", with: "")
                    let img = splitted[i+1].replacingOccurrences(of: "src=\"", with: "").replacingOccurrences(of: "\"", with: "")
                    let video = Video(link: link, imageLink: img, title: title)
                    self.videos.append(video)
                }
                i+=1
            }
            DispatchQueue.main.async{
                var i = 1;
                self.TextField(i)
                i += 3
                self.searchButton(i)
                i += 3
                
                self.sortButton(i,text: #selector(ViewController.views(_:)))
                i += 1
                self.sortButton(i,text: #selector(ViewController.rating(_:)))
                i += 1
                self.sortButton(i,text: #selector(ViewController.duration(_:)))
                i += 1
                self.sortButton(i,text: #selector(ViewController.date(_:)))
                i += 2
                for video in self.videos{
                    self.chargeImageAsync(video.ImageLink,index :i, video: video)
                    i += 1;
                }
                
                self.nextButton(i)
                i += 1;
                if(self.actualPage > 1){
                    self.previousButton(i)
                    i += 1
                }
                self.homeButton(i)
                i += 1
                self.scroll.contentSize = CGSize(width: self.bounds.width, height: CGFloat(self.calculatePosition(i).maxY + 180))
                self.scroll.isScrollEnabled = true
            }
        }) 
        task.resume()
    }
    
 
    
    func SortBySearch(_ howSort: String,textToSearch: String){
        videos = [Video]()
         self.isSearch = true
        let subViews = self.scroll.subviews
        for subview in subViews{
            subview.removeFromSuperview()
        }
        let url = URL(string: "http://www.youporn.com/search/\(howSort)/?query=\(textToSearch.replacingOccurrences(of: " ", with: "+"))&page=\(actualPage)")
        
        let task = URLSession.shared.dataTask(with: url!, completionHandler: {(data, response, error) in
            let stringa = NSString(data: data!, encoding: String.Encoding.utf8.rawValue)!
            let strin = String(stringa)
            let splitted = strin.characters.split{$0 == " "}.map(String.init)
            
            var i = 0
            while i < splitted.count
            {
                let oo = splitted[i]
                if (oo.range(of: "href=\"/watch/") != nil && splitted[i + 1].range(of: "class='video-box-image'") != nil){
                    let link = oo.replacingOccurrences(of: "href=\"",with: "http://www.youporn.com").replacingOccurrences(of: "\"", with: "").replacingOccurrences(of: "\">", with: "")
                    var tempTitle = ""
                    var start = false
                    i += 1
                    while((splitted[i].range(of: "\n")) == nil)
                    {
                        i += 1
                        if(splitted[i].range(of: "title=\"") != nil){
                            start = true
                        }
                        if(start){
                            tempTitle += " " + splitted[i]
                        }
                    }
                    let title = tempTitle.replacingOccurrences(of: " title=\"", with: "").replacingOccurrences(of: "\">\n<img", with: "")
                    let img = splitted[i+1].replacingOccurrences(of: "src=\"", with: "").replacingOccurrences(of: "\"", with: "")
                    let video = Video(link: link, imageLink: img, title: title)
                    self.videos.append(video)
                }
                i+=1
            }
            DispatchQueue.main.async{
                var i = 1;
                self.TextField(i)
                i += 3
                self.searchButton(i)
                i += 3
                self.sortButton(i,text: #selector(ViewController.relevance(_:)))
                i += 1
                self.sortButton(i,text: #selector(ViewController.views(_:)))
                i += 1
                self.sortButton(i,text: #selector(ViewController.rating(_:)))
                i += 1
                self.sortButton(i,text: #selector(ViewController.duration(_:)))
                i += 1
                self.sortButton(i,text: #selector(ViewController.date(_:)))
                i += 1
                for video in self.videos{
                    self.chargeImageAsync(video.ImageLink,index :i, video: video)
                    i += 1;
                }
                
                self.nextButton(i)
                i += 1;
                if(self.actualPage > 1){
                    self.previousButton(i)
                    i += 1
                }
                self.homeButton(i)
                i += 1
                self.scroll.contentSize = CGSize(width: self.bounds.width, height: CGFloat(self.calculatePosition(i).maxY + 180))
                self.scroll.isScrollEnabled = true
            }
        }) 
        task.resume()
    }

    
    
    
    func TextField(_ index: Int)
    {
        field.frame =  calculatePositionLarger(index)
        field.backgroundColor = UIColor.white
        scroll.addSubview(field)
        
    }
    
    func searchButton(_ index: Int){
        let button = UIButton(type: UIButtonType.system)
        button.backgroundColor = UIColor.black
        button.frame =  calculatePosition(index)
        button.setTitle("Search", for: UIControlState())
        //        button.tag = index + 1)
        button.addTarget(self, action: #selector(ViewController.search(_:)), for: .primaryActionTriggered)
        button.clipsToBounds = true
        scroll.addSubview(button)
    }
    
    
    func homeButton(_ index: Int){
        let button = UIButton(type: UIButtonType.system)
        button.backgroundColor = UIColor.black
        button.frame =  calculatePosition(index)
        button.setTitle("Home", for: UIControlState())
        //        button.tag = index + 1)
        button.addTarget(self, action: #selector(ViewController.home(_:)), for: .primaryActionTriggered)
        button.clipsToBounds = true
        scroll.addSubview(button)
    }
    
    
    func sortButton(_ index: Int,text: Selector){
        let button = UIButton(type: UIButtonType.system)
        let title = text.description.replacingOccurrences(of: ":", with: "")
        if(selectedSort == title)
        {
            button.backgroundColor = UIColor.gray
        }else{
        button.backgroundColor = UIColor.black
        }
        button.frame =  calculatePosition(index)
        button.setTitle(title,for: UIControlState())
            //        button.tag = index + 1)
        button.addTarget(self, action: text, for: .primaryActionTriggered)
        
        button.clipsToBounds = true
        scroll.addSubview(button)
    }
    
    func views(_ sender: UIButton){
        self.actualPage = 1
        selectedSort = "views"
        if(!isSearch)
        {
        self.SortByHome("views")
        }else{
          self.SortBySearch("views", textToSearch: field.text!)
        }
    }
    
    func rating(_ sender: UIButton){
        self.actualPage = 1
        selectedSort = "rating"
        if(!isSearch)
        {
            self.SortByHome("rating")
        }else{
            self.SortBySearch("rating", textToSearch: field.text!)
        }
    }
    
    func duration(_ sender: UIButton){
        self.actualPage = 1
        selectedSort = "duration"
        if(!isSearch)
        {
            self.SortByHome("duration")
        }else{
            self.SortBySearch("duration", textToSearch: field.text!)
        }
    }
    
    func date(_ sender: UIButton){
        self.actualPage = 1
        selectedSort = "date"
        if(!isSearch)
        {
            self.SortByHome("time")
        }else{
            self.SortBySearch("time", textToSearch: field.text!)
        }
    }
    
    func relevance(_ sender: UIButton){
        self.actualPage = 1
        selectedSort = "relevance"
        self.SortBySearch("relevance", textToSearch: field.text!)
    }
    
    
    func nextButton(_ index: Int){
        let button = UIButton(type: UIButtonType.system)
        button.backgroundColor = UIColor.black
        button.frame =  calculatePosition(index)
        button.setTitle("Next Page", for: UIControlState())
        button.tag = index
        button.addTarget(self, action: #selector(ViewController.next(_:)), for: .primaryActionTriggered)
        button.clipsToBounds = true
        scroll.addSubview(button)
        
        //        scroll.contentSize = CGSize(width: bounds.width, height: CGFloat(y + 180))
        //        scroll.scrollEnabled = true
    }
    
    
    func previousButton(_ index: Int){
        let button = UIButton(type: UIButtonType.system)
        button.frame =  calculatePosition(index)
        button.setTitle("Previous Page", for: UIControlState())
        button.tag = index
        button.addTarget(self, action: #selector(ViewController.previous(_:)), for: .primaryActionTriggered)
        button.clipsToBounds = true
        scroll.addSubview(button)
        //        scroll.clipsToBounds = true
    }
    
    func tapped(_ sender: UIButton) {
        let object = self.videos[sender.tag]
        self.performSegue(withIdentifier: "Video", sender: object)
    }
    
    func next(_ sender: UIButton) {
        actualPage += 1
        //TODO ADD SORT PAGINATION
        if(!isSearch){
            if(!isSorted)
            {
            self.showPage(actualPage)
            }else
            {
                self.SortByHome(selectedSort)
            }
        }
        else{
            if(!isSorted){
            self.searchText(field.text!)
            }else{
                self.SortBySearch(selectedSort, textToSearch: field.text!)
            }
        }
    }
    
    
    func previous(_ sender: UIButton) {
        actualPage -= 1
        if(!isSearch){
            if(!isSorted)
            {
                self.showPage(actualPage)
            }else
            {
                self.SortByHome(selectedSort)
            }
        }
        else{
            if(!isSorted){
                self.searchText(field.text!)
            }else{
                self.SortBySearch(selectedSort, textToSearch: field.text!)
            }
        }
    }
    
    func home(_ sender: UIButton){
        self.actualPage = 1
        self.showPage(actualPage)
    }
    
    
    func search(_ sender: UIButton){
        self.actualPage = 1
        self.searchText(field.text!)
    }
    
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any!) {
        let video = sender as! Video
        if segue.identifier == "Video"{
            let vc = segue.destination as! VideoController
            vc.video = video
        }
    }
    
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    
    func calculatePosition(_ index: Int) -> CGRect
    {
        let numImagePerRow = Int(bounds.width) / (Int(300) + 20)
        let width = CGFloat(300)
        let height =  CGFloat(169)
        let x = ((index) % numImagePerRow) * Int(width) + 20 * ((index) % numImagePerRow + 1)
        let y = (index) / numImagePerRow * Int(height) + 20 * ((index) / numImagePerRow + 1)
        return CGRect(x: CGFloat(x), y: CGFloat(y), width: width, height: height)
    }
    
    func calculatePositionLarger(_ index: Int) -> CGRect
    {
        let numImagePerRow = Int(bounds.width) / (Int(300) + 20)
        let width = CGFloat(600)
        let height =  CGFloat(169)
        let x = ((index) % numImagePerRow) * Int(width) + 20 * ((index) % numImagePerRow + 1)
        let y = (index) / numImagePerRow * Int(height) + 20 * ((index) / numImagePerRow + 1)
        return CGRect(x: CGFloat(x), y: CGFloat(y), width: width, height: height)
    }
    
    func calculatePosition(_ index: Int, image: UIImage) -> CGRect
    {
        let numImagePerRow = Int(bounds.width) / (Int(image.size.width) + 20)
        let width = image.size.width
        let height = image.size.height
        let x = (index % numImagePerRow) * Int(width) + 20 * (index % numImagePerRow + 1)
        let y = index / numImagePerRow * Int(height) + 20 * (index / numImagePerRow + 1)
        return CGRect(x: CGFloat(x), y: CGFloat(y), width: width, height: height)
    }
    
    func createButton(_ image: UIImage, index: Int,video: Video){
        let button = UIButton(type: UIButtonType.system)
        button.contentVerticalAlignment = UIControlContentVerticalAlignment.bottom
        button.titleLabel?.lineBreakMode = .byTruncatingTail
        button.titleLabel?.backgroundColor = UIColor.black
        button.setTitleColor(UIColor(red: 236.0/255.0, green: 86.0/255.0, blue: 124.0/255.0, alpha: 1.0), for: UIControlState())
        button.titleLabel?.font = UIFont(name: "Times New Roman", size: 25)
        button.setTitle(String(htmlEncodedString: video.Title), for: UIControlState())
        button.titleLabel?.text = video.Title
        button.imageView?.contentMode = UIViewContentMode.scaleAspectFit
        button.frame =  calculatePosition(index, image: image)
        button.setBackgroundImage(image, for: UIControlState())
        button.tag = index - 12
        button.addTarget(self, action: #selector(ViewController.tapped(_:)), for: .primaryActionTriggered)
        button.clipsToBounds = true
        scroll.addSubview(button)
        scroll.clipsToBounds = true
    }
    
    func chargeImageAsync(_ image: String, index: Int, video: Video){
        let url = URL(string: image)
        if((url == nil || (url?.hashValue) == nil)){
            let image = UIImage(named: "ImageNotfound.png")
            DispatchQueue.main.async{
                self.createButton(image!,index: index,video: video)
            }
        }else{
            let task = URLSession.shared.dataTask(with: url!, completionHandler: {(data, response, error) in
                let image = UIImage(data: data!)
                DispatchQueue.main.async{
                    self.createButton(image!,index: index,video: video)
                    }
            }) 
            task.resume()
        }
    }
    
    
}

