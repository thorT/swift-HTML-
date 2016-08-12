window.onload = function(){
    
    // 拿到所有的图片
    var allImg = document.getElementsByTagName("img");
   // alert(allImg.length);
    
    // 遍历
    for(var i = 0; i<allImg.length; i++){
        // 取出单个图片对象
        var img = allImg[i];
        img.id = i;
        // 监听点击
        img.onclick = function(){
            //alert('点击了'+ this.id + '张')
            window.location.href = "xmg:///openCamera";
        }
    }
    
    // 往网页尾部加入图片
    var img = document.createElement('img');
    img.src = 'http://pic8.nipic.com/20100623/55218_100905033361_2.jpg';
    document.body.appendChild(img);
    
}







