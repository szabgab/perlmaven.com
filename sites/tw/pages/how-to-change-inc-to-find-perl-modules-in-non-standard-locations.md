---
title: "如何更改 @INC 來找到不位在標準目錄的 Perl 模組"
timestamp: 2013-05-11T06:01:02
tags:
  - "@INC"
  - use
  - PERLLIB
  - PERL5LIB
  - lib
  - -I
published: true
original: how-to-change-inc-to-find-perl-modules-in-non-standard-locations
books:
  - beginner
author: szabgab
translator: h2chang
---


當使用不是安裝在標準目錄的模組，我們必須更改 @INC 來讓 Perl 能夠找到他們。有許多不同的方式可以解決不同情形下的問題。

讓我們先來看看這些問題:



## 載入你自己寫的 Perl 模組

你開始建立自己的模組, 叫作 `My::Module`。
你把它存在 `/home/foobar/code/My/Module.pm` 裡。

你的程式腳本像下面這樣：

```perl
use strict;
use warnings;

use My::Module;
```

但是當你執行這個程式時，你會得到像下面這樣的友善錯誤訊息：

```
Can't locate My/Module.pm in @INC (@INC contains:
   /home/foobar/perl5/lib/perl5/x86_64-linux-gnu-thread-multi
   /home/foobar/perl5/lib/perl5
   /etc/perl
   /usr/local/lib/perl/5.12.4
   /usr/local/share/perl/5.12.4
   /usr/lib/perl5 /usr/share/perl5
   /usr/lib/perl/5.12
   /usr/share/perl/5.12
   /usr/local/lib/site_perl
   .).
   BEGIN failed--compilation aborted.
```

Perl 無法找到你的模組。

## 升級 Perl 模組

如果你考慮升級一個 CPAN 裡的模組，但是妳又不想要把它安裝在標準目錄裡。首先，你可以把他放在私人目錄中，然後安裝並且試試看是否可以執行。

在這個例子中，你把這個模組安裝在私人目錄中，e.g. in  /home/foobar/code，並且你想要 Perl 是找尋到這個新的模組，而不是安裝在系統中舊的模組。

## use 敘述

當 perl 遇到 `use My::Module;`時，它就去找包含在 `@INC` 陣列中的所有目錄。
它會搜尋是否有子目錄叫作 "My"，如果有，它會繼續在 "My" 裡尋找是否有其中含有 "Module.pm"檔案。

第一個被找到的檔案就會被載入到記憶體中。

如果沒有檔案被找到，那麼就會得到上面的錯誤訊息。

當 perl 被編譯的時候，`@INC` 就被定義好了，它就被嵌入在二進位碼中。我們無法修改它，除非我們重新編譯 perl。但這不是我們想要做的。


幸運的是，當我們在執行程式腳本時，我們有許多方法可以更改 `@INC` 陣列。接下來我們會看到這些解決的方式並且討論哪一種問題適合哪一種解決方式。 

## PERLLIB 和 PERL5LIB

你可以定義 PERL5LIB 這個環境變數(雖然 PERLLIB 也可以，但是我建議使用 PERL5LIB，因為這樣很清楚知道它是跟 Perl 5 相關。)
每個在這個變數的目錄都會被加到 `@INC`的開頭。

在 <b>Linux/Unix</b> 中使用 <b>Bash</b> 的話, 你可以這樣寫：

```
export PERL5LIB=/home/foobar/code
```

你可以把它加到 ~/.bashrc 檔案中，這樣每次登入都可以使用。

在 <b>Windows</b>，你可以在命令列中這樣寫：

```
set PERL5LIB = c:\path\to\dir
```

如果想要一勞永逸來解決的話，請這樣做：

在 <b>我的電腦</b> 按右鍵，然後按 <b>內容</b> 按鈕。

在 <b>系統內容</b> 裡, 按 <b>進階</b> 按鈕。

在進階裡，按 <b>環境變數</b> 按鈕。

在環境變數中，在使用者變數中按下 <b>新增</b> 按鈕，然後輸入：

Variable name: PERL5LIB

Variable value: c:\path\to\dir

接下來按 OK 三次。這樣子 Windows 就增加這個變數了。在命令列中輸入：

```
echo %PERL5LIB%
```

<hr>

這樣會增加私人目錄 /home/foobar/code directory (或是 c:\path\to\dir directory)
到 `@INC`裡。這樣 <b>每個程式腳本</b> 都在這樣的環境中執行。

在 <b>taint mode</b> 下(之後會在解釋)， PERLLIB 和 PERL5LIB 環境變數會被忽略。

## use lib

把 `use lib` 這個敘述加到程式腳本裡，就會把這個目錄加到 `@INC` 裡。不過這樣只有這個程式腳本知道，不會影響到其他程式。


在載入模組之前，你必須確定已經先使用 use lib 了：

```perl
use lib '/home/foobar/code';
use My::Module;
```

但是有一點要注意，我看過很多公司為了要能載入模組相依的程式，就都把 `use lib` 放入模組中。
我覺得這不太好。我覺得應該只有 main 的程式可以更改 `@INC` 或是用以下兩種方式來解決比較好。 

## 在命令列中使用 -I

(這是大寫的i)

最後這個解法是最常見的暫時解法。把 `-I /home/foobar/code` 這個標誌加到正在執行的程式上。

<b>perl -I /home/foobar/code  script.pl</b>

這樣會把 /home/foobar/code 加到正在執行程式中的 @INC 裡。

## 這樣要使用哪一種方式呢

如果你只是要測試新的模組的話，我會建議使用：
`perl -I /path/to/lib`.

如果你要在私人目錄安裝很多模組的話，我會建議使用 `PERL5LIB`。使用 `local::lib` 這個模組也可以。

在兩種情形會使用 `use lib` ：

<ol>
<li>當你有一個固定放置模組的私人目錄，而不要放在標準目錄中。</li>
<li>當你建立一個程式，而你要測試模組跟這個程式的相對位置的時候。我們會在其他文章提到。</li>
</ol>

<TMPL_INCLUDE name="incl/beginner.tmpl">

