---
title: "如何讓 Meta CPAN 為發佈其上的模組顯示其版本控制系統的連結"
timestamp: 2013-04-19T20:45:56
tags:
  - Perl
  - Perl 5
  - CPAN
  - Git
  - Github
  - SVN
  - Subversion
  - VCS
  - META
  - ExtUtils::MakeMaker
  - Module::Build
  - Module::Install
  - Dist::Zilla
  - CPAN::Meta::Spec
published: true
original: how-to-add-link-to-version-control-system-of-a-cpan-distributions
author: szabgab
translator: shelling
---


你會看到有些在 [META CPAN](https://www.metacpan.org/)
或是 [search.cpan.org](http://search.cpan.org/) 上的模組有一個連結指向
Github 或是其他用來放置他們專案之處。

在 search.cpan.org 它是一個在標題 <b>Repository</b> 旁邊的的文字連結，
而在 Meta CPAN 按照連結類型不同，它會是個文字連結，或是一個依附在標題 <b>Clone repository</b> 的彈出式方框
(Github 是彈出式方框，私人建立的倉儲會是簡單的連結。)


兩個網站都從發佈 CPAN 的模組中所含的元文件檔取出版本控制系統的連結。
無論從 META.yml 或是比較新的 META.json。(他們只是格式的不同。)

元文件通常在作者發佈模組的時候自動產生，這裡要告訴你如何讓四個主要的打包系統包含倉儲的連結。

這個範例中我使用 [Task::DWIM](https://metacpan.org/pod/Task::DWIM) 的倉儲連結
這是一個實驗性質的模組，列出了所有 [DWIM Perl](http://dwimperl.szabgab.com/) 所含的模組。

## ExtUtils::MakeMaker

如果你使用 [ExtUtils::MakeMaker](https://metacpan.org/pod/ExtUtils::MakeMaker)
請把下面這段當做丟給 <b>WriteMakefile</b> 函式的參數加入你的 Makefile.PL

```perl
META_MERGE        => {
     resources => {
         repository  =>  'https://github.com/dwimperl/Task-DWIM',
     },
},
```

如果你的 ExtUtils::MakeMaker 不支援，請升級它。

## Module::Build

如果你使用 [Module::Build](https://metacpan.org/pod/Module::Build)，加入下面這段到 Build.PL，
作為 <b>Module::Build->new</b> 的參數：

```perl
meta_merge => {
    resources => {
            repository => 'https://github.com/dwimperl/Task-DWIM'
    }
},
```

## Module::Install

如果你使用 [Module::Install](https://metacpan.org/pod/Module::Install) 加入下面這段到 Makefile.PL：

```perl
repository 'https://github.com/dwimperl/Task-DWIM';
```

## Dist::Zilla

如果你使用 [Dist::Zilla](http://dzil.org/)，
[Dist::Zilla::Plugin::Repository](https://metacpan.org/pod/Dist::Zilla::Plugin::Repository)
模組會自動幫你把連結放入倉儲，雖然你也可以手動指定。

```perl
[MetaResources]
repository.url = https://github.com/dwimperl/Task-DWIM.git
```

詳細的版本會長得像是下面這樣。
這部份只會包含在 META.json，META.yml 則無。要產生此檔需要 Dist::Zilla 
的 [MetaJSON plugin](https://metacpan.org/pod/Dist::Zilla::Plugin::MetaJSON)

```perl
[MetaResources]
repository.web = https://github.com/dwimperl/Task-DWIM
repository.url = https://github.com/dwimperl/Task-DWIM.git
repository.type = git

[MetaJSON]
```

Dist::Zilla.還有許多其他方式可以
[把倉儲連結加入元文件中](http://www.lowlevelmanager.com/2012/05/dzil-plugins-github-vs-githubmeta.html)

## 為什麼我需要加入此連結

簡單。越容易發送補丁給你的模組，你越容易得到補丁。

還有，從最後一次發佈後，你也許已經對你的模組做了許多修改。
你也許已經修正許多他人想修正的臭蟲。如果我們可以瀏覽你的倉儲，會避免工作重複。

## 其他資源

如果你已經做到這些，你也可以加入其他資源。
這份 [CPAN 元規格](https://metacpan.org/pod/CPAN::Meta::Spec#resources) 列出了所有項目。
如果哪裡不清楚，問就對了。

## 許可證

在另一篇文章中，我說明了
[如何把許可證資訊加入 CPAN 模組的元文件中](https://perlmaven.com/how-to-add-the-license-field-to-meta-files-on-cpan)。
如果你有一個公開倉儲，這樣讓其他人比較容易發送補丁。


