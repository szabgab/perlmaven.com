---
title: "在 perl 裡如何使排序更快"
timestamp: 2013-05-11T11:45:57
tags:
  - map
  - sort
  - Schwartzian
published: true
original: how-to-sort-faster-in-perl
author: szabgab
translator: h2chang
---



根據 ASCII 來排序一串檔案名字的序列，可以運算非常快，即使這個串列很長。 

但是如果你要根據檔案的大小來排序的話，就會非常慢。


## 根據檔案名字來排序檔案

下面是一個很簡單的範例：利用字母順序來排序一串 xml 檔案。這個程式執行起來很快。

```perl

#!/usr/bin/perl
use strict;
use warnings;

my @files = glob "*.xml";

my @sorted_files = sort @files;
```

## 根據檔案名字長短來排序檔案

```perl
my @sorted_length = sort { length($a) <=> length($b) } @files;
```

對 3000 個檔案來說，這個程式比上面的程式大概慢了3倍左右，不過還算是快的。

## 根據檔案大小來排序檔案

當我試著檔案大小來排序 3000 個檔案時，這比用 ASCII 排序慢 80 倍左右的時間。

```perl
my @sort_size = sort { -s $a <=> -s $b } @files;
```

這其實不令人驚訝。在第一個範例，perl 只要比對字母的值就好了。
第二個範例， perl 必須先計算檔案長度再來排序。第3個範例， perl 則必須先到硬碟中抓出檔案大小再來排序。

讀取硬碟比起讀取記憶體還是慢的多。

問題是： <b>我們可以如何改善呢？</b>.

這個讀取硬碟的問題可以讓我們延伸到排序是如何運作的。

在世界上有很多各式各樣的排序演算法。 
([Quicksort](http://en.wikipedia.org/wiki/Quicksort),
[Bubblesort](http://en.wikipedia.org/wiki/Bubblesort),
[Mergesort](http://en.wikipedia.org/wiki/Mergesort), etc.)
根據資料的輸入不同，有些演算法會比較快，有些則比較慢。Perl 以前是使用 Quicksort 來做排序，不過現在則是使用 Mergesort。 
如果妳想要使用不同的排序演算法的話，可以參考 [sort](http://perldoc.perl.org/sort.html) 。

但是不管你選擇哪種演算法，最少都要比較 N*log(N) 的次數。 這意味著： N = 1000 的檔案, perl 要讀取硬碟 2 * 1000 * 3 = 6000 次。(每次比較要兩個檔案大小
所以對每個檔案來說， perl 要讀取 6 次檔案大小！這就是浪費我們寶貴時間的地方。

我們無法避免讀取硬碟來得到檔案大小，而且我們也無法減少比較次數，但是我們可以減少硬碟讀取次數。

## 先取得檔案大小

我們將試著先取的所有檔案的大小，然後把他們儲存在記憶體中，接下來再做排序。

```perl
my @unsorted_pairs = map  { [$_, -s $_] } @files;
my @sorted_pairs   = sort { $a->[1] <=> $b->[1] } @unsorted_pairs;
my @quickly_sorted_files = map  { $_->[0] } @sorted_pairs;
```

這個程式看起來比寫的還要複雜，但是好酒沉甕底阿，有點耐心看下去吧。下面有個更簡單的方法。

這裡有三個步驟。第一步驟，我們命名一個陣列，裏面放的是 ARRAY 的參考，而參考裏面有兩個元素, 第一個是檔案名字，第二個是檔案大小。
這樣每個檔案只會讀取硬碟一次。第二步驟，我們根據參考的第1個元素(也就是檔案大小)來做排序，來得到排序後的陣列。
第三步驟，丟棄檔案大小的元素，只留下檔案名字，這就是我們要的。



## Schwartzian 轉換

上面的程式我們用了兩個暫時陣列來做儲存，但是這兩個陣列並不是一定必須。
我們可以寫單一敘述的程式碼來解決這個問題。
首先，我們要這個程式反轉過來看，也就是"由右往左看"。
在 Pel中，為了要讓程式碼容易閱讀，我們可以把每個敘述寫成自己一行，並且在在大括號裡使用空格。


```perl
my @quickly_sorted_files =
    map  { $_->[0] }
    sort { $a->[1] <=> $b->[1] }
    map  { [$_, -s $_] }
    @files;
```

上面這個方法叫作 [Schwartzian 轉換](http://en.wikipedia.org/wiki/Schwartzian_transform)
由 [Randal L. Schwartz](http://en.wikipedia.org/wiki/Randal_L._Schwartz) 所發明。

Schwartzian 轉換可由 map-sort-map 所組成。


Schwartzian 轉換可以做任何東西的排序，尤其是用在所比對的值需要做很多運算的時候。

```perl
my @sorted =
    map  { $_->[0] }
    sort { $a->[1] <=> $b->[1] }
    map  { [$_, f($_)] }
    @unsorted;
```


使用上面的演算法來做 3000 個 xml 檔案排序時，這樣比用 ASCII 排序約慢 10 倍，但是比原本的程式快 8 倍。



## 結論

藉由記憶體的使用以及程式碼的複雜化，我們可以得到效率。
但是在小的陣列不值得這樣使用，而在大的陣列，也只有在真的有改善效率時才會使用。

如果排序運算(1秒鐘)只佔你的程式(10 分鐘)的小部份的話，這個方式可能改善的有限。但是如果排序運算佔很重的部份的話，你應該使用Schwartzian 轉換。
 

使用 <a href="https://metacpan.org/pod/Devel::NYTProf">Devel::NYTProf to
profile</a> 來看看你的程式適不適合 Schwartzian 轉換。

(感謝 [Smylers](http://twitter.com/Smylers2) 審查這篇文章.)
