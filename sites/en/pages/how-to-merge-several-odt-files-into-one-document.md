---
title: "How to join (merge) several ODT files into one document"
timestamp: 2009-02-12T08:29:49
tags:
  - OpenOffice::OODoc
published: true
archive: true
---



Posted on 2009-02-12 08:29:49-08 by benat

Hello,

I'm trying to join several ODT files (one page each) into a single document containing
all of them, one per page. After spending some time on the documentation
I ended with the following code, which at a first glance does what I need:

```perl
$oodoc1->appendElement(
    '//office:body',
    0,
    $oodoc2->exportXMLElement( '//office:text' )
);
```

This code exports the &lt;office:text&gt; node from $oodoc2 and appends it,
as a new child, into node &lt;office:body&gt; of $oodoc1.
This way, the generated document gets two &lt;office:text&gt; nodes.

Well, it works and I can open the merged document (~60 files joined) in
an OpenOffice application, but the point is that I'm not sure it conforms to the ODF schema:
shouldn't the <office:text> node be unique? Moreover, I would need the whole document
be somewhat "reorganized" (styles and alike), but the "reorganize" method throws
an error message saying it's no longer implemented.

Please does anybody know a cleaner way to do such document joins?
Google didn't help. Thanks a lot.

Posted on 2009-02-12 12:31:47-08 by jmgdoc in response to 9938

1) The office:text element should appear once in a regular document

2) OpenOffice::OODoc allows the programmer to create complex documents
including parts possibly extracted/copied from other documents,
but it's not designed to directly merge documents.

3) However the API allows you to easily create a master document
and include external subdocuments through sections; see the appendSection()
method in the OpenOffice::OODoc::Text manual chapter; the result is
not exactly a merged document, i.e. the external documents remain hosted in external files,
but the functionality is similar.

Posted on 2009-02-12 13:17:38-08 by benat in response to 9944

Many thanks. I will try the way you suggest and post back the result when (if?) I'm successful :-)

(This article is based on a thread on the CPAN::Forum.)
<!-- from http://cpanforum.com/threads/9938 -->

