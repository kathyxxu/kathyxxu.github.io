---
layout:     post
title:      "javascript模式笔记3——函数"
subtitle:   ""
date:       2013-12-5
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


### 函数

特点1. 函数是第一类对象（first-class object）
- 可以在运行时动态创建，还可以在程序执行过程中创建
- 可以分配给变量，可以将其引用复制到其他变量，可以被扩展，甚至可以被删除（除少数情况外）
- 可以作为参数传递给其他函数，也可以由其他函数返回
- 可以有自己的属性和方法

特点2. 函数提供作用域
- 块不创建作用域，js中仅存在函数作用域
- if for while的{ }中，使用var声明的变量，对于包装函数来说才是局部变量

函数3类型：
- 函数声明
- 命名函数表达式
- 未命名函数表达式

```
//函数声明(function declaration)
function add(arg){}


//命名函数表达式(named function expression)
var add = function add(arg){};


//未命名函数表达式(unnamed function expression),也简称为函数表达式
//匿名函数(anonymous function)
var add = function(arg){};
```


函数的命名属性：
函数有个只读属性`name`，虽然不是标准属性，但是在很多环境中都可以使用它。在函数声明和命名函数表达式中，已定义了`name`属性。在匿名函数表达式中，依赖于其实现方式，`name`属性可能是未定义，也能是空字符串。

```
function foo(){}
var bar = function(){}
var baz = function baz(){}

console.log(foo.name);//foo
console.log(bar.name);//""
console.log(baz.name);//baz
```

`var foo = function bar(){ };`
使用命名函数表达式将其分配给一个具有不同名称的变量，在技术上可行，但在一些浏览器中，这种行为没有被正确的实现，不推荐。



### 函数的提升

```
funciton foo() {
    console.log("global foo");
}

funciton bar() {
    console.log("global bar");
}

function hoistMe(){
    console.log(typeof foo); //function
    console.log(typeof bar); //undefined

    foo(); //local foo
    bar(); //TypeError: undefined is not a function

    //函数声明
    //变量foo和函数实现都被提升
    function foo(){
        console.log("local foo");
    }

    //函数表达式
    //变量bar被提升————typeof bar里的bar是local的bar，而不是global的bar，所以输出undefined
    //函数实现没有被提升————所以执行bar();报错
    var bar = function(){
        console.log("local bar");
    };
}


hoistMe();
```


`hoistMe()`函数中的foo和bar，声明被提到的顶部，覆盖了全局的foo和bar。

两者区别：

函数 | 函数声明是否被提升 | 函数定义是否被提升
函数声明 | yes | yes
函数表达式 | yes | no




### 回调模式

```
function writeCode(callback){
    //...
    callback();
    //...
}

function introduceBugs(){
    //...
}

writeCode(introduceBugs);
```

> 注意：`introduceBugs()`作为参数传递给`writeCode()`是不带括号的；
括号表示要执行函数，在这种情况下，我们只需要传递该函数的应用，让`writeCode()`在适当的时候来执行它（也就是说，返回以后回调）


回调示例：

```
var findNodes = function () {
    var i = 100000, // big, heavy loop
    nodes = [], // stores the result
    found; // the next node found
    while (i) {
        i -= 1;
        // complex logic here...
        nodes.push(found);
    }
    return nodes;
};


var hide = function (nodes) {
    var i = 0, max = nodes.length;
    for (; i < max; i += 1) {
        nodes[i].style.display = "none";
    }
};
// executing the functions
hide(findNodes());
```

这个实现是低效的，`hide()`必须再次循环遍历由`findNodes()`返回的数组节点。如果能在`findNodes()`中实现隐藏逻辑，虽然高效，但是检索和修改逻辑耦合，它就不再是一个通用函数。

解决办法就是采用回调模式，代码如下：

```
// refactored findNodes() to accept a callback
var findNodes = function (callback) {
    var i = 100000,
    nodes = [],
    found;
    // check if callback is callable
    if (typeof callback !== "function") {
        callback = false;
    }
    while (i) {
        i -= 1;
        // complex logic here...
        // now callback:
        if (callback) {
            callback(found);
        }
        nodes.push(found);
    }
    return nodes;
};


// a callback function
var hide = function (node) {
    node.style.display = "none";
};
// find the nodes and hide them as you go
findNodes(hide);
```

`findNodes()`执行的唯一额外任务就是检查是否提供了可选的回调函数，如果存在的话就执行；
由于回调函数是可选的，所以重构后的`findNodes()`仍然可以像以前一样使用。这样，`hide()`的实现就简单多了，不需要循环遍历所有节点。

回调函数也可以是一个匿名函数：

```
// passing an anonymous callback
findNodes(function (node) {
    node.style.display = "block";
});
```


### 回调与作用域

问题的提出：回调函数不是一次性的匿名函数或全局函数，而是对象的方法，如果该回调方法使用`this`来引用它所属的对象，会导致一些意外情况...

```
var myapp = {};
myapp.color = "green";
myapp.paint = function(node){
    node.style.color = this.color;
}


var findNodes = function(callback){
    var node = document.getElementById("xx");
    if(typeof callback === "function"){
        callback(node);
    }
}


findNodes(myapp.paint);
```


`findNodes()`是一个全局函数，因此this指向全局对象，所以`this.color`没有被定义。如果`findNodes()`是一个名为dom的对象的方法`(dom.findNodes())`,那么回调内部的this指向dom，而不是预期的myapp。

this 关键字的用法其实比较复杂，不过你只要牢记一句话就可以：
**“this变量永远指向函数运行时所在的对象，而不是函数被创建时所在的对象。如果处在匿名函数中、或者不处于任何对象中，this都指向宿主的根对象（在浏览器里面就是 window）”**


解决方案：传递回调函数，**还传递该回调函数所属的对象**

```
var myapp = {};
myapp.color = "green";
myapp.paint = function(node){
    node.style.color = this.color;
}


var findNodes = function(callback, callback_obj){

    var node = document.getElementById("xx");

    if(typeof callback === "function"){
        callback.call(callback_obj, node);
    }

    if (typeof callback === "string") {
        callback_obj[callback].call(callback_obj, node);
    }
}


findNodes(myapp.paint, myapp);
findNodes("paint", myapp);
```


注意：以下实现方式，字体颜色也会发生变化，`findNodes`函数的参数`myapp.paint(document.getElementById("xx"))`就是在执行一个函数，这个函数中的this指向的是myapp

```
var myapp = {};
myapp.color = "green";
myapp.paint = function(node){
    node.style.color = this.color;
}


var findNodes = function(callback){
    if(typeof callback === "function"){
        callback();
    }
}


findNodes(myapp.paint(document.getElementById("xx")));
```



其他实现方式：

```
__bind = function(fn, me){
    return function(){
        return fn.apply(me, arguments);
    };
};


var myapp = {};
myapp.color = "green";
myapp.paint = function(node){
    node.style.color = this.color;
}


var findNodes = function(callback, callback_obj){
    var node = document.getElementById("xx");
    if(typeof callback === "function"){
        //指定callback的执行环境为callback_obj
        callback = __bind(callback, callback_obj); 
        callback(node);
    }
}


findNodes(myapp.paint, myapp);
```





```
__bind = function(fn, me){
    return function(){
        return fn.apply(me, arguments);
    };
};


var myapp = {
    color : "green",
    paint : function(node){
        node.style.color = this.color;
    }
};


//这里的myapp不可以写成this，this指向全局对象
myapp.paint = __bind(myapp.paint, myapp); 


var findNodes = function(callback){
    var node = document.getElementById("xx");
    if(typeof callback === "function"){
        callback(node);
    }
}


findNodes(myapp.paint);

```



```
__bind = function(fn, me){
    return function(){
        return fn.apply(me, arguments);
    };
};


function myapp(){
    this.color = "green";
    //这里的this是myapp
    this.paint = __bind(this.paint, this); 
}


myapp.prototype.paint = function(node){
    node.style.color = this.color;
}


var findNodes = function(callback){
    var node = document.getElementById("xx");
    if(typeof callback === "function"){
        callback(node);
    }
}


var myappInstance = new myapp();
findNodes(myappInstance.paint);
```





ES5为所有的Function对象引入一个新的`bind`方法，它实现下面的行为：

```
var myapp = {};
myapp.color = "green";
myapp.paint = function(node){
    node.style.color = this.color;
}


var findNodes = function(callback, callback_obj){

    var node = document.getElementById("xx");

    if(typeof callback === "function"){
        // fn = callback.bind(callback_obj);
        // fn(node);
        callback.bind(callback_obj)(node);
    }
}


findNodes(myapp.paint, myapp);
```


比较下两者用法：

```
var __bind = function(func, thisValue) {
    return function() {
        return func.apply(thisValue, arguments);
    }
}


var person = {
    name: "Alex Russell",
    hello: function() { 
    	console.log(this.name + " says hello world"); 
    }
}


// $("#some-div").click(person.hello.bind(person));
$("#some-div").click(__bind(person.hello, person));

```





### 返回函数

```
var setup = function () {
    alert(1);
    return function () {
        alert(2);
    };
};

var my = setup(); // alerts 1
my(); // alerts 2
```

```
var setup = function () {
    var count = 0;
    return function () {
        return (count += 1);
    };
};

var next = setup();
next(); // returns 1
next(); // 2
next(); // 3
```





### 自定义函数

```
var scareMe = function () {
    alert("Boo!");
    scareMe = function () {
        alert("Double boo!");
    };
};

scareMe(); // Boo!
scareMe(); // Double boo!
```


也叫“惰性函数定义”(lazy funciton definition)，因为该函数直到第一次使用时才被正确定义，而且其具有后向惰性，执行了更少的工作。

使用场景：当你的函数有一些初始化准备工作要做，并且仅需执行一次，自定义函数(self-defining funciton)可以更新自身的实现。

优点：
可提升程序性能，因为重新定义的函数仅执行更少的工作。

缺点：
1、重新定义自身时，已添加到原始函数的任何属性都会丢失；
2、如果函数使用了不同的名称（比如分配给不同的变量，或者以对象的方法来使用），那么重定义部分将永远不会发生，并且将会执行原始函数体。

```
var scareMe = function () {
    alert("Boo!");
    scareMe = function () {
        alert("Double boo!");
    };
};


//添加一个新的属性
scareMe.property = "properly";


// 赋值给一个不同的变量
var prank = scareMe;


// 作为一个方法使用
var spooky = {
    boo : scareMe
}


prank(); // Boo!
prank(); // Boo!
console.log(prank.property);//properly


spooky.boo(); // Boo!
spooky.boo(); // Boo!
console.log(spooky.boo.property);//properly


scareMe(); // Boo!
scareMe(); // Double boo!
console.log(scareMe.property);//undefined
```


注意以下情况：

```
var scareMe = function () {
    alert("Boo!");
    scareMe = function () {
        alert("Double boo!");
    };
};


//添加一个新的属性
scareMe.property = "properly";


// 赋值给一个不同的变量
var prank = scareMe;
prank(); // Boo!
prank(); // Boo!
console.log(prank.property);//properly


// 作为一个方法使用
var spooky = {
    boo : scareMe  //这个时候的scareMe经过上面prank()执行过后，是自身的更新函数了
}

spooky.boo(); // Double boo!
spooky.boo(); // Double boo!
console.log(spooky.boo.property);//undefined


scareMe(); // Double boo!
scareMe(); // Double boo!
console.log(scareMe.property);//undefined
```



### 即时函数模式(Immediate Function pattern)

两种写法：

```
(function () {
    alert('watch out!');
}());


(function () {
    alert('watch out!');
})();
```

作用：初始化代码提供了一个作用域沙箱(sandbox)。

使用场景：页面加载时，需要一些初始化工作，而且仅需要执行一次，没有理由去创建一个可复用的命名函数。但是代码也需要一些临时变量，初始化阶段完成后就不需要了。以全局变量形式创建变量是一个差劲的方式。这时候，即时函数就可以派上用场了，我们将所有代码包装到它的局部作用域，且不会将任何变量泄露到全局作用域中。

```
(function () {
    var days = ['Sun', 'Mon', 'Tue', 'Wed', 'Thu', 'Fri', 'Sat'],
        today = new Date(),
        msg = 'Today is ' + days[today.getDay()] + ', ' + today.getDate();
    alert(msg); //Today is Tue, 26
}());
```

可以将参数传到即时函数中：

```
(function (who, when) {
    console.log("I met " + who + " on " + when);
}("Joe Black", new Date()));
//I met Joe Black on Tue Nov 26 2013 10:32:50 GMT+0800 (中国标准时间)
```

一般情况下，全局对象是以参数的方式传递给及时函数，以便于在不使用window指定全局作用域限定的情况下可以在函数内部方位该对象，这样使得代码在浏览器环境之外时具有更好的互操作性。

```
(function (global) {
    // access the global object via `global`
}(this));
```


即时函数的返回值：

```
//返回一个数值
var result = (function(){
    return 2 + 2;
}());


//另一种方式忽略包装函数的括号，因为将及时函数的返回值分配给一个变量时并不需要这些括号
var result = function(){
    return 2 + 2;
}();


//返回一个函数
var getResult = (function(){
    var res = 2 + 2;
    return function(){
        return res;
    };
}());
console.log(getResult);  //getResult是一个函数
/*
function (){
    return res;
}
*/
console.log(getResult());  //4


//当定义对象属性也可以用即时函数
//场景：需要定义一个对象在生命周期内永远不会改变的属性，但是在定义之前需要执行一些工作以找出正确的值，
//此时，使用即时函数包装这些工作，返回值将会成为属性值
var o = {
    message : (function(){
        var who = "me",
            what = "call";
        return what + " " + who;
    }()),
    getMsg : function(){
        return this.message;
    }
};

console.log(o.getMsg()); //call me
console.log(o.message); //call me
```


### 即时对象初始化
保护全局作用域的：
- **即时函数模式**(Immediate Function pattern)
- **即时对象初始化**(immediate object initialization)
  使用带有init( )方法的对象，该方法在对象创建后立即执行，init( )函数负责所有的初始化任务。

以下两种写法都可以：

```
({...}).init();
({...}.init());
```


下面是即时对象模式的一个栗子：

```
({
    // here you can define setting values
    // a.k.a. configuration constants
    maxwidth: 600,
    maxheight: 400,
    // you can also define utility methods
    gimmeMax: function () {
        return this.maxwidth + "x" + this.maxheight;
    },
    // initialize
    init: function () {
        console.log(this.gimmeMax());
        // more init tasks...
    }
}).init();
```



优点：
1、执行一次性的初始化任务时保护全局命名空间
2、使整个初始化过程更有结构化

缺点：
压缩问题，私有属性和方法不会被重命名为更短的名称。

注意：
这种模式只适用于一次性任务，之后没有对该对象的访问。如果要的话，可以在`init( )`尾部添加 `return this;`。





### 初始化时分支(Init-time branching)
也称为加载时分支(load-time branching)，是一种一种优化模式。
当知道某个条件在整个程序声明周期内都不会发生改变的时候，仅对该条件测试一次是很有意义的。

此段代码效率低下，每次调用`utils.addListenter( )` 或者 `utils.removeListener( )` 都会重复地执行相同的查:

```
// BEFORE
var utils = {
    addListener: function (el, type, fn) {
        if (typeof window.addEventListener === 'function') {
            el.addEventListener(type, fn, false);
        } else if (typeof document.attachEvent === 'function') { // IE
            el.attachEvent('on' + type, fn);
        } else { // older browsers
            el['on' + type] = fn;
        }
    },
    removeListener: function (el, type, fn) {
        // pretty much the same...
    }
};
```


解决方式：
使用初始化时分支，在脚本初始化加载时一次性嗅探出浏览器特称

```
// AFTER
// the interface
var utils = {
    addListener: null,
    removeListener: null
};
// the implementation
if (typeof window.addEventListener === 'function') {
    utils.addListener = function (el, type, fn) {
        el.addEventListener(type, fn, false);
    };
    utils.removeListener = function (el, type, fn) {
        el.removeEventListener(type, fn, false);
    };
} else if (typeof document.attachEvent === 'function') { // IE
    utils.addListener = function (el, type, fn) {
        el.attachEvent('on' + type, fn);
    };
    utils.removeListener = function (el, type, fn) {
        el.detachEvent('on' + type, fn);
    };
} else { // older browsers
    utils.addListener = function (el, type, fn) {
        el['on' + type] = fn;
    };
    utils.removeListener = function (el, type, fn) {
        el['on' + type] = null;
    };
}
```


### 函数属性——备忘模式

给函数添加自定义属性，缓存函数结果，那么在下一次调用函数时，如果缓存在，就直接从缓存中取结果。就不用再做重复的繁琐的计算。

```
var myFunc = function (param) {
    if (!myFunc.cache[param]) {
        var result = {};
        // ... expensive operation ...
        myFunc.cache[param] = result;
    }
    return myFunc.cache[param];
};
// cache storage
myFunc.cache = {};
```

如果参数复杂，可以将其序列化，如果序列化为一个JSON字符串。
注意：在序列化过程中，对象的“标识”将会丢失，如果有两个不同的对象并且恰好都有相同的属性，这两个对象会共享同一个缓存条目。

```
var myFunc = function () {
    var cachekey = JSON.stringify(Array.prototype.slice.call(arguments)),
        result;
    if (!myFunc.cache[cachekey]) {
        result = {};
        // ... expensive operation ...
        myFunc.cache[cachekey] = result;
    }
    return myFunc.cache[cachekey];
};
// cache storage
myFunc.cache = {};
```

另一种方法使用`arguments.callee`，注意ES5不支持`arguments.callee`。

```
var myFunc = function (param) {
    var f = arguments.callee,
    result;
    if (!f.cache[param]) {
        result = {};
        // ... expensive operation ...
        f.cache[param] = result;
    }
    return f.cache[param];
};
// cache storage
myFunc.cache = {};
```



### 配置对象模式(configuration)

使用一个参数对象替代所有参数，将该参数称为conf，即配置的意思。

```
var conf = {
    username: "batman",
    first: "Bruce",
    last: "Wayne"
};
addPerson(conf);
```



### 函数调用&函数应用

函数调用 called/invoked
函数应用 applied，使用方法 `Function.prototype.apply()`来应用函数

```
//sayHi()是全局函数,可以直接调用
var sayHi = function(who){
    return "Hello" + (who ? ", " + who : "") + "!";
}


//函数调用（called or invoked）
console.log(sayHi());  //Hello!
console.log(sayHi("kathy"));  //Hello, kathy!


//函数应用（applied），使用方法Function.prototype.apply()
//第一个参数 - 将要绑定到该函数内部this的一个对象，如果为null，this-->全局对象
//第二个参数 - 一个数组或多个参数变量，这些参数将变成可用于该函数内部的类似数组的arguments对象
console.log(sayHi.apply(null, ["kathy"])); //Hello, kathy!
```




第一个`apply()`传递alien引用，内部的this指向alien对象，this.age是alien的age
第二个`apply()`传递null引用，内部的this指向全局对象，this.age是全局的age

```
//sayHi()是一个对象的方法，必须通过改对象调用
var age = 20;
var alien = {
    age : 15,
    sayHi : function(who){
        return "Hello" + (who ? ", " + who : "") + "! And you're " + this.age + " year's old ?";
    }
};


console.log(alien.sayHi("xuxuan")); //Hello, xuxuan! 
console.log(alien.sayHi.apply(alien,["xuxuan"]));  //Hello, xuxuan! And you're 15 year's old ?
console.log(alien.sayHi.apply(null,["xuxuan"]));  //Hello, xuxuan! And you're 20 year's old ?


console.log(sayHi("xuxuan"));    //报错：sayHi未定义
console.log(sayHi.apply(alien,["xuxuan"])); //报错：sayHi未定义
console.log(sayHi.apply(null,["xuxuan"]));  //报错：sayHi未定义
```




注意`call`和`apply`的区别：
`Function.prototype.call`是建立在`apply`上的“语法糖”(syntax sugar): 当函数只有一个参数时，可以根据实际情况避免创建只有一个元素的数组。

```
//sayHi()是一个构造函数里的方法，必须通过实例调用
var age = 20;
var Alien = function(){
    this.age = 15;
    this.sayHi = function(who){
        return "Hello" + (who ? ", " + who : "") + "! And you're " + this.age + " year's old ?";
    };
};


var alien = new Alien();
console.log(alien.sayHi("xuxuan")); //Hello, xuxuan! And you're 15 year's old ?
console.log(alien.sayHi.apply(alien,["xuxuan"]));  //Hello, xuxuan! And you're 15 year's old ?
console.log(alien.sayHi.apply(null,["xuxuan"]));  //Hello, xuxuan! And you're 20 year's old ?


console.log(alien.sayHi.call(alien,"xuxuan")); //Hello, xuxuan! And you're 15 year's old ?
console.log(alien.sayHi.call(null,"xuxuan"));  //Hello, xuxuan! And you're 20 year's old ?
```




### 部分应用（partial application）

部分应用向我们提供了另一个函数，随后再以其他参数调用该函数。
假想的partialApply()方法：

```
var add = function(x, y){
    return x + y;
}

//完全应用
add.apply(null, [5,4]);  //9

//部分应用
var newadd = add.partialApply(null,[5]);

//应用一个参数到函数中
newadd.apply(null,[4]);  //9
```

事实上，js没有partialApply()方法，默认也不会表现出上述类似行为。但是可以构造出这种行为，成为`Curry`过程。



### Curry化

```
function add(x, y){
    var oldx = x, oldy = y;
    //部分
    if(typeof oldy === "undefined"){
        return function(newly){
            return oldx + newly;
        }
    }
    //完全应用
    return x + y;
}


console.log(typeof add(5)); //function
console.log(add(3)(4));  //7


//add2000是一个新函数
var add2000 = add(2000);
console.log(add2000(13));  //2013
```

更为精简的实现版本:

```
function add(x, y){
    //部分应用
    if(typeof y === "undefined"){
        return function(y){
            return x + y;
        }
    }
    //完全应用
    return x + y;
}
```


更通用的方式，将任意函数转换成一个新的可以接受部分参数的函数:

```
function schonfinkelize(fn){
    var slice = Array.prototype.slice,
        stored_args = slice.call(arguments, 1);
    return function(){
        var new_args = slice.call(arguments),
            args = stored_args.concat(new_args);
        return fn.apply(null, args);
    };
}


//普通函数
function add(x, y){
    return x + y;
}


//将一个函数curry化以获得一个新的函数
var newadd = schonfinkelize(add, 5);
console.log(newadd(4));  //9


//另一种用法————直接调用新函数
console.log(schonfinkelize(add,5)(4)); //9


//---------------------------------------------------------------


//普通函数
function add2(a, b, c, d, e){
    return a + b + c + d + e;
}


//两步curry化
var addOne = schonfinkelize(add2, 1);
console.log(addOne(10, 10, 10, 10));  //41


var addTow = schonfinkelize(addOne, 2, 3);  //addOne函数只用传递4个参数
console.log(addTow(5,5));  //16


//可运行于任意数量的参数
console.log(schonfinkelize(add2, 1, 2, 3)(5, 5));  //16
```

curry使用场景：

- 调用同一个函数，并且传递的参数绝大多数是相同的。
- 通过将一个函数集合部分应用到函数中，从而动态创建一个新函数。这个新函数会保存重复的参数（所以，不用每次都传这些重复的参数），而且还会使用预填充原始函数所期望的完整参数列表。



