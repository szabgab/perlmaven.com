---
title: "使用 map 來轉換 Perl 陣列"
timestamp: 2013-04-25T10:45:58
tags:
  - map
  - transform
  - list
  - array
published: true
original: transforming-a-perl-array-using-map
books:
  - advanced
author: szabgab
translator: h2chang
---


`map` 函式提供的一個簡單的方法可以把一個串列轉換成另一個串列。通常這種方法是一對一的轉換，不過最後的串列可能比原本的串列要來的短或是來的長，
這兩種都有可能。


[ Perl 的 grep ](/filtering-values-with-perl-grep) 是 UNIX 指令中 grep 的通式。它從原本串列中選出所要的元素，然後傳回這些元素，而不改變它們的值。


而 `map` 則是用來改變這些原本元素的值。

這兩各函式語法是類似的。你提供一段程式碼以及串列值，然後回傳串列值。原本串列的值則放在 `$_` 裡，
[ Perl 預設變數 ](/the-default-variable-of-perl)，然後執行程式碼。回傳值則被傳到左邊的變數。

## 使用 map 來做簡單的轉換

```perl
my @numbers = (1..5);
print "@numbers\n";       # 1 2 3 4 5
my @doubles = map {$_ * 2} @numbers;
print "@doubles\n";       # 2 4 6 8 10
```

## 建立一個快速的查看表

有時候我們想要知道某一串列是否位在給定的串列中。我們可以使用
[grep](/filtering-values-with-perl-grep) 來檢查。甚至我們可以使用 [any](/filtering-values-with-perl-grep)
這個函式，來自 [List::MoreUtils](http://metacpan.org/modules/List::MoreUtils)。如果我們使用雜湊方式來查看的話，使用 map 可讀性比較好而且更快。


我們需要先建立一個雜湊表，它的鍵值就是陣列的元素，而雜湊的值都是 1s。這個簡單的雜湊表可以代替 `grep`。

```perl
use Data::Dumper qw(Dumper);

my @names = qw(Foo Bar Baz);
my %is_invited = map {$_ => 1} @names;

my $visitor = <STDIN>;
chomp $visitor;

if ($is_invited{$visitor}) {
   print "The visitor $visitor was invited\n";
}

print Dumper \%is_invited;
```

下面是 `Dumper` 輸出的結果：

```perl
$VAR1 = {
          'Bar' => 1,
          'Baz' => 1,
          'Foo' => 1
        };
```

在這個方法中我們不在意雜湊的值，只要它們都為真就好。

這個方法只有在你有很大的資料才比較有用。(所謂很大的資料要看你的系統而定。)
否則 `any` 或是 `grep` 就很好用了。

從上面的例子中，`map` 回傳兩個值：一個是原本陣列的元素，一個是 1。

```perl
my @names = qw(Foo Bar Baz);
my @invited = map {$_ => 1} @names;
print "@invited\n"
```

會印出：

```
Foo 1 Bar 1 Baz 1
```


## 胖箭頭(=>)

`=>` 叫作 <b>胖箭頭</b> 或是 <b>胖逗號</b>。它基本上跟逗號的意義差不多，不過有個例外，不在這裡描述，請見 [Perl hashes](https://perlmaven.com/perl-hashes)。


## map 中複雜的表示式

你可以 map 中使用複雜的表示式：

```perl
my @names = qw(Foo Bar Baz);
my @invited = map { $_ =~ /^F/ ? ($_ => 1) : () } @names;
print "@invited\n"
```

上面會印出

```
Foo 1
```

在這個程式區段中，我們使用三元運算子來回傳一對串列或是空串列。很明顯地，我們選擇只要以 "F" 開頭的人名。

```perl
$_ =~ /^F/ ? ($_ => 1) : ()
```

## perldoc

要做更進一步的了解，請看 [perldoc -f map](http://perldoc.perl.org/functions/map.html)。

