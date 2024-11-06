---
title: "for 循环"
timestamp: 2013-04-19T13:46:13
tags:
  - for
  - foreach
  - loop
  - infinite loop
published: true
original: for-loop-in-perl
books:
  - beginner
author: szabgab
translator: swuecho
---


本节[Perl 教程](/perl-tutorial)我们学习 Perl 中的 for 循环，其写法与 C 中的 for 循环类似。


## for 循环

Perl 中的关键词 <b>for</b> 有用法有两种情况，第一，可以当作 <b>foreach</b>  来使用，
第二种用法，与C 中的 for 循环类似。

第一种情况，我倾向于用 `foreach` ，比如在 [perl 数组](/perl-arrays)那一节中。

事实上，在这种情况下，`foreach` 和 `for` 是等价的。


第二种情况，即C 风格的用法。控制部分有三部分。加上循环体，一共四部分。
通常的写法如下，尽管省略任何一部分都是合法的。


```perl
for (INITIALIZE; TEST; STEP) {
  BODY;
}
```

更具体的例子：

```perl
for (my $i=0; $i <= 9; $i++) {
   print "$i\n";
}
```

我们看下，for 循环的执行过程。
首先，INITIALIZE 部分执行，注意，整个for 循环中 INITIALIZE 只执行一次。然后是 TEST 部分。如果 TEST 结果为 false，整个循环结束。
否则，STEP 部分执行，接下来才是 BODY 部分。

(关于Perl 中的 false 和 true， 请参考 [Perl 中的布尔值](/boolean-values-in-perl).)

然后，这个 for 循环又回到 TEST 部分，重新开始循环。

这个过程为：

```
INITIALIZE

TEST
BODY
STEP

TEST
BODY
STEP

...

TEST
```


## foreach


上个例子中的循环也可以用  <b>foreach loop</b> 来写。

```perl
foreach my $i (0..9) {
  print "$i\n";
}
```


因为`for` 和 <b>foreach</b>  在这种情况下等价。所以，也可以这样写：

```perl
for my $i (0..9) {
  print "$i\n";
}
```

## for 循环剖析

INITIALIZE 是初始，仅执行一次，就完成了其使命。

TEST 的作用就是判断循环是否应该终止，循环一直执行，知道 TEST 的结果为 false。

BODY 部分，即循环体。通常由一个或者多个语句构成。尽管循环体没有任何语句也是合法的，
但是一般用不到那种写法。

STEP 通常是 在初始值的基础上增或者减。不过，你也可以把 STEP 部分写到循环体中。

## 无限循环


如果你想写一个无限循环，可以这样写：

```perl
for (;;) {
  # do something
}
```

不过，更好的写法是用  `while`

```perl
while (1) {
  # do something
}
```

请参考 [while 循环](/while-loop).

## perldoc

关于 for 循环更详细的介绍请参考[Perl 官方文档](http://perldoc.perl.org/perlsyn.html#For-Loops) 的 <b>perlsyn</b> 部分。



