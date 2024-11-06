---
title: "操縱字串的函式：lc, uc, index, substr"
timestamp: 2013-04-08T13:37:52
tags:
  - length
  - lc
  - uc
  - index
  - substr
  - scalar
published: true
original: string-functions-length-lc-uc-index-substr
books:
  - beginner
author: szabgab
translator: gugod
---


在此篇[Perl 教學](/perl-tutorial)，我們將學習到一些操縱字串的函式。


## lc, uc, length

有些字串函式的行為相當簡明，如 <b>lc</b> 或 <b>uc</b>，分別會轉換原字串為小寫，或大寫。
而 <b>length</b> 函式則會計算字串裡的字符個數。

見以下範例：

```perl
use strict;
use warnings;
use 5.010;

my $str = 'HeLlo';

say lc $str;      # hello
say uc $str;      # HELLO
say length $str;  # 5
```


## index

<b>index</b> 函式，傳入兩個字串後，傳回第二字串位於第一字串內的位置。

```perl
use strict;
use warnings;
use 5.010;

my $str = "The black cat jumped from the green tree";

say index $str, 'cat';             # 10
say index $str, 'dog';             # -1
say index $str, "The";             # 0
say index $str, "the";             # 26
```

範例中第一次呼叫的 `index` 傳回 10，因為在可在第 10 個字符處找到 "cat" 。
第二次的 `index` 則傳回 -1，表示在那句話中找不到 "dog"。

第三次呼叫的 `index`，則傳回 0，這表示第二字串為第一字串的字首，一開始就出現。

範例中第四次呼叫的 `index` 則展示字母大小寫不同也會有差異，"the" 與 "The" 畢竟是不同的字串。

`index()` 比對的單位是字串，而不是英文單字，所以像 "e " 內含空白的也能應付：

```perl
say index $str, "e ";              # 2
```

接下來可以從位置 3 開始找，看看是否還有其他的 "e " 在後面：

```perl
say index $str, "e ";              # 2
say index $str, "e ", 3;           # 28
say index $str, "e", 3;            # 18
```

顯然，如果只找沒有空白的 "e"，會得到不同結果。

另外還有一招，是 <b>rindex</b> （right index -- 右邊版的 index）這個函式，
會從字串的右邊開始，往左邊找（或著說從字串的尾巴往前找）：

```perl
say rindex $str, "e";              # 39
say rindex $str, "e", 38;          # 38
say rindex $str, "e", 37;          # 33
```

## substr

`substr` 應該是本篇中最耐人尋味的函式。它基本上與 index() 正好相反。index() 會告訴你
<b>字串的位置</b>，但 substr 會給你 <b>在某個位置的字串</b>。一般在使用 `substr` 時要傳入三個參數。
第一個參數是字串，第二個參數表示從 0 起算的位置，或稱<b>位移</b>，第三個參數則為<b>長度</b>，表示要截取的小字串長度。

```perl
use strict;
use warnings;
use 5.010;

my $str = "The black cat climbed the green tree";

say substr $str, 4, 5;                      # black
```

substr is 0 based so the character at the offset 4 is the letter b.

substr 的位移是從 0 起算，因此位移 4 是字母 "b" 。

```perl
say substr $str, 4, -11;                    # black cat climbed the
```

原本表示長度的第三參數也可以是負數，不過意義自然不同。這表示改取字串的右邊起算過來的某個位置。前例
表示，截取原字串中由左起算第 4 個字母，至由右起算第 11 個字母。

```perl
say substr $str, 14;                        # climbed the green tree
```

也可以不給第三參數（長度），這麼一來意義則為：從第 4 位置起算，截取至字串最末端。

```perl
say substr $str, -4;                        # tree
say substr $str, -4, 2;                     # tr
```

第二參數（位移）也可以傳入負數，同樣表示倒數。上例為：從右邊數過來第 4 個開始截取。
與 `length($str) - 4` 同義。

## 取代部份字串

最後的範例有點頑皮。在之前的範例中，`substr` 都是截取原字串中的某一小段。但
在此，它也被用來修改原字串的內容！

`substr()` 的傳回值必定是由前三個參數決定，但在此例中，我們傳入第四個參數。表示
要將截取的那段字串，代換成第四參數的內容。

```perl
my $z = substr $str, 14, 7, "jumped from";
say $z;                                                     # climbed
say $str;                  # The black cat jumped from the green tree
```

`substr $str, 14, 7, "jumped from"` 還是傳回 <b>climbed</b>，但因為有傳入
第四參數，原字串的內容被修改了。

