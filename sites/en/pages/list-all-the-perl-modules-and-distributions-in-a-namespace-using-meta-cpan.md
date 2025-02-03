---
title: "List all the Perl modules and distributions in a name-space using Meta CPAN"
timestamp: 2013-01-13T12:45:56
tags:
  - CPAN
  - MetaCPAN
  - MetaCPAN::API
  - MetaCPAN::Clients
published: true
books:
  - metacpan
author: szabgab
---


There are many modules on CPAN with a plug-in system, and all the plugins are usually in a
specific name-space.

As far as I know even the [Meta CPAN](https://metacpan.org/) web site does not provide
an easy way to list all the distributions in a given name-space.

Even though, using the MetaCPAN API it is quite easy to get this information.


## The solution

The script which is included in the
[MetaCPAN-Clients](http://metacpan.org/release/MetaCPAN-Clients) distribution
can provide the listing.

Let's see parts of the script:

## List all the distributions under a name-space (with a given prefix)

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

This query will fetch all the releases (we usually also call distributions)
for which the <b>distribution</b> field starts with <b>Perl-Critic</b> and which
are the <b>latest</b> releases of the given distribution. (This just filters out
multiple versions of the same distribution.)
We limit the retrieved fields to the name of the <b>distribution</b> and the <b>date</b>.
(The date is not used in our example.)

The returned hash has some meta-meta data in it, so we need to got a bit deeper - two levels
of 'hits' and then we get a array with more meta-data and the the <b>fields</b> sub-key.
I left in the call to Dumper on the original hash, to make it easy for you to see what's going on.


## List all the modules under a name::space (with a given prefix)

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

In this request we fetch the list of <b>module</b>s.
In the <b>filter</b> we use the <b>prefix</b> of the <b>module.name</b> field.
The resulting data structure is quite similar to the earlier one.

## Generating HTML

It is simple to use <b>Data::Dumper</b> to just show the results, but it does not really look good.
So in order to make it a bit easier to use the results as part of a web page, I added an extra flag --html
that can generate a very simple unordered list from the distributions.

The code looks like this:

```perl
my $html = join "\n",
    map { sprintf(q{<li>[%s](http://metacpan.org/release/%s)</li>}, $_, $_) }
    map { $_->{fields}{distribution} }
    @{ $r->{hits}{hits} };
print "<ul>\n$html\n</ul>\n";
```

## The result

Running this:
```
perl bin/metacpan_namespace.pl --distro MetaCPAN --size 10 --html
```

Will generate the html that I embedded below, listing all the modules in the
MetaCPAN name spaces:

* [MetaCPAN-API](http://metacpan.org/release/MetaCPAN-API)
* [MetaCPAN-API-Tiny](http://metacpan.org/release/MetaCPAN-API-Tiny)
* [MetaCPAN-Clients](http://metacpan.org/release/MetaCPAN-Clients)


## Other uses

This script, or something similar could be used to provide a list of all the
plugins for [Perl Dancer](http://perldancer.org/), or [Perl::Critic](http://www.perlcritic.com/),
or for any other module on CPAN.


## Comments

hi, im developing a proyect using perl but ive been experiencing some trouble when i try to verify if the module is installed. the module giving me trouble is File::Basename, i install it by running the following commands: ./Configure -des -Dprefix=$HOME/localperl
make test
make install.
thats what the README file sayis i need to run to install the module and a did it but when i try to verify if the module is really installed using: perldoc File::Basename it says: No documentation found for "File::Basename".

File::Basename is a standard module. If you have perl installed you should already have it. Have you tried actually using the module? What OS do you use?


