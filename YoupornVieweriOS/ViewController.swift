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
    var images = [UIImage]()
    var isSearch: Bool = false
    var isSorted: Bool = false
    var selectedSort: String = "rating"
    
    override func viewDidLoad() {
        NotificationCenter.default.addObserver(self, selector: #selector(rotated), name: UIDevice.orientationDidChangeNotification, object: nil)
        super.viewDidLoad()
        self.view = self.scroll;
        self.scroll.backgroundColor = UIColor.black
        showPage(actualPage: actualPage)
        
    }
    
    @objc func rotated()
    {
        if(UIDevice.current.orientation.isValidInterfaceOrientation)
        {
            let subViews = self.scroll.subviews
            for subview in subViews{
                subview.removeFromSuperview()
            }
            bounds = UIScreen.main.bounds
            self.createButton()
        }
        
    }
    
    
    func showPage(actualPage: Int){
        videos = [Video]()
           self.isSearch = false
        let subViews = self.scroll.subviews
        for subview in subViews{
            subview.removeFromSuperview()
        }
        let url = NSURL(string: "http://www.youporn.com/?page=\(actualPage)")
        
        let task = URLSession.shared.dataTask(with: url! as URL) {(data, response, error) in
            let stringa = NSString(data: data!, encoding: String.Encoding.utf8.rawValue)!
            let strin = String(stringa)
            let splitted = strin.split{$0 == " "}.map(String.init)
            
            for var i in 0..<splitted.count
            {
                let oo = splitted[i]
                if (oo.contains("href=\"/watch/") && splitted[i + 1].contains("class='video-box-image'")){
                    let link = oo.replacingOccurrences(of: "href=\"",with: "http://www.youporn.com").replacingOccurrences(of: "\"", with: "").replacingOccurrences(of:"\">", with: "")
                    var tempTitle = ""
                    var start = false
                    i+=1
                    while(!splitted[i].contains("\n"))
                    {
                        i+=1
                        if(splitted[i].contains("title=\"")){
                            start = true
                        }
                        if(start){
                            tempTitle += " " + splitted[i]
                        }
                    }
                    let title = tempTitle.replacingOccurrences(of:" title=\"", with: "").replacingOccurrences(of:"\">\n<img", with: "")
                    let img = splitted[i+1].replacingOccurrences(of: "src=\"", with: "").replacingOccurrences(of: "\"", with: "")
                    let video = Video(link: link, imageLink: img, title: title)
                    self.videos.append(video)
                }
            }
                  self.createButton()
        }
        task.resume()
    }
    
    func searchText(textToSearch: String){
        videos = [Video]()
        let subViews = self.scroll.subviews
        for subview in subViews{
            subview.removeFromSuperview()
        }
        self.isSearch = true
        self.selectedSort = "relevance"
        let url = NSURL(string: "http://www.youporn.com/search/?query=\(textToSearch.replacingOccurrences(of: " ", with: "+"))&page=\(actualPage)")
        
        let task = URLSession.shared.dataTask(with: url! as URL) {(data, response, error) in
            let stringa = NSString(data: data!, encoding: String.Encoding.utf8.rawValue)!
            let strin = String(stringa)
            let splitted = strin.split{$0 == " "}.map(String.init)
            
            for var i in 0..<splitted.count
            {
                let oo = splitted[i]
                if (oo.contains("href=\"/watch/") && splitted[i + 1].contains("class='video-box-image'")){
                    let link = oo.replacingOccurrences(of: "href=\"",with: "http://www.youporn.com").replacingOccurrences(of: "\"", with: "").replacingOccurrences(of: "\">", with: "")
                    var tempTitle = ""
                    var start = false
                    i+=1
                    while(!splitted[i].contains("\n"))
                    {
                        i+=1
                        if(splitted[i].contains("title=\"")){
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
            }
               self.createButton()
        }
        task.resume()
    }
    
    
    
    func SortByHome(howSort: String){
        videos = [Video]()
        let subViews = self.scroll.subviews
        for subview in subViews{
            subview.removeFromSuperview()
        }
        let url = NSURL(string: "http://www.youporn.com/browse/\(howSort)/?page=\(actualPage)")
        
        let task = URLSession.shared.dataTask(with: url! as URL) {(data, response, error) in
            let stringa = NSString(data: data!, encoding: String.Encoding.utf8.rawValue)!
            let strin = String(stringa)
            let splitted = strin.split{$0 == " "}.map(String.init)
            
            for var i in 0..<splitted.count
            {
                let oo = splitted[i]
                if (oo.contains("href=\"/watch/") && splitted[i + 1].contains("class='video-box-image'")){
                    let link = oo.replacingOccurrences(of: "href=\"",with: "http://www.youporn.com").replacingOccurrences(of: "\"", with: "").replacingOccurrences(of: "\">", with: "")
                    var tempTitle = ""
                    var start = false
                    i+=1
                    while(!splitted[i].contains("\n"))
                    {
                        i+=1
                        if(splitted[i].contains("title=\"")){
                            start = true
                        }
                        if(start){
                            tempTitle += " " + splitted[i]
                        }
                    }
                    let title = tempTitle.replacingOccurrences(of: " title=\"", with: "").replacingOccurrences(of: "\">\n<img", with: "")
                    let img = splitted[i+1].replacingOccurrences(of:"src=\"", with: "").replacingOccurrences(of:"\"", with: "")
                    let video = Video(link: link, imageLink: img, title: title)
                    self.videos.append(video)
                }
            }
                  self.createButton()
        }
        task.resume()
    }
    
    
    
    func SortBySearch(howSort: String,textToSearch: String){
        videos = [Video]()
        self.isSearch = true
        let subViews = self.scroll.subviews
        for subview in subViews{
            subview.removeFromSuperview()
        }
        let url = NSURL(string: "http://www.youporn.com/search/\(howSort)/?query=\(textToSearch.replacingOccurrences(of:" ", with: "+"))&page=\(actualPage)")
        
        let task = URLSession.shared.dataTask(with: url! as URL) {(data, response, error) in
            let stringa = NSString(data: data!, encoding: String.Encoding.utf8.rawValue)!
            let strin = String(stringa)
            let splitted = strin.split{$0 == " "}.map(String.init)
            
            for var i in 0..<splitted.count
            {
                let oo = splitted[i]
                if (oo.contains("href=\"/watch/") && splitted[i + 1].contains("class='video-box-image'")){
                    let link = oo.replacingOccurrences(of: "href=\"",with: "http://www.youporn.com").replacingOccurrences(of: "\"", with: "").replacingOccurrences(of: "\">", with: "")
                    var tempTitle = ""
                    var start = false
                    i+=1
                    while(!splitted[i].contains("\n"))
                    {
                        i+=1
                        if(splitted[i].contains("title=\"")){
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
            }
                 self.createButton()
        }
        task.resume()
    }
    


    func createButton(){
        DispatchQueue.main.async(execute: {
            var i = 0;
            self.TextField(index: i)
            i+=1
            self.searchButton(index: i)
            i+=1
            if(self.isSearch){
                self.sortButton(index: i,text: #selector(self.relevance))
                i+=1
            }
            self.sortButton(index: i,text: #selector(self.views))
            i+=1
            self.sortButton(index: i,text: #selector(self.rating))
            i+=1
            self.sortButton(index: i,text: #selector(self.duration))
            i+=1
            self.sortButton(index: i,text: #selector(self.date))
            i+=1
            for video in self.videos{
                self.chargeImageAsync(image: video.ImageLink,index :i, video: video)
                i+=1
            }
            
            
            self.nextButton(index: i)
            i+=1
            if(self.actualPage > 1){
                self.previousButton(index: i)
                i+=1
            }
            
            self.homeButton(index: i)
            i+=1
            
            self.scroll.contentSize = CGSize(width: self.bounds.width, height: CGFloat(self.calculatePosition(index: i).maxY + 50))
            self.scroll.isScrollEnabled = true
        })
    }
    
    
    func TextField(index: Int)
    {
        field.frame =  calculatePosition(index: index)
        field.backgroundColor = UIColor.white
        scroll.addSubview(field)
        
    }
    
    
    func sortButton(index: Int,text: Selector){
        let button = UIButton(type: UIButton.ButtonType.system)
        let title = text.description.replacingOccurrences(of: "WithSender:", with: "")
        if(selectedSort == title)
        {
            button.backgroundColor = UIColor.white
        }else{
            button.backgroundColor = UIColor.black
        }
        button.frame =  calculatePosition(index: index)
        button.setTitle(title,for: UIControl.State.normal)
        //        button.tag = index + 1)
        button.addTarget(self, action: text, for: .primaryActionTriggered)
        
        button.clipsToBounds = true
        scroll.addSubview(button)
    }
    
    @objc func views(sender: UIButton){
        self.actualPage = 1
        selectedSort = "views"
        if(!isSearch)
        {
            self.SortByHome(howSort: "views")
        }else{
            self.SortBySearch(howSort: "views", textToSearch: field.text!)
        }
    }
    
    @objc func rating(sender: UIButton){
        self.actualPage = 1
        selectedSort = "rating"
        if(!isSearch)
        {
            self.SortByHome(howSort: "rating")
        }else{
            self.SortBySearch(howSort: "rating", textToSearch: field.text!)
        }
    }
    
    @objc func duration(sender: UIButton){
        self.actualPage = 1
        selectedSort = "duration"
        if(!isSearch)
        {
            self.SortByHome(howSort: "duration")
        }else{
            self.SortBySearch(howSort: "duration", textToSearch: field.text!)
        }
    }
    
    @objc func date(sender: UIButton){
        self.actualPage = 1
        selectedSort = "date"
        if(!isSearch)
        {
            self.SortByHome(howSort: "time")
        }else{
            self.SortBySearch(howSort: "time", textToSearch: field.text!)
        }
    }
    
    @objc func relevance(sender: UIButton){
        self.actualPage = 1
        selectedSort = "relevance"
        self.SortBySearch(howSort: "relevance", textToSearch: field.text!)
    }
    

    
    func searchButton(index: Int){
        let button = UIButton(type: UIButton.ButtonType.system)
        button.backgroundColor = UIColor.black
        button.frame =  calculatePosition(index: index)
        button.setTitle("Search", for: UIControl.State.normal)
        //        button.tag = index + 1)
        button.addTarget(self, action: Selector(("search:")), for: .primaryActionTriggered)
        button.clipsToBounds = true
        scroll.addSubview(button)
    }
    
    
    func homeButton(index: Int){
        let button = UIButton(type: UIButton.ButtonType.system)
        button.backgroundColor = UIColor.black
        button.frame =  calculatePosition(index: index)
        button.setTitle("Home", for: UIControl.State.normal)
        //        button.tag = index + 1)
        button.addTarget(self, action: Selector(("home:")), for: .primaryActionTriggered)
        button.clipsToBounds = true
        scroll.addSubview(button)
    }
    
    
    
    
    func nextButton(index: Int){
        let button = UIButton(type: UIButton.ButtonType.system)
        button.backgroundColor = UIColor.black
        button.frame =  calculatePosition(index: index)
        button.setTitle("Next Page", for: UIControl.State.normal)
        button.tag = index
        button.addTarget(self, action: Selector(("next:")), for: .primaryActionTriggered)
        button.clipsToBounds = true
        scroll.addSubview(button)
        
        //        scroll.contentSize = CGSize(width: bounds.width, height: CGFloat(y + 180))
        //        scroll.scrollEnabled = true
    }
    
    
    func previousButton(index: Int){
        let button = UIButton(type: UIButton.ButtonType.system)
        button.frame =  calculatePosition(index: index)
        button.setTitle("Previous Page", for: UIControl.State.normal)
        button.tag = index
        button.addTarget(self, action: Selector(("previous:")), for: .primaryActionTriggered)
        button.clipsToBounds = true
        scroll.addSubview(button)
        //        scroll.clipsToBounds = true
    }
    
    func tapped(sender: UIButton) {
        let object = self.videos[sender.tag]
        self.performSegue(withIdentifier: "Video", sender: object)
    }
    
    func next(sender: UIButton) {
        actualPage+=1
        //TODO ADD SORT PAGINATION
        if(!isSearch){
            if(!isSorted)
            {
                self.showPage(actualPage: actualPage)
            }else
            {
                self.SortByHome(howSort: selectedSort)
            }
        }
        else{
            if(!isSorted){
                self.searchText(textToSearch: field.text!)
            }else{
                self.SortBySearch(howSort: selectedSort, textToSearch: field.text!)
            }
        }
    }
    
    
    func previous(sender: UIButton) {
        actualPage-=1
        if(!isSearch){
            if(!isSorted)
            {
                self.showPage(actualPage: actualPage)
            }else
            {
                self.SortByHome(howSort: selectedSort)
            }
        }
        else{
            if(!isSorted){
                self.searchText(textToSearch: field.text!)
            }else{
                self.SortBySearch(howSort: selectedSort, textToSearch: field.text!)
            }
        }
    }

    
    func home(sender: UIButton){
        self.actualPage = 1
        self.showPage(actualPage: actualPage)
    }
    
    
    func search(sender: UIButton){
        self.searchText(textToSearch: field.text!)
        self.actualPage = 1
    }
    
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
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
    
    
    func calculatePosition(index: Int) -> CGRect
    {
        let width = CGFloat(300)/2 - 15
        let height =  CGFloat(169)/2 - 15
        let numImagePerRow = Int(bounds.width) / (Int(width) + 20)
        let x = ((index) % numImagePerRow) * Int(width) + 20 * ((index) % numImagePerRow + 1)
        let y = (index) / numImagePerRow * Int(height) + 20 * ((index) / numImagePerRow + 1)
        return CGRect(x: CGFloat(x), y: CGFloat(y), width: width, height: height)
    }
    
    
    func calculatePosition(index: Int, image: UIImage) -> CGRect
    {
        let width = image.size.width/2 - 15.0
        let height = image.size.height/2 - 15.0
        let numImagePerRow = Int(bounds.width) / (Int(width) + 20)
        let x = (index % numImagePerRow) * Int(width) + 20 * (index % numImagePerRow + 1)
        let y = index / numImagePerRow * Int(height) + 20 * (index / numImagePerRow + 1)
        return CGRect(x: CGFloat(x), y: CGFloat(y), width: width, height: height)
    }
    
    func createButton(image: UIImage, index: Int,video: Video){
        let button = UIButton(type: UIButton.ButtonType.system)
        button.contentVerticalAlignment = UIControl.ContentVerticalAlignment.bottom
        button.titleLabel?.lineBreakMode = .byTruncatingTail
        button.titleLabel?.backgroundColor = UIColor.black
        button.frame =  calculatePosition(index: index, image: image)
        button.setBackgroundImage(image, for: UIControl.State.normal)
        button.setTitle(String(htmlEncodedString: video.Title), for: UIControl.State.normal)
        button.imageView?.contentMode = UIView.ContentMode.scaleAspectFit
        button.setTitleColor(UIColor(red: 236.0/255.0, green: 86.0/255.0, blue: 124.0/255.0, alpha: 1.0), for: UIControl.State.normal)
        button.titleLabel?.font = UIFont(name: "Times New Roman", size: 10)
        if(!isSearch)
        {
        button.tag = index - 6
        }else{
                   button.tag = index - 7
        }
        button.addTarget(self, action: Selector(("tapped:")), for: .primaryActionTriggered)
        button.clipsToBounds = true
        scroll.addSubview(button)
        //        scroll.clipsToBounds = true
    }
    
    
    func chargeImageAsync(image: String, index: Int, video: Video){
        let url = NSURL(string: image)
        if((url == nil || (url?.hashValue) == nil)){
            let image = UIImage(named: "ImageNotfound1.png")
           DispatchQueue.main.async(execute: {
            self.createButton(image: image!,index: index,video: video)
            })
        }else{
            let task = URLSession.shared.dataTask(with: (url as URL?)!) {(data, response, error) in
                let image = UIImage(data: data!)
                DispatchQueue.main.async(execute: {
                    self.createButton(image: image!,index: index,video: video)
                })
            }
            task.resume()
        }
        
    }
    
    
}

