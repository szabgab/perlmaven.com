---
title: "Perl 的布林值"
timestamp: 2013-04-16T19:47:56
tags:
  - undef
  - true
  - false
  - boolean
published: true
original: boolean-values-in-perl
books:
  - beginner
author: szabgab
translator: shelling
---


Perl 沒有特定的布林值，但在 Perl 的文件中你經常會看到函數回傳「布林」值。
有時候這文件會說函式回傳真值或是假值。

哪個才是對的？


Perl 確實沒有特定的布林型別，但凡純量皆是 — 如果用 if 來確認，非真值即假值。所以你可以寫

```perl
if ($x eq "foo") {
}
```

你也可以寫

```perl
if ($x) {
}
```

前者會確認 $x 變數的內容是否和 "foo" 字串一致
後者則會確認 $x 本身是真值或否。

## 哪些值在 Perl 裡是真值，哪些是假值？

這相當簡單。讓我引述一下文件：

<pre>
數字 0，字串 '0'，和 ''，空串列 ()，和 undef 在布林語境都是假值。其他值都是真值。
用 ! 和 not 來否定一個真值會回傳一個特別的假值。
當被估算為字串時它被當作 ''，估算為數字時，，被當作 0。

引自 perlsyn 的 "Truth and Falsehood" 一節。
</pre>

所以下列純量被認為是假值。

* undef — 未定義值
* 0 — 數字 0，無論你寫成 000 或是 0.0
* '' — 空字串
* '0' — 只包含一個羅馬數字 0 的字串

所有其他純量，包含下列，都是真值：

* 1 和任何非零數
* ' ' — 包含一個空白的字串
* '00' — 兩個或許多數字零組成的字串
* "0\n" — 一個數字零接上一個換行字元
* 'true'
* 'false' — 是的，即使字串 'false' 也是真值

我想這是因為 Perl 之父，[Larry Wall](http://www.wall.org/~larry/)，
有相當正向的世界觀。
他也許覺得世界上只有很少事情是很糟糕錯誤的。
大部分事情都是對的。
