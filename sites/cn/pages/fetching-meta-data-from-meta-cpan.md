---
title: "从Meta CPAN获取元数据"
timestamp: 2013-06-23T17:20:35
tags:
  - CPAN
  - MetaCPAN
  - MetaCPAN::API
  - META
published: true
original: fetching-meta-data-from-meta-cpan
author: szabgab
translator: terrencehan
---


前文介绍了<a
href="https://perlmaven.com/how-to-add-link-to-version-control-system-of-a-cpan-distributions">如何添加指向版本控制的链接</a> 和 [如何添加证书字段](https://perlmaven.com/how-to-add-the-license-field-to-meta-files-on-cpan) 到CPAN模块。[MetaCPAN::API](https://metacpan.org/pod/MetaCPAN::API)。

那么最近上传的模块中有多少是含有这种信息的？其实这都包含在[Meta CPAN](https://metacpan.org/)，本节我们就用它来生成报告。


## 完整的脚本

使用[MetaCPAN::API](https://metacpan.org/pod/MetaCPAN::API)。

在命令行中，你必须传入要查询的模块数量，也可以选择使用PAUSE ID。（例如，当我检查我自己的发行模块时，这样执行<b>perl metacpan_meta.pl 100 SZABGAB</b>）。

```perl
#!/usr/bin/perl
use strict;
use warnings;
use 5.010;

use Data::Dumper;
use MetaCPAN::API;
my $mcpan = MetaCPAN::API->new;

my ($size, $pauseid) = @ARGV;
die "Usage: $0 N [PAUSEID]  (N = number of most recent distributions)\n" if not $size;

my $q = 'status:latest';
if ($pauseid) {
    $q .= " AND author:$pauseid";
}

my $r = $mcpan->fetch( 'release/_search',
    q => $q,
    sort => 'date:desc',
    fields => 'distribution,date,license,author,resources.repository',
    size => $size,
);

my %licenses;
my @missing_license;
my @missing_repo;
my %repos;
my $found = 0;
my $hits = scalar @{ $r->{hits}{hits} };
foreach my $d (@{ $r->{hits}{hits} }) {
    my $license = $d->{fields}{license};
    my $distro  = $d->{fields}{distribution};
    my $author  = $d->{fields}{author};
    my $repo    = $d->{fields}{'resources.repository'};

    if ($license and $license ne 'unknown') {
        $found++;
        $licenses{$license}++;
    } else {
        push @missing_license, [$distro, $author];
    }

    if ($repo and $repo->{url}) {
        if ($repo->{url} =~ m{http://code.google.com/}) {
            $repos{google}++;
        } elsif ($repo->{url} =~ m{git://github.com/}) {
            $repos{github_git}++;
        } elsif ($repo->{url} =~ m{http://github.com/}) {
            $repos{github_http}++;
        } elsif ($repo->{url} =~ m{https://github.com/}) {
            $repos{github_https}++;
        } elsif ($repo->{url} =~ m{https://bitbucket.org/}) {
            $repos{bitbucket}++;
        } elsif ($repo->{url} =~ m{git://git.gnome.org/}) {
            $repos{git_gnome}++;
        } elsif ($repo->{url} =~ m{https://svn.perl.org/}) {
            $repos{svn_perl_org}++;
        } elsif ($repo->{url} =~ m{git://}) {
            $repos{other_git}++;
        } elsif ($repo->{url} =~ m{\.git$}) {
            $repos{other_git}++;
        } elsif ($repo->{url} =~ m{https?://svn\.}) {
            $repos{other_svn}++;
        } else {
            $repos{other}++;
            say "Other repo: $repo->{url}";
        }
    } else {
        push @missing_repo, [$distro, $author];
    }
}
@missing_license = sort {$a->[0] cmp $b->[0]} @missing_license;
@missing_repo    = sort {$a->[0] cmp $b->[0]} @missing_repo;
say "Total asked for: $size";
say "Total received : $hits";
say "License found: $found, missing " . scalar(@missing_license);
say "Repos missing: " . scalar(@missing_repo);
say "-" x 40;
print Dumper \%repos;
print Dumper \%licenses;
print 'missing_licenses: ' . Dumper \@missing_license;
print 'missing_repo: ' . Dumper \@missing_repo;
```

## 查询的说明

我认为最有趣的部分是查询条件的构建，所以首先来说明一下。

```perl
my $q = 'status:latest';
if ($pauseid) {
    $q .= " AND author:$pauseid";
}

my $r = $mcpan->fetch( 'release/_search',
    q => $q,
    sort => 'date:desc',
    fields => 'distribution,date,license,author,resources.repository',
    size => $size,
);
```

这里调用`fetch`方法来搜索<b>发行模块</b>。该函数传入一系列键-值对作为参数。

第一个键是<b>q</b>，它会根据变量$q中的条件过滤结果。默认地，我们会使用`status:latest`来提取状态是"latest"的所有发行模块。因为在这个报告里不需要包括之前发布的模块。

如果用户提供了一个PAUSE ID——上传CPAN的ID（通过[PAUSE](https://pause.perl.org/)）——那也会包含在查询条件中。比如设PAUSE ID为SZABGAB，那么得到查询条件就会是`status:latest AND author:SZABGAB`。

第二个字段是可选的。在这设定Meta CPAN返回的结果根据<b>date</b>字段降序排列，最近最优先。

另外一个可选的参数：<b>fields</b>可以限制我们真正感兴趣的字段。如果我们省略这些字段，Meta CPAN会对每个发行模块返回很多细节。如果我们对这些细节不感兴趣，这无疑是对资源的浪费。所以我们仅显示需要看的字段。

当我在写这个脚本的时候，我并不知道有哪些字段可以选择。于是开始的时候我没有设置fields就提取了单个发行模块信息，并通过Data::Dumper打印出来，以此来决定在真正的脚本里使用哪些字段。

我们例子中的最后一个参数是设置“结果集”的大小，也就是我们想提取结果的最大数量。我也认为根据需求来设置一个实际值是更好的实践，理由是获取大约20,000个模块信息而大部分数据我们又不需要是毫无意义的。


## 收集数据

返回查询结果后，我们要遍历所有的数据，然后采用一种直接的方式从多个哈希表中过滤搜集结果，最后打印出报表并dump数据。我知道用dump来做报表不是最好的选择，但在这里就足够满足需求了。

## The script on CPAN

在写完这篇文章之后，我将该脚本打包并上传到CPAN上。请参阅[MetaCPAN-Clients](https://metacpan.org/release/MetaCPAN-Clients)。
