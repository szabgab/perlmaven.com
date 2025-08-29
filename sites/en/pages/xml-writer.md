---
title: "XML::Writer examples"
timestamp: 2016-04-20T18:30:01
tags:
  - XML
  - XML::Writer
published: true
books:
  - xml
author: szabgab
archive: true
---


[XML::Writer](https://metacpan.org/pod/XML::Writer) provides an easy way to create [XML using Perl](/xml). 
In this article you'll see a number of examples with explanation, but let's ask why would we want to use a module
when we could just concatenate strings?

The answer is that XML::Writer provides **automatic character escaping** where needed and a certain level of
**validity checking** to make sure the generated XML is at least **well formed**.


## Simple human-readable XML creation

{% include file="examples/xml_writer_1.pl" %}

Generates this XML:

{% include file="examples/xml_writer_1.xml" %}

<h3>Details</h3>

`OUTPUT => 'self'` tells XML::Writer that we want it to accumulate the XML string
in itself and return it to us when we call the `end` method.
Without this we would get the XML printed on STDOUT, or if we passed an approprite parameter
then printed to that channel.

`DATA_MODE => 1` tells XML::Writer to put every tag on a different line. Without that it would create one long row.

`DATA_INDENT => 2` defines the number of spaces to use indenting every internal level of tags.

`$writer->xmlDecl('UTF-8');` creates the first row of the document. It is not required by either XML::Writer or any of the parsers, but it is nice to have.
Especially the part that indicates the encoding.


`$writer->startTag('people');` inserts an opening XML tag with the given name: `&lt;people&gt;`

`$writer->startTag('user', name => 'Foo');` inserts an opening XML tag with an attribute and its value. `&lt;user name="Foo"&gt;`.

$writer->characters('content');  adds plain characters to the XML file.

`$writer->endTag('user');` inserts an end tag `&lt;/user&gt;`. XML::Writer checks if we have closed every tag properly and give an error of not.
Some of these checks happend while we build the XML, other when we later call the `end` method.
We actually don't even need to supply a value for the `endTag` method. XML::Writer can pick the right value for us if we just call `endTag`
without any parameters.


`$writer->dataElement('user', 'content', name => 'Bar');` adds  `&lt;user name="Bar"&gt;content&lt;/user&gt;`.

It is the same as

```perl
$wirter->startTag('user', name => 'Bar');
$writer->characters('content');
$writer->endTag;
```

`$writer->emptyTag('img', src => 'xml.png');` creates an empty tag with the given name and attribute/value pair. An empty tag is one
that has an opening tag which is also a closing tag at the same time indicated by the slash at the end of the tag.  `&lt;img src="xml.png" /&gt;`

`$writer->end` indicates the end of the XML stream. In our case, because we set `OUTPUT => 'self'`, this call will also return the XML as a string.

At the end of our example we use [XML::LibXML](https://metacpan.org/pod/XML::LibXML) just to check if the XML was well formed.

## Create XML for machines

IF we don't want to make the XML easily viewable by humans we don't need to extra lines and indentations. We can have the whole XML data
on a single line. In that case use

`my $writer = XML::Writer->new(OUTPUT => 'self');`

Without `DATA_MODE` and without `DATA_INDENT`.

The resulting XML has the same internal structure, but it has not newlines in it.


## Automatic closing of tags

We don't need to provide the name of the tag when we call `endTag`. After all, from the structure of XML so far, the name
of the closing tag can be deducted. If we call `endTag` without any parameter then XML::Writer will place the correct closing tag.

{% include file="examples/xml_writer_5.pl" %}

This is convenient, but some people might feel that providing the name of the closing tag, and thus having XML::Writer check if we provided
the right one, is a good way to add an extra level of validity checking to their code. I don't have a strong opinion on this.

## Escaping special characters

Certain characters are not valid characters in an XML file, or they have special meaing. For exampl `&lt;`, `&gt;`, and `&amp;`.
If we would like to insert such characters we need to replace them with special symbols.

XML::Writer does this for us seamlessly.

{% include file="examples/xml_writer_6.pl" %}

Generates the following XML file:

{% include file="examples/xml_writer_6.xml" %}

## Errors


<h3>Document cannot end without a document element</h3>

We need at least one element in the XML document. At least one call to `startTag`, or `dataElement`.

{% include file="examples/xml_writer_2.pl" %}

<h3>Document ended with unmatched start tag(s): ...</h3>

{% include file="examples/xml_writer_3.pl" %}

We called `startTag` but we have not called the appropriate `endTag`.

<h3>End tag "..." does not close any open element</h3>

{% include file="examples/xml_writer_4.pl" %}

We called `endTag` for an element that is not open. This might happen if we mistakenly
call `endTag` or swap the order of the calls. In any case, if you runt the above example
you'll see that it never prints "OK". That's because this check is done while we build the XML
data and not only when we call `end`.


## Lack of error

As an experiment I've tried to add a tag with a name that is not valid and then I tried to
parse that XML file.

{% include file="examples/xml_writer_7.pl" %}

The XML was generated:

{% include file="examples/xml_writer_7.xml" %}

but then we got a parse error from XML::LibXML.

I've opened a [ticket](https://rt.cpan.org/Ticket/Display.html?id=107239) wondering if this should be enforced.


## Documentation

If this is still not enought, you can read the official documentation of
[XML::Writer](https://metacpan.org/pod/XML::Writer).


