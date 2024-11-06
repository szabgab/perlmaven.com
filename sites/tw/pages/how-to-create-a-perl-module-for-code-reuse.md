---
title: "如何建立 Perl 模組來重複使用程式碼？"
timestamp: 2013-05-11T09:31:56
tags:
  - package
  - use
  - Exporter
  - import
  - @INC
  - @EXPORT_OK
  - $0
  - dirname
  - abs_path
  - Cwd
  - File::Basename
  - lib
  - 1;
published: true
original: how-to-create-a-perl-module-for-code-reuse
books:
  - advanced
author: szabgab
translator: h2chang
---


你也許已經為了你的系統寫了很多程式碼，其中有些可能重複使用相同的函式。

你可能已經習慣用複製貼上來解決問題，但是你並不滿意。

你可能已經知道很多 Perl 的模組，可以使用裏面的函式。但是你想要自己建立模組。

但是你不知道要如何建立模組。


## 模組

```perl
package My::Math;
use strict;
use warnings;

use Exporter qw(import);

our @EXPORT_OK = qw(add multiply);

sub add {
  my ($x, $y) = @_;
  return $x + $y;
}

sub multiply {
  my ($x, $y) = @_;
  return $x * $y;
}

1;
```

把這個檔案儲存在 somedir/lib/My/Math.pm  (或在 Windows 是 somedir\lib\My\Math.pm).

## 腳本

```perl
#!/usr/bin/perl
use strict;
use warnings;

use My::Math qw(add);

print add(19, 23);
```

把這個檔案儲存在 somedir/bin/app.pl (或在 Windows 是  somedir\bin\app.pl).

現在執行 <b>perl somedir/bin/app.pl</b>. (或在 Windows 是 <b>perl somedir\bin\app.pl</b>).

它會印出像這樣的錯誤訊息:

```
Can't locate My/Math.pm in @INC (@INC contains:
...
...
...
BEGIN failed--compilation aborted at somedir/bin/app.pl line 9.
```

## 問題在哪裡？

這個腳本程式會使用 `use` 這個關鍵字來載入模組。尤其是 `use My::Math qw(add);` 這一行。
這樣會在 `@INC` 這個變數中的目錄下開始尋找叫作 <b>My</b> 的子目錄，然後在 My 的子目錄中在尋找叫作 <b>Math.pm</b>的檔案。

所以這個問題在於你的 .pm 檔案沒有在 Perl 的標準目錄裡：也就是它不在 @INC 所包含的目錄中。 

你可以移動你的模組或是可以變更 @INC。

移動模組會造成問題，尤其是必須區分管理者和使用者權限的時候。比如在 Unix 和 Linux 系統中，只有 "root" 更改這些目錄寫入權限。
所以一般我們比較容易的方法是變更 @INC。

## 從命令列變更 @INC 

在我們載入模組之前，我們必須確定模組的目錄有位在 @INC 變數中。

試試看這個:

<b>perl -Isomedir/lib/ somedir/bin/app.pl</b>.

這樣會印出答案： 42。

在這個方法中，`-I` 標記增加目錄路徑到 @INC 中。



## 在程式中更改 @INC

因為我們知道 "My" 這個目錄中<b>相對</b>我們的程式，裏面有我們想要執行的模組，所以我們可以改變一下我們的程式：

```perl
#!/usr/bin/perl
use strict;
use warnings;

use File::Basename qw(dirname);
use Cwd  qw(abs_path);
use lib dirname(dirname abs_path $0) . '/lib';

use My::Math qw(add);

print add(19, 23);
```

再執行一次這個程式：

<b>perl somedir/bin/app.pl</b>.

成功了！

我們來解釋一下發生什麼事情：

## 如果在相對目錄中更改 @INC

這一行
`use lib dirname(dirname abs_path $0) . '/lib';`
增加相對 lib 這個目錄到 `@INC`的開頭。

`$0` 指的是現在這個程式的名子。
`abs_path()` of `Cwd` 傳回這個程式的絕對路徑。


`dirname()` of `File::Basename`會回傳一個檔案或是目錄的目錄，除了最後一個部份。 

在我們的程式中，$0 指的是 app.pl

abs_path($0) 回傳  .../somedir/bin/app.pl

dirname(abs_path $0)   回傳  .../somedir/bin

dirname( dirname abs_path $0)   回傳  .../somedir

這就是我們專案的根目錄。

dirname( dirname abs_path $0) . '/lib'   就是  .../somedir/lib

所以現在我們可以開始使用了
`use lib '.../somedir/lib';`

而且不需要把真正的目錄給寫死在程式碼中。

上面這一行程式的意思是把 '.../somedir/lib' 加到 @INC 的開頭。

一旦這樣，接下來的程式 `use My::Math qw(add);`就會在  '.../somedir/lib' 中發現 "My" 目錄，然後在 '.../somedir/lib/My' 中發現 Math.pm 這個檔案。


這個方法的好處是可以不用在命令列中記得 -I 這個標記。

還有其他方法可以
[更改 @INC](/how-to-change-inc-to-find-perl-modules-in-non-standard-locations)。

## 來解釋 use

就如同前面所說的， `use` 會去尋找 My 目錄以及 Math.pm 檔案。

找到後會把它載入到記憶體中，然後會 `import` 在模組後參數的函式。在這個範例中 `import( qw(add) )`跟 `import( 'add' )` 是一樣的。

## 解釋這個程式腳本

其實已經沒有啥好解釋的了。在 `use` 之後呼叫 `import` 函式，我們只載入在 My::Math 模組中的
<b>add</b> 函式。這樣就如同在程式宣告這個函式一樣。

比較有趣的是來看看模組的部份。


## 解釋模組

Perl module 就是檔案加上命名空間(namespace)。`package` 這個關鍵字建立命名空間。 My::Math 這個模組
就是對應到 My/Math.pm 這個檔案。  A::B::C 這個模組就是對應到 @INC 所包含目錄中的  A/B/C.pm 這個檔案。


回憶一下，`use My::Math qw(add);` 會載入這個模組然後呼叫 `import` 函式。 大部份我們不需要去實現自己的 import 函式，所以要去載入
`Exporter` 這個模組，它就會載入 'import' 函式。

看起來有點令人感到困擾。重要的就是記得： Exporter 可以給你載入的函式。


把要載入的函式放在你模組裏面的 `@EXPORT_OK` 陣列中。

再解釋清楚一點：模組要 "exports" 函式而程式腳本要 "imports" 函式。


最後我要解釋的是在模組中最後的 `1;`。 use 這個敘述會執行這個模組，它需要知道是否執行成功，也就是需要有一個真值的敘述。這個真值的敘述可以是任何東西。
有些人是寫 `42;`，有些人是寫 `"FALSE"`。每個含有字的字串 [都被 Perl 認為是真值](/boolean-values-in-perl)。
這樣會造成其他人的困擾。甚至有些人是寫詩的名言。

"Famous last words."

這看起來很棒，但是可能一開始會造成別人的困擾。

這個模組有兩個函式。我們決定要 export 這兩個函式。但是我們的程式腳本只使用其中一個函式。


## 結論

除了我剛才所解釋的，其實要建立 Perl 模組很簡單。當然你在其他文章會學到更多的東西，但是現在開始把你的常用的函式寫成模組吧。

這裡還有一個關於呼叫模組的建議：

## 模組命名

建議把模組的第一個字母用大寫表示，其他字母用小寫。建議使用命名空間。

如果你在 Abc 公司上班，我會建議所有的模組都用 Abc:: 來當作命名空間。如果在公司裡的專案叫作 Xyz, 那所有相關的模組應該叫作 Abc::Xyz::

所以如果你有個模組來處理配置檔案，這可以叫作 package Abc::Xyz::Config 這樣等同於   .../projectdir/lib/Abc/Xyz/Config.pm。

請避免你的配置檔案叫作 Config.pm，這樣會讓 Perl (Perl 有自己的 Config.pm) 和你自己感到困擾。 


