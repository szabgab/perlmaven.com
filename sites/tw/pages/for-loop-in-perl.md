---
title: "Perl 的 for 迴圈"
timestamp: 2013-05-29T09:07:00
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
translator: gugod
---


在本篇[Perl 教學](/perl-tutorial)中，我們要來看看<b>Perl 的 for 迴圈</b>。
有人稱之是 <b>C 語言風味的 for 迴圈</b>，不過，其實相似的語法結構在其他程式語言也多有出現。


## Perl 的 for 關鍵字

在 Perl 語言中，<b>for</b> 關鍵字有兩種用法。其一是與 <b>foreach</b> 完全相同，其
二則像 C 語言語法、有四項重要的部份。雖然在許多語言中都有同樣的結果，卻依然被稱為
C 語言風味。

關於此點，以下我會完整地描述。我比較偏好使用`foreach`風格的用法，
在 [Perl 陣列](https://perlmaven.com/perl-arrays) 一文中另述。

在 Perl 語言裡，`for` 與 `foreach` 這兩個關鍵字算是同義，就算
搞混了，perl 也多半不太在意。

所謂 <b>C 語言風味 for 迴圈</b>，整體由四個項目構成，在其控制迴圈的部份有三個部
份。雖然每部份皆可組略，但大體如下：

```perl
for (初始; 測試; 步進) {
  本文;
}
```

實例如：

```perl
for (my $i=0; $i <= 9; $i++) {
   print "$i\n";
}
```

「初始」的部份，在程式執行到迴圈開頭時，會執行一次。

緊接著，「測試」的部份也會執行。如果得到偽值，那迴圈本文就會被略過。如果得到真值，
那就會執行「本文」的部份，最後再接著執行「步進」的部份。

（關於真偽值的說明，請參閱[Perl 的布林值](/boolean-values-in-perl)一文。）

然後又會從「則試」開始反覆，並且持繼進行到「測試」不再得到真值為止。如果一步步展開來看的話，就有點像：


```
測試

測試
本文
步進

測試
本文
步進

...

測試
```

## foreach

前例的迴圈是從 0 走到 9，也可以改寫成 <b>foreach loop</b>，我個人認為這種寫法更容易被理解：

```perl
foreach my $i (0..9) {
  print "$i\n";
}
```

之前提到，`for` 跟 `foreach` 基本上是同義，所以也有人用 <b>foreach 風格</b>
來寫 for 迴圈：

```perl
for my $i (0..9) {
  print "$i\n";
}
```

## for 迴圈各部份解說

「初始」部份，顧名思義，多半是用來初始一些變數。這部份只會執行一次。

「測試」，則是某種能得出布林值的運算式，用來判別迴圈是否應該繼續進行。這部份至少
會執行一次。「測試」的執行次數，必定會被「本文」或「步進」還要多一次。

「本文」則是由許多陳述式所構成，通常，有些式子需要重複執行的時候，就該寫成迴圈。
不過迴圈本文全部空著也未嘗不可。不過，慣例上來說，碰到這類狀況時也許會稍微改良一
下。

「步進」則是另一組式子，通常會遞增某個變數，或遞減某個變數。這部份也可以留白，視
情況，有時也可能會寫在「本文」之中。

## 無限迴圈

用 <b>for loop</b> 弄出無限迴圈的方式是：

```perl
for (;;) {
  # 做點什麼吧
}
```

許多人是用 `while` 來做出無限迴圈：

```perl
while (1) {
  # 做點什麼吧
}
```

這部份請參閱[Perl 的 while 迴圈](https://perlmaven.com/while-loop)。

## perldoc

關於 for 迴圈的官方文件，可見於 [Perl 文件](http://perldoc.perl.org/perlsyn.html#For-Loops)的 <b>perlsync</b> 一節之中。

