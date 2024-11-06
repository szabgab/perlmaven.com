---
title: "Perl 陣列中的獨特值"
timestamp: 2013-04-24T08:42:56
tags:
  - unique
  - uniq
  - distinct
  - filter
  - grep
  - array
  - List::MoreUtils
  - duplicate
published: true
original: unique-values-in-an-array-in-perl
books:
  - beginner
author: szabgab
translator: gugod
---


在本篇 [Perl 教學中](/perl-tutorial)，我們將討論如何<b>使一陣列中只存放獨特值</b>。

Perl 5 並沒有內建函式可以移除陣列中重複的值，但這個題目有許多解決方法。


## List::MoreUtils

雖然視情況而定，但最簡單的方法多半是使
用 [List::MoreUtils](https://metacpan.org/pod/List::MoreUtils)
CPAN 模組中的 `uniq` 函式。

```perl
use List::MoreUtils qw(uniq);

my @words = qw(foo bar baz foo zorg baz);
my @unique_words = uniq @words;
```

A full example is this:

以下是較完整的範例：

```perl
use strict;
use warnings;
use 5.010;

use List::MoreUtils qw(uniq);
use Data::Dumper qw(Dumper);

my @words = qw(foo bar baz foo zorg baz);

my @unique_words = uniq @words;

say Dumper \@unique_words;
```

輸出的結果為：

```
$VAR1 = [
        'foo',
        'bar',
        'baz',
        'zorg'
      ];
```

此模組另外也提供了 `distinct` 函式，但與 `uniq` 作用完全相同，只是
名稱不同。

而此模組必需先自 CPAN 安裝之後才能使用。

## 手作 uniq 函式

如果因故無法安裝上述模組，或認為載入此模組太耗資源，那麼以下的算式基本上也可以達到
一樣的功能：

```perl
my @unique = do { my %seen; grep { !$seen{$_}++ } @data };
```

不過，對於不熟悉的人來說，這列算式可能會看得一頭霧水，所以最好還是定義成函式 `uniq`，
並且在源碼各處直接使用函式：

```perl
use strict;
use warnings;
use 5.010;

use Data::Dumper qw(Dumper);

my @words = qw(foo bar baz foo zorg baz);

my @unique = uniq( @words );

say Dumper \@unique_words;

sub uniq {
  my %seen;
  return grep { !$seen{$_}++ } @_;
}
```

## 抽絲剝繭

即然把範例程式丟出來了，便不能不解釋一下。先來看看較簡易的版本：

```perl
my @unique;
my %seen;

foreach my $value (@words) {
  if (! $seen{$value}) {
    push @unique, $value;
    $seen{$value} = 1;
  }
}
```

此例中，我們採用普通的 `foreach` 迴圈，一一走過原陣列各值。其中另外引入了小幫手 `%seen`
雜湊。雜湊有個不錯的特性：每個雜湊鍵都是 <b>獨特的</b>。

一開始時，雜湊是空的，在迴圈內碰到第一個 "foo" 時，`$seen{"foo"}`尚未存在，
因此其值為 `undef`，在 Perl 語言中表意為布林偽值。在範例程式用以表示「尚未
看過 "foo"」這樣的意義。接著程式將它推入另一個陣列 `@unique`陣列，此陣列的
用處，便是收藏所有獨特值。

同時，`$seen{"foo"}` 的值也被賦為 1。不過，任何能被 Perl 語言當成是布林真值的值，都可以使用。

於是，如果之後又碰到曾經出現過的值，那麼它就會出現在 `%seen` 雜湊鍵中，並且對應到一個布林真值，
也就是說 `if` 中的條件就會變成失敗，之後的 `push` 就不會執行，這個曾經出現的值就不會
再次被推入要回傳的陣列當中。

## 精練簡化

首先，我們將賦值算式 `$seen{$value} = 1;` 改為「後遞增」算式 `$seen{$value}++`。這並不會
改變整體的行為，因為所有正數都會被當成是布林真值，但這麼做，可以讓我們把此運算放在 `if` 的測試條件當中。
此處的重點在於它為「後遞增」算符，而不是「前遞增」算符，也就是讓遞增運算在取值之後發生。這個運算式第一次被取值時
會是真，而之後都會是偽。

```perl
my @unique;
my %seen;

foreach my $value (@data) {
  if (! $seen{$value}++ ) {
    push @unique, $value;
  }
}
```

這樣稍微簡短了一些，但還可以再改進。

## 以 grep 來過濾重複出現的值

在 Perl 中的 `grep` 函式，形式上比 Unix grep 指令更為通用。

它基本上就是個[濾器](/filtering-values-with-perl-grep)。
在其右方，要提供一個陣列與一個程式區塊，並在其區塊中填上一條運算式。`grep`函式會一一走過陣列中的內容，
放入 `$_` 變數，也就是 [Perl 的預設純量變數](/the-default-variable-of-perl)，
然後執行區塊。如果區塊的執行結果為真，則此值就會通過濾器，跑到左邊；如果區塊執行結果是偽，那就會被擋下來。

於此，我們被能造出了如下的運算式：

```perl
my %seen;
my @unique = grep { !$seen{$_}++ } @words;
```

## 用 'do' 或 'sub' 包裝一下

最後還有一件事，是把那些述式用 `do` 區塊給包起來：

```perl
my @unique = do { my %seen; grep { !$seen{$_}++ } @words };
```

或是，包成函式，並取個好名字：

```perl
sub uniq {
  my %seen;
  return grep { !$seen{$_}++ } @_;
}
```

## 手作函式，第二回合

Parakash Kailasa 薦議了一版更加簡短的 uniq 函式程式碼，限用於 perl 5.14 以上版本，
並不保證值的次序與原陣列相同。

```perl
my @unique = keys { map { $_ => 1 } @data };
```

函式的形式：

```perl
my @unique = uniq(@data);
sub uniq { keys { map { $_ => 1 } @_ } };
```

讓我們來拆解看看：

`map` 的語法與 `grep`十分類似：都需要一個程式區塊與一個陣列（或是串列）。陣列內容會被一一迭代過，
執行區塊，並將區塊執行結果傳向左側。

In our case, for every value in the array it will pass the value itself followed by the number 1.
Remember `=&gt;`, aka. fat comma, is just a comma. Assuming @data has ('a', 'b', 'a') in it,
this expression will return ('a', 1, 'b', 1, 'a', 1).

在此例中，每一個陣列的值，都會變成它自已跟上數字 1。記好了，`=&gt;` 這
個符號，又稱「肥逗號」，就是個「逗號」。若 @data 的內容為 ('a', 'b', 'c')，那最後運算下來
會變成 ('a', 1, 'b', 1, 'a', 1)。

```perl
map { $_ => 1 } @data
```

如果，將這樣的運算結果被存予雜湊中，那麼雜湊鍵就會與原資料相同，而雜湊值全都是 1。試看看：

```perl
use strict;
use warnings;

use Data::Dumper;

my @data = qw(a b a);
my %h = map { $_ => 1 } @data;
print Dumper \%h;
```

輸出結果為：

```
$VAR1 = {
          'a' => 1,
          'b' => 1
        };
```

或是，如果把上述結果用大括號包起來的話，就可以得到匿名雜湊參照了。

```perl
{ map { $_ => 1 } @data }
```

接著把各部件組合起來看看結果：

```perl
use strict;
use warnings;

use Data::Dumper;
my @data = qw(a b a);
my $hr = { map { $_ => 1 } @data };
print Dumper $hr;
```

這段程式的輸出與前一程式相同，只是在雜湊內容的鍵值次序可能略有不同。

最後，在 perl 5.14 以上的版本，`keys` 函式可以直接處理雜湊參照。於是我們可以寫：

```perl
my @unique = keys { map { $_ => 1 } @data };
```

便能取得 `@data` 中的所有獨特值。

## 習題

輸入以下檔案後，輸入其內容的獨特值：

input.txt:

```
foo Bar bar first second
Foo foo another foo
```

輸出應為：

```
foo Bar bar first second Foo another
```

## 習題二

同樣是濾掉重複的單字，但這次字母大小寫視為相同。

輸出應為：

```
foo Bar first second another
```
