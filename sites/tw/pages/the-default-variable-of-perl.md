---
title: "$_ the default variable of Perl"
timestamp: 2013-05-17T10:41:51
tags:
  - Perl
  - $_
  - scalar
  - default
  - variable
  - topic
published: true
original: the-default-variable-of-perl
author: szabgab
translator: h2chang
---


Perl 有一個怪異的 scalar 變數叫作 `$_`，它叫作
`預設變數`或是<b>topic</b>。

在 Perl中有許多函式和操作子使用這個變數當作預設變數，比如在沒有明顯參數的時候。一般而言，你應該<b>不會</b>
在真實的程式碼中看到`$_`。也就是說你不用把 `$_` 明確的寫在程式中。

就是說，這樣就誠如你所想做的。


使用預設變數是很用的方式，不過如果用的不好會降低程式可讀性。

來看看下面這個程式：

```perl
use strict;
use warnings;
use v5.10;

while (<STDIN>) {
   chomp;
   if (/MATCH/) {
      say;
   }
}
```

上面這個程式跟下面程式是一樣的：

```perl
use strict;
use warnings;
use v5.10;

while ($_ = <STDIN>) {
   chomp $_;
   if ($_ =~ /MATCH/) {
      say $_;
   }
}
```

在很小的程式或是很緊密的程式中。我只會寫第一種程式而不寫第二種。


誠如你看到的，在 `while` 迴圈中，檔案中的每一列會被自動讀到 `$_`，而不用再明確的寫在程式中。

如果沒有給予特別參數，`chomp()` 預設就是對 $_ 做運算。

正規表達式可以不用明確的給予字串，甚至也不用寫 `=~` 這個操作子。如果這樣寫，代表就是對 `$_` 做運算。

最後， `say()`， 類似 `print()`，如果不給予參數的話，會印出 `$_`的內容。

## split

`split` 的第二個參數就是預計要做運算的字串。如果沒有第二個參數，則 split 會對 `$_` 做運算。

```perl
my @fields = split /:/;
```

## foreach

如果在 `foreach` 中，我們沒有給予迭代器(Iterator)名稱的話，它會使用 `$_`。

```perl
use strict;
use warnings;
use v5.10;

my @names = qw(Foo Bar Baz);
foreach (@names) {   # puts values in $_
    say;
}
```

## 指定敘述

有時候我們錯誤地使用 `$_`。

有些高手會故意這樣寫，但是由新手寫出來的可能會是 bug。

```perl
if ($line = /regex/) {
}
```

這裡我們使用 `=` 指定運算子，而不是正規表達式的 `=~` .
這跟下面的程式是一樣的：

```perl
if ($line = $_ =~ /regex/) {
}
```

拿 `$_`來做比對，然後把結果指定給 `$line`。在檢查 $line 是 true 或 false。

## 明確使用 $_

之前我建議 <b>不要</b> 明確使用 `$_`。有時候我們會看到這樣的程式：

```perl
while (<$fh>) {
  chomp;
  my $prefix = substr $_, 0, 7;
}
```

我認為如果你需要明確使用 `$_`的話，如同上面的程式，你應該使用一個更有意義的變數來代替：

```perl
while (my $line = <$fh>) {
  chomp $line;
  my $prefix = substr $line, 0, 7;
}
```

另外常見到不好的範例：

```perl
while (<$fh>) {
   my $line = $_;
   ...
}
```

這常常是因為不了解 `while`、讀取檔案代號和 `$_`之間的關係，才會這樣寫。

我們有更簡單的寫法來直接指定給 `$line`。

```perl
while (my $line = <$fh>) {
   ...
}
```


## 例外

還是有一些情形我們沒有辦法避免明確的使用 `$_`。比如 [grep](/filtering-values-with-perl-grep)
和 [map](/transforming-a-perl-array-using-map) 函式。還有一些情形，比如 [any](/filtering-values-with-perl-grep)。


