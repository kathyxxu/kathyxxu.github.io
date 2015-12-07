---
layout:     post
title:      "javascript模式笔记4——对象创建模式"
subtitle:   ""
date:       2013-12-10
author:     "徐璇"
header-img: "img/post-bg-universe.jpg"
tags:
    - js模式笔记
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
</style>


# 1.命名空间(namespace)

### 1.1 命名空间模式

```
//5个全局变量
//反模式
//构造函数
function Parent(){}
function Child(){}

//一个变量
var some_var = 1 ;

//一些对象
var module1 = {};
module1.data = {
    a : 1,
    b : 2
};
var module2 = {};
```

创建一个全局对象重构上述代码：

```
//1个全局变量
//重构上述代码，创建一个全局对象MYAPP，改变所有函数和变量成为这个全局对象的属性
var MYAPP ={};
MYAPP.Parent = function(){};
MYAPP.Child = function(){};
MYAPP.some_var = 1;
//一个容器对象
MYAPP.modules = {};
//嵌套对象
MYAPP.modules.module1 = {};
MYAPP.modules.module1.data = {a:1, b:2};
MYAPP.modules.module2 = {};
```

缺点：
1、每个变量和函数都要附加前缀，字符多，代码下载量多
2、长嵌套名，属性解析时间加长
3、仅有一个全局实例意味着任何部分的代码都可以修改该全局实例


### 1.2 通用命名空间函数

由于程序复杂性增加，代码被分割成不同的文件，以及使用条件包含语句等多个因素，又假设您的代码是第一个定义某个命名空间或它内部的一个属性，这种做法已不再安全，添加到命名空间的一些属性可能已经存在，存在覆盖问题，应该事先检查：

```
//不安全的代码
var MYAPP = {};

//更好的代码风格
if(typeof MYAPP === "undefined"){
    mar MYAPP = {};
}

//或者用更短的语句
var MYAPP = MYAPP || {};
```

问题：大量重复的检查代码，如想定义MYAPP.modules.module2，要做3次检查！

下面是一个命名空间函数的实现，如果已存在一个命名空间，不会重复创建：

```
var MYAPP = MYAPP || {};
MYAPP.namespace = function(ns_string){
    var parts = ns_string.split("."),
        parent = MYAPP,
        i;


    //剥离最前面的冗余全局变量
    if(parts[0] === "MYAPP"){
        parts = parts.slice(1);
    }


    for(i=0; i<parts.length; i++){
        //如果它不存在，就创建一个属性
        if(typeof parent[parts[i]] === "undefined"){
            parent[parts[i]] = {};
        }
        parent = parent[parts[i]];
    }
    return parent;
}


//将返回值赋给一个局部变量
var module2 = MYAPP.namespace('MYAPP.modules.module2');
console.log(module2 === MYAPP.modules.module2); //true


MYAPP.namespace('modules.module2');
MYAPP.namespace("once.upon.a.time");
```

!["通用命名空间函数"](../../../../imgPost/2013-12-10/1.png) 










# 依赖声明(dependency declaration)

# 模块模式(module pattern)

# 沙箱模式(sandbox pattern)


