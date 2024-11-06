---
title: "Perl 陣列的排序"
timestamp: 2013-05-22T09:02:00
tags:
  - sort
  - $a
  - $b
  - cmp
  - <=>
published: true
original: sorting-arrays-in-perl
books:
  - beginner
author: szabgab
translator: gugod
---


這篇文章將描述在 Perl 程式中<b>如何排序數字陣列或字串陣列</b>。

Perl 的內建序式 `sort` 可以直接排序陣列，這不另人意外。而其最簡明的使用形式，便是傳入一個陣列，它好會傳回排好的新陣列：`@sorted = sort @original`。


## 依 ASCII 次序來排

```perl
#!/usr/bin/perl
use strict;
use warnings;
use 5.010;

use Data::Dumper qw(Dumper);

my @words = qw(foo bar zorg moo);

say Dumper \@words;

my @sorted_words = sort @words;

say Dumper \@sorted_words;
```


前例程式的輸出如下：

```perl
$VAR1 = [
        'foo',
        'bar',
        'zorg',
        'moo'
      ];

$VAR1 = [
        'bar',
        'foo',
        'moo',
        'zorg'
      ];
```

第一段，是陣列內容在還未排序之前的結果，第二段則是排好之後的結果。

這是最簡單的使用形式，不過未必能達到想要的效果。如果某些單字的字首大寫的話，要怎麼排？

```perl
my @words = qw(foo bar Zorg moo);
```

`@sorted_words` 的結果會變成：

```perl
$VAR1 = [
        'Zorg',
        'bar',
        'foo',
        'moo'
      ];
```

如例所示，由大寫字母開頭的字被排到第一位了。那是因為，`sort` 的預設次序是
依 ASCII 表格順，而在那表個中，所有大寫字母都在小寫字母之前的緣故。

## 比較函式

Perl 中 `sort` 函式的運作原理是，它會一一取出原陣列的元素，兩兩一組，左方
為 `$a`、右方為 `$b`。接著呼叫<b>比較函式</b>。這個「比較函式」，應
去比較 `$a` 與 `$b` 的內容，若 `$a` 應該排在左邊，則傳回 1，
如果 `$b` 應被排在左邊，則傳回 -1，而若兩者的次序前後無所謂的話，則傳回 0。

如果看到程式碼中的 <b>sort</b> 函式後面沒帶上這個比較函式的話，那就表示使用預設的
ASCII 表格順序來排，明確寫出來的話如下：

```perl
sort { $a cmp $b } @words;
```

跟省略函式區塊的 `sort @words` 寫法同義。

這樣看來，Perl 預設的比較函式裡，也使用了 `cmp`。恰巧因為，cmp 的作用就是
比較兩邊的字串，如果左邊「小於」右邊，那就傳回 1，如果左邊「比較大」，那就傳回 0，
而如果兩邊相同，就傳回 0。

## 依字母表的次序來排

如果要依照字母表的次序來排，那就是在排序時不要計較字母大小寫的不同，如下所示：

```perl
my @sorted_words = sort { lc($a) cmp lc($b) } @words;
```

在範例中，為了讓比較函式達到想要的效果，使用了 `lc` 函式。這函式會傳回其參
數`轉換成小寫`之後的樣子。而讓 `cmp` 所比較的的兩方，都是轉成的小寫
字串。

結果如下：

```perl
$VAR1 = [
        'bar',
        'foo',
        'moo',
        'Zorg'
      ];
```

## Perl 中依數字大小排序的方法

如果直接用預設的排序法來排數字陣列的話，會讓人覺得大錯特錯。

```perl
my @numbers = (14, 3, 12, 2, 23);
my @sorted_numbers = sort @numbers;
say Dumper \@sorted_numbers;
```


```perl
$VAR1 = [
        12,
        14,
        2,
        23,
        3
      ];
```

但仔細端詳，其實這是很有條理的。預設的比較函式在拿到 12 與 3 的時後，是把兩者當成字串在比較。也就是說，兩方的第一個
字符也先被拿出來比，是 "1" 對 "3"。在 ASCII 表格中， "1" 在 "3" 前面，所以 "12" 當然就會被排在 "3" 前面了。

這也表示，Perl 沒有辨法猜中這時要被排序的是一群數字。

這也無妨，只要另外提供個比較函式來正確地比較數值就行了。為此目的，可以使用 `<=>`，亦稱
[太空船算符](http://en.wikipedia.org/wiki/Spaceship_operator)，此算符
能比較左右兩數值，並得出 1、-1 或 0。

```perl
my @sorted_numbers = sort { $a <=> $b } @numbers;
```

結果如：

```perl
$VAR1 = [
        2,
        3,
        12,
        14,
        23
      ];
```


