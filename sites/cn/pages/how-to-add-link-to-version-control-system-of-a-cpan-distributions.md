---
title: "如何让Meta CPAN为模块显示一个到其版本控制系统的链接"
timestamp: 2013-05-25T20:45:56
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
translator: herolee
---


当你浏览[META CPAN](https://www.metacpan.org/)或者[search.cpan.org](http://search.cpan.org/)时，
你会发现有些模块有一个链接指向Github或者其他托管他们项目的地方。

在search.cpan.org上，它是一个在<b>Repository</b>标题旁的文字链接，而Meta CPAN根据存储的类型，它或是一个链接，或是一个<b>Clone repository</b>标题下边的弹出式菜单。
（Github用漂亮的弹出式菜单，私有存储则是简单的链接。）


两个站点都从CPAN发布的模块里所含的元文件获取到版本控制系統的链接。或者是 META.yml，或者是新式的 META.json。（他们只是格式有别。）


元文件通常在作者发布模块的時候自动生成，我这里只演示让四个主要的打包系统包含存储链接。

这个例子中我会以[Task::DWIM](https://metacpan.org/pod/Task::DWIM)的存储链接为例，
它是一个实验性模块，包含[DWIM Perl](http://dwimperl.com/)发行版里的所有模块。

## ExtUtils::MakeMaker

如果你使用 [ExtUtils::MakeMaker](https://metacpan.org/pod/ExtUtils::MakeMaker)
把下边这段加到Makefile.PL里作为函数<b>WriteMakefile</b>的参数：

```perl
META_MERGE        => {
     resources => {
         repository  =>  'https://github.com/dwimperl/Task-DWIM',
     },
},
```

如果你的 ExtUtils::MakeMaker 版本不支持这个功能，请升级ExtUtils::MakeMaker。

## Module::Build

如果你使用 [Module::Build](https://metacpan.org/pod/Module::Build)，把下面代码加到Build.PL，
作为 <b>Module::Build->new</b> 调用的参数：

```perl
meta_merge => {
    resources => {
            repository => 'https://github.com/dwimperl/Task-DWIM'
    }
},
```

## Module::Install

如果你使用 [Module::Install](https://metacpan.org/pod/Module::Install) 把下面这段加入到 Makefile.PL：

```perl
repository 'https://github.com/dwimperl/Task-DWIM';
```

## Dist::Zilla

如果你使用 [Dist::Zilla](http://dzil.org/)，
[Dist::Zilla::Plugin::Repository](https://metacpan.org/pod/Dist::Zilla::Plugin::Repository)会自动添加到存储的链接，不过你也可以手动指定。

```perl
[MetaResources]
repository.url = https://github.com/dwimperl/Task-DWIM.git
```

详尽的版本会像下面这个例子一样包含更多细节。
这部分只包含在文件META.json里，而不是META.yml。
要生成这个文件，你需要包含Dist::Zilla的[MetaJSON插件](https://metacpan.org/pod/Dist::Zilla::Plugin::MetaJSON)。

```perl
[MetaResources]
repository.web = https://github.com/dwimperl/Task-DWIM
repository.url = https://github.com/dwimperl/Task-DWIM.git
repository.type = git

[MetaJSON]
```

Dist::Zilla还有许多其他办法可以[添加存储链接](http://www.lowlevelmanager.com/2012/05/dzil-plugins-github-vs-githubmeta.html)到元文件中。

## 为什么添加这个链接？

道理很简单。
越容易给你模块的最新版本打补丁，你越可能获取它。

另外，你可能已经在最新版本上做了一些改动。你可能改了其他人要改的bug。要是能看到存储，我们能避免重复劳动。

## 其他资源

如果你已经在做这些了，你也可以加入其它资源。
[CPAN 元规范](https://metacpan.org/pod/CPAN::Meta::Spec#resources) 列出了所有的项目。
如果哪里不清楚，就去问它。

## 许可证

在另一篇文章中，我演示了
[如何把许可证信息加入 CPAN 发行版的元文件中](https://perlmaven.com/how-to-add-the-license-field-to-meta-files-on-cpan)。
如果你有一个公共存储，其他人发补丁就简单了。
