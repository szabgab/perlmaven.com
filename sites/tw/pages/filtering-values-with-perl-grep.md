---
title: "使用 grep 來過濾想要的值"
timestamp: 2013-05-17T09:45:56
tags:
  - grep
  - filter
  - any
  - List::MoreUtils
  - <>
  - glob
published: true
original: filtering-values-with-perl-grep
author: szabgab
translator: h2chang
---


Perl 內建的 <b>grep</b> 函式就像<b>過濾器</b>一樣。你可以給它一個串列以及一個要過濾的條件，它會回傳一個符回過濾條件的串列。
它是 UNIX和 Linux 指令中 grep 或是 egrep 的通式，不過我們不必真的去了解這些指令。


`grep` 函式需要兩個參數：一個程式區塊和一個串列。

串列中的每個值都會被傳到 `$_`裡，[ Perl 的預設變數](/the-default-variable-of-perl)，
然後這個程式區塊就會被執行。如果程式區塊回傳值為 `false`，那麼這個串列值就會被丟棄。如果程式區塊回傳值為 `true`，
那麼這個串列值就會被保留並且當作回傳值。 

請注意，在程式區塊和串列之間並沒有逗號。

讓我們來看看幾個例子：

## 過濾數字

```perl
my @numbers = qw(8 2 5 3 1 7);
my @big_numbers = grep { $_ > 4 } @numbers;
print "@big_numbers\n";      # (8, 5, 7)
```

這裡的 grep 函式回傳大於 4 的值，並且把小於 4  的值給丟棄。


## 過濾檔案

```perl
my @files = glob "*.log";
my @old_files = grep { -M $_ > 365 } @files;
print join "\n", @old_files;
```

`glob "*.log"` 會回傳所有在現在目錄中的 .log 檔案。

`-M $path_to_file` 會回傳這個檔案最後被變動的時間跟現在時間相差的天數。

這個例子就是要找出最後變動時間超過一年以上的檔案。

## 找出某個元素是否位在陣列中？

`grep` 也可以使用在找出某個元素是否位在陣列中。比如，你有一組串列的名字，妳想要知道裏面是否有某個名字？

```perl
use strict;
use warnings;

my @names = qw(Foo Bar Baz);
my $visitor = <STDIN>;
chomp $visitor;
if (grep { $visitor eq $_ } @names) {
   print "Visitor $visitor is in the guest list\n";
} else {
   print "Visitor $visitor is NOT in the guest list\n";
}
```

這個例子中，我們把 grep 放在 [SCALAR 意境](https://perlmaven.com/scalar-and-list-context-in-perl)中。
在 SCALAR 意境中， `grep` 會傳回符合元素字串的數目。如果回傳 0, 代表這個表示式為 false。如果回傳正值，代表這個表示式為 true。

這個方法可以運作是因為它利用了意境這個方式，但是有人可能對這個比較陌生。讓我們看看利用 `any` 函式，位在
[List::MoreUtils](https://metacpan.org/pod/List::MoreUtils) 模組中，也可以解決這個問題。

## 是否有任何元素配對成功？

`any` 這個函式跟 `grep` 有同樣的語法： 一個程式區塊和一個串列，但是它只回傳 true 或是 false。如果程式區塊配對成功就回傳 true，反之則回傳 false。
而且它有短捷徑，所以在大量串列時，它能夠運算的很快。

```perl
use List::MoreUtils qw(any);
if (any { $visitor eq $_ } @names) {
   print "Visitor $visitor is in the guest list\n";
} else {
   print "Visitor $visitor is NOT in the guest list\n";
}
```


## UNIX 和 Linux grep?

解釋如下：

我曾經提過 Perl 的 grep 是 UNIX和 Linux 指令中 grep 或是 egrep 的通式。

<b>UNIX grep</b> 是基於正規表達式來過濾檔案中的每一列。

<b>Perl's grep</b> 則是可以用在任何表達式來過濾任何串列的值。

下面這個程式可以代表 UNIX grep 的基本功能：

```perl
my $regex = shift;
print grep { $_ =~ /$regex/ } <>;
```

第一行從命令列得到第一個參數來當作正規表達式。剩下的命令列參數則應該是檔案名稱。

鑽石符號 `&lt;&gt;` 可以讀取命令列中檔案名稱的每一列。接下來 grep 根據正規表達式來過濾每一列。每一列只要能成功配對的話，就會被印出來。

## Windows 上的 grep

Windows 上並沒有 grep 這樣的工具，不過你可以安裝一個或是你可以使用上面的 perl 程式腳本。

