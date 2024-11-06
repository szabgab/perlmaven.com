---
title: "Perl 中的时间 "
timestamp: 2013-04-04T12:45:18
tags:
  - time
  - localtime
  - gmtime
  - Time::HiRes
  - DateTime
published: true
original: the-year-19100
books:
  - beginner
author: szabgab
translator: swuecho
---


作为[Perl 教程](/perl-tutorial)的一部分，本节学习<b>Perl 中时间处理</b>。

Perl中，函数`time()` 返回一个10位数，代表1970年1月1日起，到现在的秒数。


```perl
$t = time();         # returns a number like this: 1021924103
```


你可以把这个函数当作时间戳，比如，你可以在不同的地方调用这个函数，然后根据返回值得出消逝的时间（秒数）。

```perl
my $t = time();
# lots of code
say 'Elapsed time: ', (time() - $t);
```

## localtime

另外一个函数 `localtime()` 可以把函数`time()` 的返回值转换成容易识别的格式。

```perl
my $then = localtime($t);  # returns a string such as       Thu Feb 30 14:15:53 1998
```

其实，`localtime()` 并不是一定要有参数，如果没有参数，它自己默认调用`time()`。

比如：

```perl
my $now = localtime();    # returns the string for the current time
```


## localtime 续

如果把`localtime($t)` 赋值给一个数组，会得出怎样的结果呢？

```perl
my @then = localtime($t);
```

上述例子将会得到一个类似下面的数组：

```
53 15 14 30 1 98 4 61 0
```

这些元素代表什么呢？请看下面的例子。

```perl
my ($sec ,$min, $hour, $mday, $mon, $year, $wday, $yday, $isdst) = localtime(time);
```
```
$sec   - seconds (0-59)
$min   - minutes (0-59)
$hour  - hours  (0-23)
$mday  - 'month day' or day of the month (1-31)
$mon   - month (0-11) - 0 is January, 11 is December.
$year  - YEAR-1900
$wday  - 'weak day' or day of the week (0-6), 0 is Sunday, 1 is Monday
$yday  - 'year day' or day of the year (0-364 or 0-365 in leap years)
$isdst - 'is Daylight saving time' true if Daylight Saving Time is on in your computer. Otherwise false.
```

注意,月份是从0算起，星期几中 0 代表星期日，六代表星期六。

<b>day of the month</b> 的可能值是 1-28，30，或者 31，根据月份有所不同。

最容易迷惑人的是<b>year</b>，$year的值为代表1900 年后的年数。如果凭想当然，很容易引发“千年虫”问题。

## 千年虫

比如如果是1998年，`$year`的值是 98，所以如果你想输出 1998， 写成 `"19$year"` 就可以了。1999呢？
也没问题。2000年呢？问题来了， `"19$year"`的输出将是 19100。这就是公元 19100 的由来，千年虫问题也是这样造成的。

正确的写法是：

```
1900 + $year
```

## gmtime

函数  `gmtime()` 与 `localtime()` 类似，只不过返回的时间是格林威致时间。

## 时间函数的原理？

通常，你电脑的硬件时钟设置为格林威致时间。`gmtime()` 利用这一设置。
你的操作系统设置了你所处的时区，是否是夏时制。`localtime()` 利用硬件时钟以及这些设置。

## 精确时间

`time()`的最小单位是秒，如果你想得到更精确的时间，请参考 [Time::HiRes](https://metacpan.org/pod/Time::HiRes) 模块。

## DateTime

以上介绍的函数，可以用来完成基本的时间和日期操作，由于此问题的复杂性，更多请参考 [DateTime](https://metacpan.org/pod/DateTime) 模块。


## 上下文

你觉察到了 `localtime()` 的诡异之处了么？ 把它赋值给一个标量和一个数组，结果完全不同！

这是Perl 5 中的一个特性，也就是说，很多时候，Perl 函数根据上下文的不同，返回不同的值。以后会有更多关于此的讨论。





