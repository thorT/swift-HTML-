# swift加载网络接口合成HTML页面示例
<br />
<br />


---
##### 概述：使用swift，通过拉取网易接口数据，在swift工程中创建js、css文件及html格式，使用webView 加载接口内容并用页面展示的示例；仅供参考；
---

###### 示例
![](https://github.com/thorT/swift-HTML-/blob/master/screenshot/IMG_0261.PNG?raw=true)

### 过程：
###### 1. NSURLSession 加载数据  
        <pre>if  let url = NSURL(string: "http://c.m.163.com/nc/article/BJ5NRE5T00031H2L/full.html") {
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
        }</ pre>

###### 2. 处理数据
  <pre> func deal(jsonData:NSDictionary) -> Void {
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
    }</pre>

###### 3. 简单的css 样式 
<pre>
body{
/*    background-color: red;*/
}
img{
    width: 100%;
}
\#mainTitle{
    text-align: center;
    font-size: 20px;
    margin-top: 25px;
    margin-bottom:8px;
}
\#subTitle{
    color: gray;
    text-align:center;
}
.time{
    margin-right: 10px;
    margin-bottom:8px;
}
.all-img{
    text-align: center;
    color:gray;
    margin: 8px 0;
}</pre>

###### 4. 简单的js
<pre>
window.onload = function(){
    // 拿到所有的图片
    var allImg = document.getElementsByTagName("img");
   // alert(allImg.length);
    // 遍历
    for(var i = 0; i < allImg.length; i++){
        // 取出单个图片对象
        var img = allImg[i];
        img.id = i;
        // 监听点击
        img.onclick = function(){
            //alert('点击了'+ this.id + '张')
            // js调用，swift接收
            window.location.href = "xmg:///openCamera";
        }
    }
    // 往网页尾部加入图片
    var img = document.createElement('img');
    img.src = 'http://pic8.nipic.com/20100623/55218_100905033361_2.jpg';
    document.body.appendChild(img);
}</pre>

###### 5. swift 接收图片点击事件，并弹出相册
<pre>
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
    }</pre>


<br />
<br />
<br />
<br />
<br />
<br />
<br />
<br />
<br />
<br />
<br />
