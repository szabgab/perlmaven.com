---
title: "Is it possible to share a FILEHANDLE between Threads?"
timestamp: 2009-07-01T10:14:26
tags:
  - threads
published: true
archive: true
---



Posted on 2009-07-01 10:14:26-07 by gulden

Hello, From the tests I've made it's not possible to share a filehandle between threads, right?
I've started a node in PerlMonks (node), related to this issue but without a clear conclusion. Any help will be helpful.
Tks in advance. Marcos Garcia

Posted on 2009-07-01 13:22:37-07 by jdhedden in response to 11101

No. Filehandles cannot be made 'shared'.

(This article is based on a thread on the CPAN::Forum.)
<!-- from http://cpanforum.com/threads/3706 -->

