---
layout:     post
title:      "macbook通ssh代理来访问受限的git服务"
subtitle:   "通过有权限的代理服务器提交git"
date:       2015-10-25
author:     "楚爷"
header-img: "img/post-bg-os-metro.jpg"
tags:
    - ssh proxy
    - git proxy
---

#先安装proxychains-ng:

`brew install proxychains-ng`

#然后将公钥上传到服务器, 并在~/.ssh下建立authorized_keys文件，进行免登陆处理

`cat id_rsa.pub >> authorized_keys`

#本地编辑

`vim ~/.ssh/config`

#代理服务器

```
Host proxyvm

        HostName 192.168.8.7

        IdentityFile ~/.ssh/id_rsa

        User ubuntu

        Port 22
```

#git服务器

```
Host 192.168.9.9

        HostName 192.168.9.9

        IdentityFile ~/.ssh/id_rsa

        User git

        ProxyCommand ssh proxyvm -W %h:%p
```

保存
现在可以通过
`git clone git@192.168.9.9:pro.git`
clone工程和提交了。
