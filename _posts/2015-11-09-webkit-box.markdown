---
layout:     post
title:      "webkit-box弹性盒子"
subtitle:   ""
date:       2015-11-09
author:     "徐璇"
header-img: "img/post-bg-os-metro.jpg"
tags:
    - webkit-box
    - css
    - 对齐
---

# 栗子1：icon和文字对齐并居中显示 #

<!-- !["栗子1"](../../../../imgPost/2015-11-09/1.png) -->


<style type="text/css">
    .ajax-loader{
        margin: 30px 0 20px 0;
        width: 100%;
        height: 40px;
        display: -webkit-box;
        -webkit-box-pack: center;
        -webkit-box-align: center;
    }
    .ajax-loader i{
        display: block;
        background: url("imgPost/2015-11-09/ajax-loader.gif") no-repeat;
        width: 20px;
        height: 20px;
        background-size: contain;
        margin-right: 8px;
    }
    .ajax-loader span{
        display: block;
        font-size: 24px;
        color: #ababab;
        line-height: 40px !important;
    }
</style>

<div class="ajax-loader">
    <i class="ico ico-ajax-loader"></i>
    <span>正在加载...</span>
</div>


```
<div class="ajax-loader">
    <i class="ico ico-ajax-loader"></i>
    <span>正在加载...</span>
</div>

<style type="text/css">
    .ajax-loader{
        width: 100%;
        height: 40px;
        display: -webkit-box;
        -webkit-box-pack: center;
        -webkit-box-align: center;
    }
    .ajax-loader i{
        display: block;
        background: url("../../../../imgPost/2015-11-09/ajax-loader.gif") no-repeat;
        width: 20px;
        height: 20px;
        background-size: contain;
        margin-right: 8px;
    }
    .ajax-loader span{
        display: block;
        font-size: 24px;
        color: #ababab;
        line-height: 40px !important;
    }
</style>
```

-webkit-box-pack: center;
水平方向，icon和图片当做一个整体，一起居中显示

-webkit-box-align: center;
垂直方向，规定如何对齐框的子元素
<br /> <br /> <br /> <br />



# 栗子2：webkit-box-flex #
<style type="text/css">
    .action-bar{
        padding: 0 !important;
        margin: 20px 0 30px 0;
        height: 45px;
        background-color: #f8f9fa;
        display: -webkit-box;
    }
    .action-item{
        display: -webkit-box;
        -webkit-box-pack: center;
        -webkit-box-align: center;
        -webkit-box-flex: 1;
        position: relative;
    }
    .action-item.action-item-0{
        -webkit-box-flex: 1;
    }
    .action-item.action-item-1{
        -webkit-box-flex: 2;
    }
    .action-item.action-item-2{
        -webkit-box-flex: 3;
    }
    .action-item i{
        display: block;
        background: url("../../../../imgPost/2015-11-09/icon-collect-light.png") no-repeat;
        width: 26px;
        height: 26px;
        background-size: contain;
        margin-right: 5px;
    }
    .action-item span{
        display: block;
        font-size: 16px;
        color: #777777;
    }
    .action-item:after{
        position: absolute;
        right: 0;
        bottom: 10px;
        top: 10px;
        width: 1px;
        content: '';
        background-color: #DEDFE0;
    }
    .action-item:last-of-type:after{
        width: 0;
    }
    .action-item:active{
        background-color: #e5e6e7;
    }
</style>
<ul class="action-bar">
    <li class="action-item action-item-0">
        <i class="ico"></i>
        <span>截屏</span>
    </li>
    <li class="action-item action-item-1">
        <i class="ico"></i>
        <span>收藏</span>
    </li>
    <li class="action-item action-item-2">
        <i class="ico"></i>
        <span>我要</span>
    </li>
</ul>

```
<style type="text/css">
    .action-bar{
        padding: 0 !important;
        margin: 20px 0 30px 0;
        height: 45px;
        background-color: #f8f9fa;
        display: -webkit-box;
    }
    .action-item{
        display: -webkit-box;
        -webkit-box-pack: center;
        -webkit-box-align: center;
        -webkit-box-flex: 1;
        position: relative;
    }
    .action-item.action-item-0{
        -webkit-box-flex: 1;
    }
    .action-item.action-item-1{
        -webkit-box-flex: 2;
    }
    .action-item.action-item-2{
        -webkit-box-flex: 3;
    }
    .action-item i{
        display: block;
        background: url("../../../../imgPost/2015-11-09/icon-collect-light.png") no-repeat;
        width: 26px;
        height: 26px;
        background-size: contain;
        margin-right: 5px;
    }
    .action-item span{
        display: block;
        font-size: 16px;
        color: #777777;
    }
    .action-item:after{
        position: absolute;
        right: 0;
        bottom: 10px;
        top: 10px;
        width: 1px;
        content: '';
        background-color: #DEDFE0;
    }
    .action-item:last-of-type:after{
        width: 0;
    }
    .action-item:active{
        background-color: #e5e6e7;
    }
</style>
<ul class="action-bar">
    <li class="action-item action-item-0">
        <i class="ico"></i>
        <span>截屏</span>
    </li>
    <li class="action-item action-item-1">
        <i class="ico"></i>
        <span>收藏</span>
    </li>
    <li class="action-item action-item-2">
        <i class="ico"></i>
        <span>我要</span>
    </li>
</ul>

```

