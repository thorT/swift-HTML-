//
//  ViewController.swift
//  01-网易新闻详情页
//
//  Created by thor on 16/8/11.
//  Copyright © 2016年 thor. All rights reserved.
//

import UIKit

class ViewController: UIViewController, UIWebViewDelegate{
    
    @IBOutlet weak var webView: UIWebView!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view, typically from a nib.
        
        // 1. 设置url
        if  let url = NSURL(string: "http://c.m.163.com/nc/article/BJ5NRE5T00031H2L/full.html") {
            // 设置urlRequest
            let request = NSURLRequest(URL: url)
            
            // 异步加载请求
            let dataTask = NSURLSession.sharedSession().dataTaskWithRequest(request, completionHandler: { (data, response, error) in
                if error == nil {
                    // 转为json数据
                    if let jsonData = try? NSJSONSerialization.JSONObjectWithData(data!, options: NSJSONReadingOptions.AllowFragments) as! NSDictionary {
                    // 处理数据并显示
                    self.deal(jsonData)
                    }
                }
                
            })
            // 开启请求
            dataTask.resume()
            
        }
        
    }

    func deal(jsonData:NSDictionary) -> Void {
        guard let allData = jsonData["BJ5NRE5T00031H2L"] else{
            return
        }
        print(allData)
        // 1. 去除body中内容
        guard  let bodyHtml = allData["body"] as? String else {
            return;
        }
        
        // 2. 取出标题
        guard let title = allData["title"] as? String else {
            return
        }
        
        // 3. 取出发布时间
        guard let ptime = allData["ptime"] as? String else {
            return
        }
        
        // 4. 取出来源
        guard let source = allData["source"] as? String else {
            return
        }
        
        // 5. 取出所有图片对象
        guard let img = allData["img"] as? [[String: AnyObject]] else{
            return
        }
        // 6. html最终的body
        var finalBodyHtml = ""
        
        // 7. 遍历
        for i in 0..<img.count {
            
            // 6.1 取出单独的图片对象
            let imgItem = img[i]
            
            // 6.2
            if let ref = imgItem["ref"] as? String {
            
            // 6.3 取出src
            let src = ((imgItem["src"] as? String) != nil) ? imgItem["src"] as! String : ""
            let alt = ((imgItem["alt"] as? String) != nil)  ? imgItem["src"] as! String : ""
            let imgHtml = "<div class=\"all-img\"><img src=\"\(src)\" alt=\"\(alt)\"></div>"
            
            let subBodyHtml = bodyHtml.stringByReplacingOccurrencesOfString(ref, withString: imgHtml)
          finalBodyHtml = finalBodyHtml.stringByAppendingString(subBodyHtml)
            }
        }
        
        // 创建标题的HTML标签
        let titleHtml = "<div id=\"mainTitle\">\(title)</div>"
        
        // 创建子标题的html标签
        let subTitleHtml = "<div id=\"subTitle\"><span class=\"time\">\(ptime)</span><span>\(source)</span></div>"
        
        // 加载css的url路径
        let cssUrl_temp = NSBundle.mainBundle().URLForResource("newsDetail", withExtension: "css")?.absoluteString
       let cssUrl = (cssUrl_temp != nil) ? cssUrl_temp! : ""
        // 创建link
        let cssHtml = "<link href=\"\(cssUrl)\" rel = \"stylesheet\">"
        
        // 加载js的路径
        let jsUrl_temp = NSBundle.mainBundle().URLForResource("newsDetail", withExtension: "js")?.absoluteString
        let jsUrl = jsUrl_temp != nil ? jsUrl_temp! : ""
        let jsHtml =  "<script src=\"\(jsUrl)\" type=\"text/javascript\"></script>"
        
        // 拼接
        let html =  "<html><head>\(cssHtml)</head><body>\(titleHtml)\(subTitleHtml)\(finalBodyHtml)\(jsHtml)</body></html>"
        
        // 加载
        webView.loadHTMLString(html, baseURL: nil)
    }
    
    //UIVebViewDelegate
    func webView(webView: UIWebView, shouldStartLoadWithRequest request: NSURLRequest, navigationType: UIWebViewNavigationType) -> Bool {
        // 1. 取出请求字符串
        if let absolut:NSString = request.URL?.absoluteString {
            // 2. 判断
            let urlHeader = "xmg:///"
            if(absolut.hasPrefix(urlHeader)) {
                // 取出方法名
                let method = absolut.substringFromIndex(urlHeader.characters.count)
//                if method == "openCamera" {
//                    print(method)
//                  self.openCamera()
//                }
                // 包装
                let sel = NSSelectorFromString(method)
                // 执行
                if self.respondsToSelector(sel) {
                    self.performSelector(sel)
                }
            }
        }
        return true;
    }
    
    // js访问相册
    func openCamera() -> Void {
        let photoVC = UIImagePickerController();
        photoVC.sourceType = UIImagePickerControllerSourceType.PhotoLibrary;
        
        // 模态出来
        self.presentViewController(photoVC, animated: true, completion: nil);
    }
    
    
    func webViewDidFinishLoad(webView: UIWebView) {
        
    }
    
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    
    
    
    
    
    
    
    
    
    
    
    
    
    
    
    
    
    


}

