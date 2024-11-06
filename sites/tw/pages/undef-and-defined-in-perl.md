---
title: "undef、初始值、以及 defined 函式"
timestamp: 2013-04-10T21:45:56
tags:
  - undef
  - defined
published: true
original: undef-and-defined-in-perl
books:
  - beginner
author: szabgab
translator: gugod
---


各程式語言多半有特殊的方式來表達「此處沒有值」的概念。在 <b>SQL</b>、<b>PHP</b>、
<b>Java</b> 裡，是 `NULL`，在 <b>Python</b> 為 `None`，
在 <b>Ruby</b> 則為 `Nil`。

而在 Perl 裡，則是 `undef`。

細節分曉如後。


## undef 從何而來？

在宣告純量變數時，如果沒有即時賦值，那就表示這個變數的內容定為 `undef`。

```perl
my $x;
```

有些函式，以傳回 `undef` 來表示某種錯誤發生。而另外有些函式則用此招來表示沒有傳回值。

```perl
my $x = do_something();
```

另外還有個 `undef()` 函式，可將變數的值改成 `undef`：

```perl
undef $x;
```

也可以把 `undef()` 函式的傳回值，賦予某個變數，這麼一來該變數的值也會變成 `undef`：

```perl
$x = undef;
```

函數後頭的小括號可以省略，因此在範例中一律不出現。

如前各例，要將變數的值改成 <b>undef</b>，有好幾種方式。不過真正問題在於，如果
程式碼中對此值進行了運算，那會發生甚麼事？

在談論到這點之前，先離題看點別的：

## 如何檢查某個值或變數等於 undef？

使用 `defined()` 這個函式，如果傳入的參數<b>不等於 undef</b>，便會傳
回 [true](/boolean-values-in-perl)。反之，則會傳回 [false](/boolean-values-in-perl)。

使用範列如下：

```perl
use strict;
use warnings;
use 5.010;

my $x;

# 假設這裡有段程式碼，可能會改到 $x 的值

if (defined $x) {
    say '$x is defined';
} else {
    say '$x is undef';
}
```


## 所以， undef 真正代表的值是什麼呢？

雖然 <b>undef</b> 基本上表示沒有值，但並非不能拿來運算。Perl 算符在碰到 undef 值
時，提供兩種不同的運算用的預設值。

如果某個數值運算中用到的變數，其值為 undef，可視其為 0。

如果在字串運算中與到了 undef，則視其為空字串。

例如：

```perl
use strict;
use warnings;
use 5.010;

my $x;
say $x + 4, ;  # 4
say 'Foo' . $x . 'Bar' ;  # FooBar

$x++;
say $x; # 1
```

在前例中，變數 $x 的預設值為 undef，但在之後的加法運算（+）裡，其作用與 0 相同。
而在之後的字串接續算式（.）裡，則變身為空字串。最後又有一次遞加運算（++），再次以 0 取代。

但這機制並非無瑕。如果在程式中寫了 `use warnings`，啟用警告機制
（[強力推薦使用](https://perlmaven.com/installing-perl-and-getting-started)），那麼在執行程
式時會印出兩次「<a href="https://perlmaven.com/use-of-uninitialized-value">use of unitialized
value</a>」警告訊息，不過最後一次的遞加運算不會有警告。

```
Use of uninitialized value $x in addition (+) at ... line 6.
Use of uninitialized value $x in concatenation (.) or string at ... line 7.
```

這麼看來遞加算符似乎比較寬恕一些。在其他篇章可以看到，在進行計數時，這樣的特性會讓使事情變得很方便。

當然，也可以在變數宣告時就賦予初始值（0 或空字串，視情況而定），或著視不同時機關掉警告機制。在其他篇章另述。
