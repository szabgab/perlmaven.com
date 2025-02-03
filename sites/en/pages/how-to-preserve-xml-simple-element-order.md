---
title: "How to preserve XML::Simple element order"
timestamp: 2015-09-12T08:10:31
tags:
  - XML
  - XML::Simple
  - XML::LibXML
published: true
author: szabgab
archive: true
---


In the [FAQ](https://metacpan.org/pod/distribution/XML-Simple/lib/XML/Simple/FAQ.pod),
it is mentioned that in the future [Tie::IxHash](https://metacpan.org/pod/Tie::IxHash) could be use in
[XML::Simple](https://metacpan.org/pod/XML::Simple). I am using v2.18 at the moment, is there any hack to preserve the order of the data in the hashref?


To the above question Grant McLean, the author of XML::Simple, answered:

Retaining element order is not and never will be a feature of XML::Simple.
For some XML document types you might be able to hack it in by subclassing
XML::Simple and overriding the new_hashref() method to supply a hashref tied to Tie::IxHash.
That could solve the ABC case but it won't solve the ABA case.

The short answer is that if you care about element order then you should <b>not use XML::Simple</b>.
[XML::LibXML](https://metacpan.org/pod/XML::LibXML) is an excellent alternative which for many use cases is really no harder
to use than XML::Simple.



## Sample XML file with ABA

In this example we have 3 elements inside the "order" root element. If I am not mistaken, that's what Grant referred to
when he wrote 'ABA' case.

{% include file="examples/order.xml" %}

Using XML::Simple we can read in this XML file and immediately print it out.

{% include file="examples/xml_simple_order.pl" %}

The result is this:

{% include file="examples/order_out.xml" %}

The order of the elements has changed.

This might be acceptable in some cases, but in other cases the order of the elements might be important.

## Dumping the XML as a Perl data structure

So why has XML::Simple messed up the order? The answer is in how it holds the data after reading the XML file.
We can use [Data::Dumper](https://metacpan.org/pod/Data::Dumper) to see the content of the `$xml`
variable:

{% include file="examples/xml_simple_order_dump.pl" %}

The output looks like this:

{% include file="examples/order_dump_out.txt" %}

Here we can see that XML::Simple has merged the content of the two 'pizza' tags into one hash.
From this data structure we cannot rebuild the original order of pizza-drink-pizza.

Is this a bug in XML::Simple? You can say so, or you can say that it was a design decision.
In either way Grant, the author of the module is not planning to change this behaviour and
actually recommends agains the use of XML::Simple for new projects. Back when XML::Simple
was created it was a good  solution for a lot of problems, but today there are other solutions.
He recommended XML::LibXML.

Let's see how this round-trip works using [XML::LibXML](https://metacpan.org/pod/XML::LibXML).

## Round-trip with XML::LibXML

{% include file="examples/xml_libxml_order.pl" %}

Running this code we'll get the XML back exactly in the same order as we had in the original file.

(This article was rescued from CPAN::Forum)
<!-- from http://cpanforum.com/threads/6670 -->


