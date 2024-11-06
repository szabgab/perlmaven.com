---
title: "映射表（hashes）"
timestamp: 2013-04-19T11:12:06
tags:
  - hash
  - keys
  - value
  - associative
  - "%"
  - "=>"
  - fat arrow
  - fat comma
published: true
original: perl-hashes
books:
  - beginner
author: szabgab
translator: swuecho
---



本节[Perl 教程](/perl-tutorial) 中，我们学习哈希表<b>hashes</b>。

哈希表<b>hashes</b> 在其他编程语言中，又称做关联数组，词典，或者 映射表？。

它是Perl 中基本的数据结构之一，非常有用。

哈希表是音译，本人认为 映射（表） 是更好的翻译。所以，下文中，用映射（表）。



映射是键-值对的集合。键是字符串；值是标量，可以是数字，字符串，以及引用。关于引用，我们后面会详细讲解。

映射，也是用`my`关键词来声明。映射的标志符是 `%`。

有些人认为，映射和数组很像，（映射的另一个名字就是关联数组），他们的区别主要：第一，数组是有序的，元素是按顺序索引的。
第二，映射是无序的。你通过键值对中的键，来取得值。因此，不能有重复的键。

## 声明一个映射

```perl
my %color_of;
```

## 填入键值对


```perl
$color_of{'apple'} = 'red';
```

$color_of 是映射，'apple' 是键， 'red' 是值。




```perl
my $fruit = 'apple';
$color_of{$fruit} = 'red';
```

请比较以上两个例子的区别。
如果键是一个变量，可以省略引号。

事实上，如果键是一个简单的字符串，也可以省略引号。

```perl
$color_of{apple} = 'red';
```

你可能已经注意到了，如果你想表达的是一个键值对，标志符 `$`。原因估计你猜到了， 因为表达的是单数概念。

## 读取映射中一个键值对的值

```perl
print $color_of{apple};
```


如果你所用的键不存在，映射会返回一个[undef](/undef-and-defined-in-perl)，在`warnings`启用的情况下，Perl会给你
[warning about uninitialized value](/use-of-uninitialized-value) 的警告。

```perl
print $color_of{orange};
```

增添更多键值对到映射中，

```perl
$color_of{orange} = "orange";
$color_of{grape} = "purple";
```

## 声明映射并赋值

```perl
my %color_of = (
    "apple"  => "red",
    "orange" => "orange",
    "grape"  => "purple",
);
```

`=>` 叫做 <b>胖箭头</b> 或者 <b>长逗号</b>, 用来隔开键值对的键和值。
Perl 中还有个`->`，叫做瘦箭头。

`=>` 称作长逗号的原因是，它在这里的功能，其实是和逗号`, ` 类似， 所以，上个例子也可以这样写：


```perl
my %color_of = (
    "apple",  "red",
    "orange", "orange",
    "grape",  "purple",
);
```

Actually, the fat comma allows you to leave out the quotes on the left-hand side makig the code cleaner
and more readable.

不过，`=>` 比逗号好些，因为，如果是长逗号，键的引号可以省略。

```perl
my %color_of = (
    apple  => "red",
    orange => "orange",
    grape  => "purple",
);
```

## 给键赋值

赋值改变了原有键值对的值。

```perl
$color_of{apple} = "green";
print $color_of{apple};     # green
```



## 映射的历遍

你需要知道键，然后才能读取值，如果你不知道，可以用 `keys`
函数来得到所有的键，放到数组中，然后再历遍数组即可。

```perl
my @fruits = keys %color_of;
for my $fruit (@fruits) {
    print "The color of '$fruit' is $color_of{$fruit}\n";
}
```



其实，中间变量`@fruits` 并不是必须的。

```perl
for my $fruit (keys %color_of) {
    print "The color of '$fruit' is $color_of{$fruit}\n";
}
```


## 映射的大小


映射的大小指的是映射中键-值对的数目，也就是键的数目就可以了。

```perl
print scalar keys %hash;
```

## 致谢
本文最初是[Felipe da Veiga Leprevost](http://www.leprevost.com.br/) 所写，他同时是本教程
[葡萄牙语](https://br.perlmaven.com/)的译者。



