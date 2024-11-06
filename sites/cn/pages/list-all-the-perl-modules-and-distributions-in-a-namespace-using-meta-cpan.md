---
title: "使用Meta CPAN列出名空间的所有Perl模块和版本"
timestamp: 2013-05-23T12:46:56
tags:
  - CPAN
  - MetaCPAN
  - MetaCPAN::API
  - MetaCPAN::Clients
published: true
original: list-all-the-perl-modules-and-distributions-in-a-namespace-using-meta-cpan
author: szabgab
translator: herolee
---


CPAN的很多模块都有装载系统，而且所有的插件通常在一个特定的名空间里。

据我所知，即使[Meta CPAN](https://metacpan.org/)网站也没有提供一个简单的办法列出给定名空间的所有版本。

不过，使用MetaCPAN API可以很简单地获取这个信息。


## 解决方案

[MetaCPAN-Clients](http://metacpan.org/release/MetaCPAN-Clients)发行版里的脚本可以提供列举功能。

我们来看下脚本部分内容：

## 列出名空间（给定前缀）下的所有版本

```perl
use strict;
use warnings;
use Data::Dumper   qw(Dumper);
use MetaCPAN::API;
my $mcpan = MetaCPAN::API->new;

my $r = $mcpan->post(
    'release',
    {
        query  => { match_all => {} },
        filter => { "and" => [
                { prefix => { distribution => 'Perl-Critic' } },
                { term   => { status => 'latest' } },
        ]},
        fields => [ 'distribution', 'date' ],
        size => 2,
    },
);
#print Dumper $r;
print Dumper [map {$_->{fields}} @{ $r->{hits}{hits} }];
```

这个查询会获取所有的发布（通常也叫做发行版），查找<b>distribution</b>字段以<b>Perl-Critic</b>开头并且是给定版本的<b>latest</b>发布。
（这里只是过滤出同一发行版的多个版本。）
我们限定检索到的字段为<b>发行版</b>的名字和<b>日期</b>。（日期在我们的例子中并没有用到。）

返回的哈希包含了一些元数据，因而我们可以查询更深些——两级的'hits'之后，我们得到了一个包含更多元数据的数组和<b>fields</b>子键。
我仅仅对原始的哈希调用了Dumper，以使你能看到里边都是什么。

## 列出名空间（给定前缀）下的所有模块

```perl
use strict;
use warnings;
use Data::Dumper   qw(Dumper);
use MetaCPAN::API;
my $mcpan = MetaCPAN::API->new;

my $r = $mcpan->post(
    'module',
    {
        query  => { match_all => {} },
        filter => { "and" => [
                { prefix => { 'module.name' => 'Perl::Critic::Policy' } },
                { term   => { status => 'latest' } },
        ]},
        fields => [ 'distribution', 'date', 'module.name' ],
        size => 2,
    },
);
#print Dumper $r;
print Dumper [map {$_->{fields}} @{ $r->{hits}{hits} }];
```

在这个请求中，我们获取<b>模块</b>列表。
<b>filter</b>里我们使用了<b>module.name</b>字段的前缀。得到的数据结构跟早些时候那个非常接近。

## 生成HTML

只是用<b>Data::Dumper</b>显示结果固然简单，但是看起来不美观。
因此为了便于把结果作为网页内容的一部分，我加了一个额外的标志--html，它可以从发行版生成一个非常简单的未排序的列表。

代码类似这样：

```perl
my $html = join "\n",
    map { sprintf(q{<li>[%s](http://metacpan.org/release/%s)</li>}, $_, $_) }
    map { $_->{fields}{distribution} }
    @{ $r->{hits}{hits} };
print "<ul>\n$html\n</ul>\n";
```

## 结果

运行这个：
```
perl bin/metacpan_namespace.pl --distro MetaCPAN --size 10 --html
```

将会生成我下边嵌入的html，列举出MetaCPAN名空间的所有模块：

* [MetaCPAN-API](http://metacpan.org/release/MetaCPAN-API)
* [MetaCPAN-API-Tiny](http://metacpan.org/release/MetaCPAN-API-Tiny)
* [MetaCPAN-Clients](http://metacpan.org/release/MetaCPAN-Clients)


## 其他用途

这个脚本或者类似这样的可以用于提供[Perl Dancer](http://perldancer.org/)或者[Perl::Critic](http://www.perlcritic.com/)以至于CPAN上的任何模块的插件列表。
