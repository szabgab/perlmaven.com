---
title: "打開和讀取文字檔"
timestamp: 2013-05-11T10:45:56
tags:
  - open
  - <$fh>
  - read
  - <
  - encoding
  - UTF-8
  - die
  - open or die
published: true
original: open-and-read-from-files
books:
  - beginner
author: szabgab
translator: h2chang
---


在這個部份 [Perl tutorial](/perl-tutorial) 我們要來看看 <b>如何在 Perl 中讀取一個檔案</b>.

在這裡我們著重在文字檔的部份。


有兩個常見的方法來打開一個檔案, 選擇哪一種方式跟你要如何處理錯誤訊息有關。

## 執行

Case 1: 如果不能打開檔案則丟出例外訊息:

```perl
use strict;
use warnings;

my $filename = 'data.txt';
open(my $fh, '<:encoding(UTF-8)', $filename)
  or die "Could not open file '$filename' $!";

while (my $row = <$fh>) {
  chomp $row;
  print "$row\n";
}
```

## 警示或是不丟出訊息

Case 2: 如果無法打開檔案則丟出警示訊息但還可以繼續執行程式:

```perl
use strict;
use warnings;

my $filename = 'data.txt';
if (open(my $fh, '<:encoding(UTF-8)', $filename)) {
  while (my $row = <$fh>) {
    chomp $row;
    print "$row\n";
  }
} else {
  warn "Could not open file '$filename' $!";
}
```

## 解說

讓我們來嘗試看看以上所說的:

首先，用文字編輯器來製造一個名叫 'data.txt' 的文字檔，然後在檔案中寫入以下文字：

```
First row
Second row
Third row
```

打開並且讀取檔案跟 [寫入檔案](https://perlmaven.com/writing-to-files-with-perl) 很相似,
但是用 "<" 符號來取代 ">" 符號。(`<`)

這裡我們使用 UTF-8 來當作編碼。在這裡讀取檔案只會出現 "<" 符號。

```perl
use strict;
use warnings;

my $filename = 'data.txt';
open(my $fh, '<:encoding(UTF-8)', $filename)
  or die "Could not open file '$filename' $!";

my $row = <$fh>;
print "$row\n";
print "done\n";
```

一旦我們有檔案符號，我們就能跟使用
[從鍵盤讀取(STDIN)](https://perlmaven.com/installing-perl-and-getting-started) 資料一樣的操作方式來從檔案符號讀取資料(readline)。.
上面的程式碼會讀取檔案的第1行資料。然後我們可以印出在 $row 的內容資料，再印出 "done"。


如果你執行上面的程式碼你會看到印出

```
First row

done
```

你也許會問為何在 "done" 之前有一行空白列。
這是因為 readline 這個操作子會讀取一整列資料，包括最後的換行。當我們使用 `print()`來印出資料時，我們又加了第2個換行資料。

如同從 STDIN 讀取資料一樣，我們都常不需要最後的換行資料，所以我們可以使用 `chomp()` 來移除它。

## 讀取更多列資料

一旦我們知道如何讀取一行資料，我們可以把 readline 放在 `while` 迴圈來讀取更多列資料。

```perl
use strict;
use warnings;

my $filename = $0;
open(my $fh, '<:encoding(UTF-8)', $filename)
  or die "Could not open file '$filename' $!";

while (my $row = <$fh>) {
  chomp $row;
  print "$row\n";
}
print "done\n";
```

每一次我們執行到 `while` 迴圈時，它會先執行 `my $row = <$fh>`，這樣來取得下一列資料。
如果這一列有任何資料的話，那麼它會為真值。即使是空的一列，在結束的時候也會有換行符號。
這樣我們讀到的時候，`$row` 這個變數會包含 `\n`，這樣就會為真值。

在我們讀到最後一列之後，接下來 readline 會讀取到 (`<$fh>`) 而回傳 undef，這是偽值。所以 while 迴圈就結束了。

<h3>邊界案例(edge-case)</h3>

有一個邊界案例是：當檔案的最後是 0 而且沒有換行符號。這樣程式可能會判斷成偽值，所以 while 迴圈不會被執行。
不過在這個案例中 Perl 作弊了！如果 Perl 用 `while (defined my $row = <$fh>) ` 來讀取這個邊界案例的話，會執行的很好。and so even such lines
will execute properly.


## 打開檔案而不使用 die

上面這個方法適合使用在你只有打開檔案而不做其他事情。比如說，整個程式就只用來分析這個檔案。

如果這是一個選擇性的配置檔案呢？ 如果你能讀取這個配置檔案，那就改變某些設定。如果讀取失敗，那就使用預設值就好。

如果你考慮的是這樣的方式，那麼下面程式也許是一個好的方法。

```perl
if (open(my $fh, '<:encoding(UTF-8)', $filename)) {
  while (my $row = <$fh>) {
    chomp $row;
    print "$row\n";
  }
} else {
  warn "Could not open file '$filename' $!";
}
```

在這個方法中，我們檢驗 `open`的回傳值。
如果為真，我們就繼續讀取檔案資料。如果為假，我們就使用 `warn` 這個函數來顯示警示，而不丟出例外。
甚至在這裡我們可以不用 `else`。

```perl
if (open(my $fh, '<:encoding(UTF-8)', $filename)) {
  while (my $row = <$fh>) {
    chomp $row;
    print "$row\n";
  }
}
```


