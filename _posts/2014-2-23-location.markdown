---
layout:     post
title:      "Location对象"
subtitle:   ""
date:       2014-02-23
author:     "徐璇"
header-img: "img/post-bg-universe.jpg"
tags:
---

<style type="text/css">
	p{
		margin: 30px 0 5px 0;
	}
	img{
		margin-top: 5px !important;
	}
	.post-container h1, .post-container h2, .post-container h3, .post-container h4, .post-container h5, .post-container h6 {
    	margin: 60px 0 10px;
	}
	.post-container ul, .post-container ol {
	    margin-bottom: 20px;
	}
	/*code{
		padding: 2px 4px;
	    color: #d14;
	    background-color: #f7f7f9;
	    border: 1px solid #e1e1e8;
	    font-family: Menlo,Monaco,Consolas,"Courier New",monospace;
    	border-radius: 3px;
	} */
</style>


完整的url由以下几个部分组成：
protocal://host:port/path?query#hash

例如页面的url为：
http://www.example.com:8080/news/post/2013/index.html?type=js&color=red#print/color/red


## Location对象属性

`location.href`返回页面完整的url
http://www.example.com:8080/news/post/2013/index.html?type=js&color=red#print/color/red

`location.protocal`返回url的协议
http:

`location.port`返回url的端口号
8080

`location.host`返回url的主机名
www.example.com

`location.origin`返回url的协议名、主机名和端口号，如果端口号为80，返回协议名和主机名
http://www.example.com:8080

`location.host`返回url的主机名和端口号， 如果端口号为80，返回主机名
www.example.com:8080


`location.pathname`返回url的路径部分
/news/post/2013/index.html


`location.search`获得的是页面url中QueryString部分，即？之后的部分
type=js&color=red

`location.hash`获得的是页面url中锚部分，即从#号开始的部分
#print/color/red


解析页面QueryString

```
console.log(window.location.search)
// ?type=js&color=red

console.log(window.location.search.substr(1).split("&"))
// ["type=js", "color=red"]
```

> Locaiton的以上属性都是可读可写


## Location对象方法

assign() |	加载新的文档。
reload() |	重新加载当前文档。
replace() |	用新的文档替换当前文档。


比较：

```
location.href='http://www.example.com'
location.assign('http://www.example.com')
location.replace('http://www.example.com')
```

前两者效果一样，是一次**跳转**的过程，当前页面转为新页面，可以点击“后退”返回上一个页面，href与assign方法会产生历史记录。


但是replace方法是一次**替换**的过程，指定新的页面来替换当前页面，前后两个页面共用一个窗口，所以是没有后退返回上一页的。

场景：
一个app的入口为A页面地址，A页面不展示任何UI，只做js逻辑判断，如果不符合判断条件，出一个提示框，如果符合判断条件，自动跳转到B页面。 如果用href或assign来跳转到B页面，在B页面点击返回，会产生'redirection loop'，永远停留在B页面，跳不出去，这种情况下应该用replace来跳转到B页面。


`location.reload(force)`

参数force默认为false，会检查http头If-Modified-Since判断文档是否有变化，如果有，reload()会重新加载当前页面，如果未发生变化，则从缓存中加载文档。
如果参数为true，就不走缓存，直接从服务器下载该文档。




## 小议location.hash

http://www.example.com/index.html#hash

**锚点**标示网页中的某一个位置，浏览器读取到这个标示符后，会自动将页面滚动到指定位置。

为网页位置指定标识符，有两个方法：
一是使用锚点，比如`<a name="print"></a>`
二是使用id属性，比如`<div id="print">`

举个小栗子：

```
<a href='#news'>go to news</a>
<a href='#about'>go to about</a>
<a href='#links'>go to links</a>
<div id='news' style='width:500px;height:500px'>News section</div>
<div id='about' style='width:500px;height:900px'>About Section</div>
<div id='links' style='width:500px;height:1000px'>Links Section</div>
```

比如点击超链接go to links，页面url变为`http://www.example.com/index.html#links`，id为links的div会被自动滚动到页面的可视区域。

同时，我们发现尽管页面的url发生变化了（只有#hash部分变化），但是没有产生任何的http请求，因为#hash是来指导浏览器动作的，对服务器不起任何作用，**http的请求不包括#**，所以**改变url的hash不会触发页面重新加载**。


我们每次**改变url的hash，都会在浏览器的历史访问中产生一条记录**，点击“回退”按钮，返回到上一个hash。这对于ajax应用程序特别有用，可以用不同的#值，表示不同的访问状态，然后向用户给出可以访问某个状态的链接。
值得注意的是，上述规则对IE 6和IE 7不成立，它们不会因为#的改变而增加历史记录。



这里要注意下，**url中第一个#后面的字符，都会被解析为位置标识符**。http://www.example.com:8080/news/post/2013/index.html?type=js&color=#red#print/color/red，这个url本意是想把color参数想指定为#red, 后面再跟上hash，即#print/color/red，
但是location.search输出`?type=js&color=`，
location.hash输出`#red#print/color/red`。

只有将#转码为%23，浏览器才会将其作为实义字符处理。把url改为http://www.example.com:8080/news/post/2013/index.html?type=js&color=%23red#print/color/red，
location.search输出`?type=js&color=%23red`，
location.hash输出 `#print/color/red`。




`window.onhashchange`是HTML5新增的事件，当hash值有变化的时候，就触发这个事件。它的使用方法有三种：

```
window.onhashchange = func;
<body onhashchange="func();">
window.addEventListener("hashchange", func, false);
```

对于不支持onhashchange的浏览器，可以用setInterval监控location.hash的变化。


url的hash原本是用于跳转到页面的锚点，默认情况下，搜索引擎会忽略url的hash部分。但是现在越来越多的hash被用于ajax请求获取数据，不同的hash对应页面不同的状态，这种情况下，应该是要被收录的。Google提出的解决方案是用`#!`来进行区分，Google会自动将其后面的内容转为查询字符串`_escaped_fragment_`的值，比如 http://www.example.com/#!/news 被抓取时会解析为 http://www.example.com/?_escaped_fragment_=/news，通过这种机制，Google就可以收录动态的Ajax内容。


