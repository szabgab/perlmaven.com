---
title: "怎样从数组中删除某个值？"
timestamp: 2013-06-10T17:47:12
tags:
  - undef
  - splice
  - array
  - delete
published: true
original: how-to-eliminate-a-value-in-the-middle-of-an-array-in-perl
books:
  - beginner
author: szabgab
translator: terrencehan
---


先回答之前有位读者在[undef](/undef-and-defined-in-perl)文章的提问：

怎样从一个Perl数组中删除某个值？

我不确定`undef`是否和从数组中消除值有确切的关系，猜测一下，如果我们将`undef`视为"空"，那么会有一些联系。但通常来说，将某些东西赋值为`undef`和删除某些东西是不一样的。


首先来看怎样把数组的元素赋值为`undef`，之后再了解如何从数组中删除元素。

从下面的代码开始：

```perl
use Data::Dumper qw(Dumper);
my @dwarfs = qw(Doc Grumpy Happy Sleepy Sneezy Dopey Bashful);
print Dumper \@dwarfs;
```

使用`Data::Dumper`打印时，得到如下输出：

```
$VAR1 = [
          'Doc',
          'Grumpy',
          'Happy',
          'Sleepy',
          'Sneezy',
          'Dopey',
          'Bashful'
        ];
```

## 将元素赋值为undef

使用`undef()`函数的返回值：

```perl
use Data::Dumper qw(Dumper);
my @dwarfs = qw(Doc Grumpy Happy Sleepy Sneezy Dopey Bashful);

$dwarfs[3] = undef;

print Dumper \@dwarfs;
```

这些代码会把3号元素（数组中第4个元素）赋值为`undef`，但是<b>并不</b>改变数组的大小：

```
$VAR1 = [
          'Doc',
          'Grumpy',
          'Happy',
          undef,
          'Sneezy',
          'Dopey',
          'Bashful'
        ];
```

直接对数组的某个元素使用`undef()`函数也会产生相同的结果：

```perl
use Data::Dumper qw(Dumper);
my @dwarfs = qw(Doc Grumpy Happy Sleepy Sneezy Dopey Bashful);

undef $dwarfs[3];

print Dumper \@dwarfs;
```

所以，`$dwarfs[3] = undef;` 和 `undef $dwarfs[3];`的作用是一样的，它们都能把值赋成`undef`。


## 使用splice从数组移除元素

`splice`函数会从数组中彻底删除元素：

```perl
use Data::Dumper qw(Dumper);
my @dwarfs = qw(Doc Grumpy Happy Sleepy Sneezy Dopey Bashful);

splice @dwarfs, 3, 1;

print Dumper \@dwarfs;
```

```
$VAR1 = [
          'Doc',
          'Grumpy',
          'Happy',
          'Sneezy',
          'Dopey',
          'Bashful'
        ];
```

可以看到，在这个例子中，数组因为我们从数组中间<b>移除了一个元素</b>而缩短了一个单位。

这也就是怎样<b>从数组中删除一个元素</b>。

更多细节请参阅[how to splice arrays in Perl](/splice-to-slice-and-dice-arrays-in-perl)。

