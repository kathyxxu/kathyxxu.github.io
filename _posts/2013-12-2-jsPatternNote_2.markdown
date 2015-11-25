---
layout:     post
title:      "javascript模式笔记2——字面量和构造函数"
subtitle:   ""
date:       2013-12-2
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


### 对象字面量：

```
//开始定义一个空对象
var dog = {};
//添加属性
dog.name = "wangwagn";
//添加方法
dog.getName = function(){
    return dog.name;
}


//改变属性和方法
dog.getName = function(){
    return "Fido";
}

//删除属性和方法
delete dog.name;


//添加属性和方法
dog.say = function(){
    return "Woof!";
}
dog.fleas = true;


//也可以在创建对象时，向其添加属性和方法
var dog = {
    name : "wangwang";
    getName : function(){
        return this.name;
    }
}
```

>注意：全局变量（var 声明）不可删


### 创建对象的两种的方法
第一种是使用**字面量**方法创建对象：`var oschina = {goes:"far"};`
第二种是使用**内置构造函数**创建对象：`var oschina = new Object();  car.gose = "far";`
我们应该尽量使用字面量方法创建对象，其显著优点在于它仅仅输入更短的字符。
但是选择它还有以下几个更重要的原因：

1. 选择字面量法创建对象强调该对象仅是一个可变的hash映射，而不是从对象中提取的属性或方法。
2. 对使用Object构造函数相对，使用字面量在于它并没有作用域解析。因为可能以同样的名字创建一个局部函数，解释器需要从调用Object()的位置开始一直向上查询作用域链，知道发现全局Object构造函数
3. 构造函数Object可以仅接受一个参数，并且还依赖传递的值，该Object()可能会委派另一个内置函数来创建对象，并且返回了一个并非期望的不同对象。如将数字、字符串、布尔值当做参数传递给Object构造函数，其结果是获得了以不同构造函数所创建的对象，例如：`var oschina = new Object(1);` `ochina.constructor`为Number；传递的值是动态的，直到运行时才确定其类型，这种行为会导致意想不到的结果。

```
//一个空对象
var o = new Object();
console.log(o.constructor === Object);  //true


//一个数值对象
var o = new Object(1);
console.log(o.constructor === Number);  //true
console.log(o.toFixed(2));  //1.00


//一个字符串对象
var o = new Object("I am a string");
console.log(o.constructor === String);  //true
//一般的对象没有substring方法，但是字符串对象有
console.log(typeof o.substring);    //"function"


//一个布尔对象
var o = new Object(true);
console.log(o.constructor === Boolean);  //true
```



### 自定义构造函数

```
var Person = function(name){
    this.name = name;
    this.say = function(){
        return "I'am " + this.name;
    };
}


var Person = function(name){
    //使用对象字面量模式创建一个新对象
    //var this = {};

    //向this添加属性和方法
    this.name = name;
    this.say = function(){
        return "I'am " + this.name;
    };

    //return this;
}

var xuxuan = new Person("kathy");
console.log(xuxuan.say());
```

使用new调用构造函数：
1. 创建一个空对象，并且this引用了该对象，同时还继承了该函数的原型
2. 属性和方法添加到this引用的对象中
3. 新创建的对象由this引用， 最后隐式地返回this（如果没有显示的返回其他对象）

`//var this = {};`
以上语句并不是真相的全部哦。因为“空”对象实际上并不空，已从Person的原型中继承了许多成员，因此它更像下面的语句：
`//var this = Object.create(Person.prototype);`
