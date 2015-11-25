---
layout:     post
title:      "javascript模式笔记1——基本技巧"
subtitle:   ""
date:       2013-11-25
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


### 关于全局变量

js使用函数管理作用域，变量在函数内声明，只在函数内有效，外部无法访问。
全局变量在函数外声明，在函数内无需声明就可使用。

js如下特性，即**意外创建全局变量：**

1. 可以直接使用变量，甚至无需声明
2. 有个暗示全局变量，即任何变量若未经声明，就为全局对象所有

```
myGolbal = "hello";  //反模式
console.log(myGolbal);  //hello
console.log(window.myGolbal);  //hello
console.log(window["myGolbal"]);  //hello
console.log(this.myGolbal);  //hello

function xx(){
    console.log(typeof this.myGolbal);  //"string"
    console.log(this.myGolbal); //hello
}
xx();

var Xu= function(){
    this.say = function(){
        console.log(typeof this.myGolbal);  //"undefined"
        console.log(this.myGolbal); //undefined
    }
}
var xu = new Xu();
xu.say();
```


**最小化全局变量：**

1. 使用var声明
2. 命名空间模式
3. 自执行立即生效函数(the self-executing immediate functions)

```
function foo(){
    var a = b = 0;
    // 结果：a-局部  b-全局
    // 解释：var a =( b= 0);  从右至左的操作符优先级；优先级高的是表达式b=0,此时b未声明；表达式的返回值为0，赋给var声明的局部变量a
}
```

```
function foo(){
    var a, b;
    a = b = 0;
    // 这样，a，b都是全局变量
}
```

**访问全局对象：**
这种方式通常能获得全局对象，因为this在函数内部作为一个函数调用（而不是通过构造器new创建）时，往往指向该全局对象。但是，在严格模式下会出错。

```
"use strict"
var global = (function(){
    return this;
})();
console.log(global);
```


### 单一var模式（Single var Pattern）
只是用一个var在函数顶部进行变量声明

```
function func(){
    var a = 1,
        b=2,
        sum = a + b,
        myobject = {},
        i,
        j;
    //....
}
```


### 变量提升

```
myname = "global";
function func(){
    console.log(myname); //undefined
    var myname = "local";
    console.log(myname); //"local"
}
func();
```

所有的变量声明都提升到函数的最顶层
为避免混乱，最好在开始就声明要用的所有变量

```
myname = "global";
function func(){
    var myname;
    console.log(myname); //undefined
    var myname = "local";
    console.log(myname); //"local"
}
func();
```

关于变量代码处理两个阶段：

1. 进入上下文：创建变量、函数声明、形式参数
2. 代码运行：创建函数表达式和不合格标示符（未定义变量）



### for循环

问题：每次都要访问数组的长度，导致速度变慢。尤其当myarray不是数组，而是HTML容器对象的时候。

```
for(var i=0; i<myarray.length; i++){
  ...
}
```

HTML容器是DOM方法返回的对象：
document.getElementsByName()
document.getElementsByClassName()
document.getElementsByTagName()
documents.images
documents.links
documents.forms
document.forms[0].elements

容器的问题在于他们在document（HTML页面）下是活动的查询，每次访问任何容器的长度是，也就是在查询活动的DOM，通常DOM操作是非常耗时的。


**优化：**

用i++; 代替 i=i+1; i+=1;

```
for(var i=0, max=myarray.length; i<max; i++){
  ...
}
```

使用最少的变量：

```
var i, myarray=[5,9,"dd"];
for(i=myarray.length; i>0 ;i--){
    console.log(myarray[i-1]);
}


var i, myarray=[5,9,"dd"];
for(i=myarray.length; i--; ){
    console.log(myarray[i]);
}
```

逐步减至0，因为同0比较长度效率更高

```
var myarray=[5,9,"dd"];
var i = myarray.length;
console.log(i); //3
while(i--){
    console.log(i);  //2 1 0
    console.log(myarray[i]);  //dd 9 5
}
```


### for-in循环

for-in遍历非数组对象，不推荐遍历数组（当数组对象已经被自定义函数扩大后，这样做会导致逻辑错误）,
所以推荐for循环处理数组，for-in循环处理对象。
当遍历对象属性遇到原型链属性时，使用hasOwnProperty()非常重要！

```
var man={
    hands : 2,
    legs : 2,
    heads : 1
}

if(typeof Object.prototype.clone === "undefined"){
    Object.prototype.clone = function(){
        console.log("I'm clone!");
    }
}


//不过滤，会打印出clone()
for(var i in man){
    console.log(i,":",man[i]);
}
/*
hands : 2
legs : 2
heads : 1
clone : (){
    console.log("I'm clone!");
}
*/


//使用hasOwnProperty过滤原型属性
for(var i in man){
    if(man.hasOwnProperty(i)){
        console.log(i,":",man[i]);
    }
}
/*
hands : 2
legs : 2
heads : 1
*/


//另一种使用hasOwnProperty的模式是在Object.prototype中调用
for(var i in man){
    if(Object.prototype.hasOwnProperty.call(man,i)){
        console.log(i,":",man[i]);
    }
}


//使用本地变量缓存较长属性名
var i,
    hasOwn = Object.prototype.hasOwnProperty;
for(i in man){
    if(hasOwn.call(man,i)){
        console.log(i,":",man[i]);
    }
}


//一种格式化的变种（没有通过JSLint测试）省略了花括号，并将if语句放在同一行中
//好处：可读性强（拥有属性X的元素，就直接对其操作；更少的缩进达到循环的目的）
var i,
    hasOwn = Object.prototype.hasOwnProperty;
for(i in man) if(hasOwn.call(man,i)){
    console.log(i,":",man[i]);
}

```




### 不要随意增加内置的原型

1.影响代码可维护性
2.给原型添加的属性在没有使用hasOwnProperty()时，可能在循环中出现，导致一些混乱

可采用如下模式为原型增加自定义的方法：

```
if(typeof Object.prototype.myMethod !== "function"){
    Object.prototype.myMethod = function(){
        //.....
    }
}
```


### switch模式

要注意一点的是：避免使用fall-throughs（即有意不使用break语句，这样会使程序一直向下执行）

```
var inspect_me = 0,
    result = "";

switch(inspect_me){
    case 0:
        result = "zero";
        break;
    case 1 :
        result = "one";
        break;
    default:
        result = "unknow";
}

console.log(result);
```





### 避免使用隐式类型转换

```
var zero = 0;
if(zero == false){
    console.log("zero == false is true!");
}
if(zero === false){
    console.log("zero === false is true!");
}
```

结果：zero == false is true!
原因：js在使用比较语句时会执行隐式类型转换，false==0 or ""==0 会返回true；
为避免混淆，在使用比较语句的时候使用=== or !==




### 避免使用eval()
```
var property = "name",
    method = "getName";
var obj = {
    name:"kathy",
    getName : function(){
        return this.name;
    }
};

//反模式
console.log(eval("obj."+property));
console.log(eval("obj."+method+"()"));


//推荐的方法，简单的使用[]访问动态属性
console.log(obj[property]);
console.log(obj[method]());
```

使用`eval()`包含一些安全隐患，有可能执行被篡改过得代码（例如来自网络的代码），这是在处理一个Ajax请求的JSON响应时常见的反模式。在这些情况下，最好使用浏览器内置方法解析JSON请求，确保安全性和有效性。
注意：通过`setInterval()`  `setTimeout()`  `function()`等构造函数来传递参数，大部分情况下会导致类似eval()隐患，应避免使用；


```
var myFunc1 = function(){
    console.log(1);
}
var myFunc2 = function(p1,p2,p3){
    console.log(p1,p2,p3);
}

//反模式
setTimeout("myFunc1()",1000);
setTimeout("myFunc2(2,3,4)",2000);

//推荐的模式
setTimeout(myFunc1,3000);
setTimeout(myFunc2(7,8,9),4000);  // setTimeout(myFunc2(7,8,9),4000); 是立即执行的，所以设置4000不生效
setTimeout(function(){
    myFunc2(77,88,99);
},5000);

/*
7 8 9
1
2 3 4
1
77 88 99
*/
```

考虑使用**new Function() 代替eval()**或者**将eval()封装到一个即时函数中**。
这样做的好处是new Function()代码在局部函数空间运行，代码中任何var定义的变量不会自动成为全局变量。

```
console.log(typeof one);   //"undefined"
console.log(typeof two);   //"undefined"
console.log(typeof three); //"undefined"

//使用eval
var jsstring = "var one = 1; console.log(one);";
eval(jsstring);

//使用new Function
var jsstring = "var two = 2; console.log(two);";
new Function(jsstring)();

//将eval封装到一个即时函数中
var jsstring = "var three = 3; console.log(three);";
(function(){
    eval(jsstring);
})();

console.log(typeof one);    //"number"
console.log(typeof two);    //"undefined"
console.log(typeof three);  //"undefined"
```


`eval()`可以访问和修改它外部作用域的变量
`Function`多类似一个沙盒，无论在哪里执行，只能看到全局作用域

```
(function(){
    var local = 1;
    //eval可以访问和修改它外部作用域的变量
    eval("local = 3; console.log(local)"); //3
    console.log(local);  //3
})();


(function(){
    var local = 1;
    //Function就不可以，它仅能看到全局作用域
    new Function("local = 3; console.log(local)")();  //3
    console.log(local);  //1
})();


(function(){
    var local = 1;
    eval("console.log(typeof local)"); //"number"
    console.log(local);  //1
})();


var global = "golbal_var";
(function(){
    var local = 1;
    //Function类似一个沙盒，它仅能看到全局作用域(global)，因此对局部变量(local)的影响比较小
    Function("console.log(typeof local)")();  //"undefined"
    Function("console.log(typeof global)")();  //"string"
    console.log(local);  //1
})();
```



### 使用parseInt()的数值约定：

当解析的字符串是0开始，可能被当做8进制，为避免冲突，最好每次都指定具体进制参数

```
var month = "06";
var day = "09";
month = parseInt(month,10);
day = parseInt(day,10);

console.log(month,day); // 6 9
```

两个方法将非数值-->数值

```
var box1 = "08";
console.log(typeof +box1); //number

var box2 = Number("08");
console.log(typeof box2);  //number
```

比较：
parseInt()——解析
Number()——简单转换

```
console.log(Number("012xx")); //NaN
console.log(Number("xx012")); //NaN
console.log(parseInt("012xx")); //12
console.log(parseInt("xx012")); //NaN,如果第一个不是数值，就返回NaN
```
