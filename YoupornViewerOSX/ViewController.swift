//
//  ViewController.swift
//  YoupornViewerOSX
//
//  Created by kimiko88 on 12/11/15.
//  Copyright © 2015 kimiko88. All rights reserved.
//

import Cocoa



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


class ViewController: NSViewController {
    var videos = [Video]()
    var actualPage = 1;
    var bounds: NSRect! = NSRect(x: 0, y: 0, width: 700, height: 800)//NSScreen.screens()?.first?.visibleFrame//UIScreen.mainScreen().bounds
//    var scroll = NSScrollView()
    var field =  NSTextField()
    var images = [NSImage]()
    var isSearch: Bool = false
    
//    var window: NSWindow!
    @IBOutlet weak var scroll: NSScrollView!
    @IBOutlet weak var vista: NSView!
//    @IBOutlet weak var windows: NSWindow!
    
    override func viewDidLoad() {
//        NSNotificationCenter.defaultCenter().addObserver(self, selector: "rotated", name: UIDeviceOrientationDidChangeNotification, object: nil)
        super.viewDidLoad()
//        self.view = self.scroll;
//        let windowController = NSStoryboard(name: "Main", bundle: NSBundle.mainBundle()).instantiateControllerWithIdentifier("prova") as! NSWindowController
//        window = windowController.window
//        vista.setFrameSize(NSSize(width: 700, height: 800))
        self.scroll.backgroundColor = NSColor.blackColor()
        showPage(actualPage)
//        windows.contentView?.addSubview(self.scroll)
//         self.window.contentView?.addSubview(self.scroll)
    }
    
//    func rotated()
//    {
//        if(UIDeviceOrientationIsValidInterfaceOrientation(UIDevice.currentDevice().orientation))
//        {
//            let subViews = self.scroll.subviews
//            for subview in subViews{
//                subview.removeFromSuperview()
//            }
//            bounds = UIScreen.mainScreen().bounds
//            self.createButton()
//        }
//        
//    }
    

    
    func showPage(actualPage: Int){
        videos = [Video]()
     //   let subViews = self.scroll.subviews
//        for subview in subViews{
//            subview.removeFromSuperview()
//        }
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
                    while((splitted[i].rangeOfString("\n")) == nil)
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
            self.createButton()
        }
        task.resume()
    }
    
    func createButton(){
        dispatch_async(dispatch_get_main_queue()){
            var i = 0;
            self.TextField(i)
            i++
            self.searchButton(i)
            i++
            for video in self.videos{
                self.chargeImageAsync(video.ImageLink,index :i, video: video)
                i++;
            }
            
            
            self.nextButton(i)
            i++;
            if(self.actualPage > 1){
                self.previousButton(i)
                i++
            }
            
            self.homeButton(i)
            i++
            
        self.scroll.contentView.setFrameSize(NSSize(width: self.bounds!.width, height: CGFloat(self.calculatePosition(i).maxY + 50)))
            //print(self.scroll.hasVerticalScroller)
//            var scroller = NSScroller()
//            scroller.controlTint = NSControlTint.BlueControlTint
//            self.scroll.horizontalScroller = scroller
             //print(self.scroll.hasHorizontalScroller)
//            self.scroll.documentView!.setFrame(NSRect(x: 0, y: 0, width: self.bounds!.width, height: CGFloat(self.calculatePosition(i).maxY + 50)), display: true)
        }
    }
    
    func searchText(textToSearch: String){
        videos = [Video]()
        let subViews = self.scroll.subviews
        for subview in subViews{
            subview.removeFromSuperview()
        }
        let search = textToSearch.stringByReplacingOccurrencesOfString(" ", withString: "+")
        let url = NSURL(string: "http://www.youporn.com/search/?query=\(search)&page=\(actualPage)")
        
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
                    while((splitted[i].rangeOfString("\n")) == nil)
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
            self.createButton()
        }
        task.resume()
    }
    
    
    
    func TextField(index: Int)
    {
        field.frame =  calculatePosition(index)
        field.backgroundColor = NSColor.whiteColor()
        scroll.addSubview(field)
        
    }
    
    func searchButton(index: Int){
        let button = NSButton()
        (button.cell as! NSButtonCell).backgroundColor = NSColor.blackColor()
        button.frame =  calculatePosition(index)
        button.title = "Search"
        //        button.tag = index + 1)
        button.target = self
        button.action = "search:"
        scroll.addSubview(button)
    }
    
    
    func homeButton(index: Int){
        let button = NSButton()
        (button.cell as! NSButtonCell).backgroundColor = NSColor.blackColor()
        button.frame =  calculatePosition(index)
        button.title = "Home"
        //        button.tag = index + 1)
        button.target = self
        button.action = "home:"
        scroll.addSubview(button)
    }
    
    
    
    
    func nextButton(index: Int){
        let button = NSButton()
        (button.cell as! NSButtonCell).backgroundColor = NSColor.blackColor()
        button.frame =  calculatePosition(index)
        button.title = "Next Page"
        button.tag = index
        //        button.tag = index + 1)
        button.target = self
        button.action = "next:"
        scroll.addSubview(button)
        //        scroll.contentSize = CGSize(width: bounds.width, height: CGFloat(y + 180))
        //        scroll.scrollEnabled = true
    }
    
    
    func previousButton(index: Int){
        let button = NSButton()
        (button.cell as! NSButtonCell).backgroundColor = NSColor.blackColor()
        button.frame =  calculatePosition(index)
        button.title = "Previous Page"
        button.tag = index
        //        button.tag = index + 1)
        button.target = self
        button.action = "previous:"
        scroll.addSubview(button)
        }
    
    func tapped(sender: NSButton) {
        let object = self.videos[sender.tag]
        self.performSegueWithIdentifier("Video", sender: object)
    }
    
    func next(sender: NSButton) {
        actualPage++
        if(!isSearch){
            self.showPage(actualPage)
        }
        else{
            self.searchText(field.stringValue)
        }
    }
    
    
    func previous(sender: NSButton) {
        actualPage--
        if(!isSearch){
            self.showPage(actualPage)
        }
        else{
            self.searchText(field.stringValue)
        }
    }
    
    func home(sender: NSButton){
        self.actualPage = 1
        self.showPage(actualPage)
    }
    
    
    func search(sender: NSButton){
        self.searchText(field.stringValue)
        self.actualPage = 1
    }
    

    
    override func prepareForSegue(segue: NSStoryboardSegue, sender: AnyObject!) {
        let video = sender as! Video
        if segue.identifier == "Video"{
            let vc = segue.destinationController as! VideoController
            vc.video = video
        }
    }
    
    
    func calculatePosition(index: Int) -> CGRect
    {
        let width = CGFloat(300)/2 - 15
        let height =  CGFloat(169)/2 - 15
        let numImagePerRow = Int(bounds!.width) / (Int(width) + 20)
        let x = ((index) % numImagePerRow) * Int(width) + 20 * ((index) % numImagePerRow + 1)
        let y = (index) / numImagePerRow * Int(height) + 20 * ((index) / numImagePerRow + 1)
        return CGRectMake(CGFloat(x), CGFloat(y), width, height)
    }
    
    
    func calculatePosition(index: Int, image: NSImage) -> CGRect
    {
        let width = image.size.width/2 - 15.0
        let height = image.size.height/2 - 15.0
        let numImagePerRow = Int(bounds!.width) / (Int(width) + 20)
        let x = (index % numImagePerRow) * Int(width) + 20 * (index % numImagePerRow + 1)
        let y = index / numImagePerRow * Int(height) + 20 * (index / numImagePerRow + 1)
        return CGRectMake(CGFloat(x), CGFloat(y), width, height)
    }
    
    func createButton(image: NSImage, index: Int,video: Video){
        let button = NSButton()
         (button.cell as! NSButtonCell).alignment = NSTextAlignment.Justified
         (button.cell as! NSButtonCell).backgroundColor = NSColor.blackColor()
        //button.alignment = NSTextAlignment. =  NSControlContentVerticalAlignment.Bottom
//        button.titleLabel?.lineBreakMode = .ByTruncatingTail
//        button.titleLabel?.backgroundColor = UIColor.blackColor()
        button.frame =  calculatePosition(index, image: image)
         (button.cell as! NSButtonCell).image = image
//        button.setBackgroundImage(image, forState: .Normal)
        button.title = String(htmlEncodedString: video.Title)
//        button.setTitle(String(htmlEncodedString: video.Title), forState: .Normal)
    
//        button.imageView?.contentMode = UIViewContentMode.ScaleAspectFit
//        button.title.setTitleColor(UIColor(red: 236.0/255.0, green: 86.0/255.0, blue: 124.0/255.0, alpha: 1.0), forState: .Normal)
//        button.titleLabel?.font = UIFont(name: "Times New Roman", size: 10)
        button.tag = index - 2
        button.target = self
        button.action = "tapped:"
//        button.addTarget(self, action: "tapped:", forControlEvents: .PrimaryActionTriggered)
//        button.clipsToBounds = true
        scroll.addSubview(button)
        //        scroll.clipsToBounds = true
    }
    
    
    func chargeImageAsync(image: String, index: Int, video: Video){
        let url = NSURL(string: image)
        if((url == nil || (url?.hashValue) == nil)){
            let image = NSImage(named: "ImageNotfound2.png")
            dispatch_async(dispatch_get_main_queue()){
                self.createButton(image!,index: index,video: video)
            }
        }else{
            let task = NSURLSession.sharedSession().dataTaskWithURL(url!) {(data, response, error) in
                let image = NSImage(data: data!)
                dispatch_async(dispatch_get_main_queue()){
                    self.createButton(image!,index: index,video: video)
                }
            }
            task.resume()
        }
        
    }
    
    override var representedObject: AnyObject? {
        didSet {
            // Update the view, if already loaded.
        }
    }
    
}

    extension String {
        init(htmlEncodedString: String) {
            let encodedData = htmlEncodedString.dataUsingEncoding(NSUTF8StringEncoding)!
            let attributedOptions: [ String: AnyObject ] = [ NSDocumentTypeDocumentAttribute: NSHTMLTextDocumentType as AnyObject, NSCharacterEncodingDocumentAttribute: NSNumber(value: String.Encoding.utf8.rawValue) as AnyObject ]

            var attributedString = NSAttributedString()
            do{
                attributedString = try NSAttributedString(data: encodedData, options: attributedOptions, documentAttributes: nil)
                
            }catch{
                print("error")
            }
            self.init(attributedString.string)
        }
}





