---
title: "使用内置Perl调试器"
timestamp: 2013-04-29T19:45:56
tags:
  - debugger
  - -d
  - debug
  - screencast
published: true
original: using-the-built-in-debugger-of-perl
author: szabgab
translator: herolee
---


这个新的屏幕录像是讲[使用Perl内置的调试器](http://www.youtube.com/watch?v=jiYZcV3khdY).
我曾在各种Perl专题会和研讨会上谈到过这个，但是总还有很多人从没有使用过调试器。希望这能帮助更多的人开始使用它。


<iframe width="640" height="480" src="http://www.youtube.com/embed/jiYZcV3khdY"
frameborder="0" allowfullscreen></iframe>

运行调试器：

perl -d yourscript.pl param param

视频中提到的调试器指令有：

q - 退出

h - 显示帮助

p - 打印

s - 单步进入

n - 单步执行

r - 单步跳出

T - 堆栈跟踪

l - 显示代码

建议也可以读一下Richard Foley和Andy Lester的大作: [Pro Perl Debugging](http://www.apress.com/9781590594544)

