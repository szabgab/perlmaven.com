---
title: "Which is better perl-CGI, mod_perl or PSGI?"
timestamp: 2013-04-13T10:45:56
tags:
  - CGI
  - mod_perl
  - FastCGI
  - PSGI
  - Plack
published: true
original: perl-cgi-mod-perl-psgi
author: szabgab
translator: swuecho
---


有人问，perl-cgi好呢？还是mod-perl好呢？我的答案是两者都不好。用PSGI兼容的框架比较好。


## Perl CGI

很久以前，大约在90年代，CGI （Common Gateway Interface) 是唯一的选择。CGI的缺点是比较慢，后来，<b>mod_perl</b>，出现了，与CGI相比，能够把网站的性能提高200-300倍。当然，也有别的比CGI快的方案，比如<b>FastCGI</b>。问题是不同的方案兼容性差。

现在我们有了更好的选择。

## PSGI 及 Plack

[Tatsuhiko Miyagawa](http://bulknews.typepad.com/) 创建了 <a href="http://plackperl.org/">PSGI 和
Plack</a>. 简单的说，PSGI 规定了是Perl网络程序与服务器交互的协议，Plack 是 PSGI 的实现。有了 PSGI 和 Plack，程序员不必在关心部署的兼容性问题。
只要把自己的程序建立在Plack之上即可。

## 框架

尽管如此，很少人会直接在Plack基础之上写程序，多数人会选择一个基于Plack的框架。

对于相对简单的网站，多数人会在 [Perl Dancer](http://perldancer.org/)
和 [Mojolicious](http://mojolicious.org/)间选择。
如果是复杂的网站， [Catalyst](http://www.catalystframework.org/)是标准的选择。




