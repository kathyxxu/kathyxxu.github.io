---
layout:     post
title:      "使用webkit-box解决样式对齐问题"
subtitle:   ""
date:       2015-11-09
author:     "徐璇"
header-img: "img/post-bg-os-metro.jpg"
tags:
    - webkit-box
    - css
    - 对齐
---

#栗子1：icon和文字对齐   并居中显示#

!["栗子1"](../../../../imgPost/2015-11-09/1.png)


<style type="text/css">
    .ajax-loader{
        width: 100%;
        height: 20px;
        display: -webkit-box;
        -webkit-box-pack: center;
        -webkit-box-align: center;
        text-align: center;
    }
    .ajax-loader i{
        display: block;
        background: url("../../../../imgPost/2015-11-09/ajax-loader.gif") no-repeat;
        width: 16px;
        height: 16px;
        background-size: contain;
        margin-right: 4px;
    }
    .ajax-loader span{
        display: block;
        font-size: 16px;
        color: #ababab;
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

.ajax-loader{
    width: 100%;
    height: 3rem;
    
    display: -webkit-box;
    -webkit-box-pack: center;
    -webkit-box-align: center;
    text-align: center;
    i{
        display: block;
        margin: 0.8rem 0.6rem;
    }
    span{
        display: block;
        font-size: 1.2rem;
        color: #ababab;
    }
}
```

