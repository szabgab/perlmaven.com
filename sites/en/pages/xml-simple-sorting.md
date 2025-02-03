---
title: "XML::Simple sorting"
timestamp: 2007-11-21T21:38:22
tags:
  - XML
  - XML::Simple
published: true
archive: true
---



Posted on 2007-11-21 21:38:22-08 by tirto

Hi, i have a question regarding XML::Simple sorting.
I am trying to sort the result of XMLout numerically.
Here is my perl data structure:

```perl
my $hashref = {
  item => {
    "2" => { label => 'bar' },
    "1" => { label => 'foo' },
    "11" => { label => 'baz' }
  }
};
my $xs = XML::Simple->new();
my $xml = $xs->XMLout( $hashref, KeyAttr => ['id'] );
print $xml;
```

and here is my output (it is sorted ascii-betically):

```
<opt>
  <item id="1" label="foo" />
  <item id="11" label="baz" />
  <item id="2" label="bar" />
</opt>
```

I don't find any options for sorting, e.g. `KeySort = \&some_function`
in the doc. anyone can suggest what to do i want to sort by "id" numerically?
here is my expected output:

```
<opt>
  <item id="1" label="foo" />
  <item id="2" label="bar" />
  <item id="11" label="baz" />
</opt>
```

thanks, tirto

Posted on 2007-11-21 22:17:56-08 by grantm in response to 6493

The simplest answer is "don't do that".
If you want elements output in a particular order then they should
be in an arrayref in your data structure rather than a hashref, e.g.:

```perl
my $hashref = {
  item => [
    { id => 1, label => 'foo' },
    { id => 2, label => 'bar' },
    { id => 11, label => 'baz' },
  ]
};
```

Another approach would be leave your data structure as it is
but override XML::Simple's 'hash_to_array' method, e.g.:

```perl
#!/usr/bin/perl
use strict;
use warnings;
my $hashref = { item => { "2" => { label => 'bar' }, "1" => { label => 'foo' }, "11" => { label => 'baz' } } };
my $xs = XML::SortedSimple->new();
my $xml = $xs->XMLout( $hashref, KeyAttr => ['id'] );
print $xml;

package XML::SortedSimple;
use base 'XML::Simple';

sub hash_to_array {
  my $self = shift;
  my $ref = $self->SUPER::hash_to_array(@_);
  if( UNIVERSAL::isa($ref, 'ARRAY') ) {
    $ref = [ sort { $a->{id} || 0 <=> $b->{id} || 0 } @$ref ];
  }
  return $ref;
}
```

In this example, any hashref that does get unfolded into an arrayref
will have its elements sorted (numerically) by the value of the id keys.
Probably best to go with massaging your data structure though.

Posted on 2007-11-21 22:41:38-08 by tirto in response to 6494

got it! thank you very much for your prompt response.
i will modify my data structure. hash_to_array wasn't part of the "hook methods",
it would be nice to include hash_to_array in the doc.
btw, i was going to use XML::Filter::Sort in an attempt to solve the problem,
but it wasn't giving what i want, not to mention that i have to change
my data structure anyways and deal with the array folding if i don't
supply keyattr option. your suggested solution is much better.

```perl
#!/usr/local/bin/perl -w
use strict;
use warnings;
use XML::Simple;
use XML::Filter::Sort;
use XML::SAX::Writer;
my $hashref = {
    item => {
        "2"  => { label => 'bar' }, 
        "1"  => { label => 'foo' },
        "11" => { label => 'baz'},
    }
};
my $writer = XML::SAX::Writer->new();
my $filter = XML::Filter::Sort->new(
     Handler=>$writer,
     Record=>'item',
     Keys => [['name', 'num', 'asc']]);
my $xs = XML::Simple->new(Handler=>$filter);
my $xml = $xs->XMLout( $hashref, NoAttr=>1);
print $xml;
```

output:

```
<?xml version='1.0'?><opt> <item> <name>1</name>
<label>foo</label> </item> <item> <name>2</name>
<label>bar</label> </item> <item> <name>11</name>
<label>baz</label> </item> </opt>
0
```

it weird that it's giving me 0 at the end of the xml output. thanks again, tirto

(This article is based on a thread on the CPAN::Forum.)
<!-- from http://cpanforum.com/threads/6493 -->

