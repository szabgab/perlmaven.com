---
title: "How to fetch the CPAN dependency tree of a Perl module?"
timestamp: 2012-12-18T12:45:56
tags:
  - MetaCPAN
  - CPAN
  - dependencies
  - MetaCPAN::API
published: true
books:
  - metacpan
author: szabgab
---


When installing a module from CPAN, we first need to install all the dependencies of a module. Luckily all the CPAN can
do this automatically. Either out-of-the box, or after setting a configuration option.

What if you'd like to check the dependency tree of a module, even before installing all the dependencies of the module?

How could you fetch the list of the dependencies?


## Deprecation notice

This article uses the deprecated [MetaCPAN::API](https://metacpan.org/pod/MetaCPAN::API). Instead of that you
will need to use the [MetaCPAN::Client](https://metacpan.org/pod/MetaCPAN::Client).

## MetaCPAN knows it

Luckily, [MetaCPAN](https://www.metacpan.org/) already collected all the information we need, so we only need to fetch the data
via they MetaCPAN API. We are going to use the [MetaCPAN::API](https://www.metacpan.org/module/MetaCPAN::API)
module created by [SawyerX](http://blogs.perl.org/users/sawyer_x/)

Let's see the building blocks.

## Get information about a Perl module on CPAN

A Perl module is the pm file that is interesting for the developer.
It is what you load into memory with the <b>use</b> statement. Each Perl module is packaged
into a distribution, but in the first example we examine a single module.

```perl
#!/usr/bin/perl
use strict;
use warnings;
use 5.010;

use Data::Dumper;
use MetaCPAN::API;

my $mcpan = MetaCPAN::API->new;

my $module   = $mcpan->module( 'Test::More' );
say Dumper $module;
```

After creating the MetaCPAN::API object we can call the <b>module</b> method passing the name of a module to it.
It will return a hash reference, representing all the information about the module. Among other things, the hash
has a key called <b>distribution</b> with the name of the CPAN distribution that contains this module. In the case
of the [Test::More](https://www.metacpan.org/module/Test::More) module,
this is the [Test-Simple](https://metacpan.org/release/Test-Simple) distribution.

There are many other fields. Some that might be more interesting are: <b>version</b>, <b>abstract</b>, <b>author</b>
which is the PAUSE id of the person who uploaded this release, and date.


## Get information about a CPAN distribution

A CPAN distribution is a tarball or zip file uploaded to CPAN.
This is the unit that you can install (or not).
Each distribution can contain 0 or more modules.
It is mostly interesting for the system administrators who need to ensure, you have all the dependencies installed.

```perl
#!/usr/bin/perl
use strict;
use warnings;
use 5.010;

use Data::Dumper;
use MetaCPAN::API;

my $name = 'Test-Simple';
my $mcpan = MetaCPAN::API->new;
my $dist  = $mcpan->release( distribution => $name );
say Dumper $dist;
```

In order to fetch information about a distribution we call the <b>release</b> method and pass the name of the
distribution. For example [Test-Simple](https://metacpan.org/release/Test-Simple).

This, too returns a reference to a hash with lots of key. Some of the interesting keys would be <b>date</b>,
<b>author</b>, <b>download_url</b>, <b>version</b>, <b>license</b> (which is actually an array reference to a list of
license keywords), and dependency which is also an array reference.
The element of this array are hash references by themselves. Each hash describing one of the direct dependencies.
These hashes have 5 keys, IMHO 3 of them are the most interesting ones: <b>version</b>, <b>module</b>, and
<b>phase</b> which describes when is this dependency needed. Values can be <b>configure</b>, <b>build</b>, and
<b>runtime</b>.


## DevOps

People who understand that there is a need to bridge the gap between developers and operators (sysadmins)
are referred as being [DevOps](http://en.wikipedia.org/wiki/DevOps). They are concerned with both
the modules and the distributions mentioned above.

Furthermore, given a module, they will be probably interested in the list of all the dependencies, and not
only the immediate ones. After all, it is quite possible that module A depends on module B which in turn depends on
module C which depends on D ...

Given a module, or a list of modules, they will certainly want to know which distributions they will need to install.

## Getting the CPAN dependency tree of a Perl module

```perl
#!/usr/bin/perl
use strict;
use warnings;
use 5.010;

use Data::Dumper;
use MetaCPAN::API;

my %data;

my $mcpan = MetaCPAN::API->new;
process_module('Test::More');
say Dumper \%data;

sub process_distro {
    my ($name) = @_;

    return if exists $data{distros}{$name};
    say STDERR "Processing distro $name";

    $data{distros}{$name} = undef;
    my $dist  = eval { $mcpan->release( distribution => $name ) };
    if ($@) {
        warn "Exception: $@";
        return;
    }
    $data{distros}{$name} = $dist;

    foreach my $dep (@{ $dist->{dependency} }) {
        process_module($dep->{module});
    }

    return;
}

sub process_module {
    my ($name) = @_;

    return if exists $data{modules}{ $name };
    say STDERR "Processing module $name";

    $data{modules}{ $name } = undef;
    my $module   = eval { $mcpan->module( $name ) };
    if ($@) {
        warn "Exception: $@";
        return;
    }
    $data{modules}{ $name } = $module;
    process_distro($module->{distribution});

    return;
}
```

This script starts with the name of a single module (Test::More in the example), recursively fetches all
the dependencies and saves them in a single hash.

The <b>%data</b> hash holds all the information. It has two main keys, <b>modules</b> and <b>distros</b>.
Under <b>modules</b>, each module name will have an entry, under <b>distros</b> each distribution will have an entry.

There are two subroutines, one for fetching the information of a module and the other for fetching the
information of a distribution. Once the data was fetched it is saved in the hash. Let's look at the
<b>process_module</b> subroutine. It received the name of the module as a parameter. The first thing it checks
if this module has already been processed. If it has, we call return. No need to fetch it again.

```perl
    return if exists $data{modules}{ $name };
```

Then there is a line just to show progress.

```perl
    say STDERR "Processing module $name";
```

We put <b>undef</b> in the field, so even if the fetching fails, we'll already have the key in the hash.
Using this will, ensure that we won't try to fetch the data again even if the first attempt failed.
That's the reason we use <b>exists</b> in the first line explained above.

```perl
    $data{modules}{ $name } = undef;
```

Next, we fetch the data from MetaCPAN, but we wrapped the call in an <b>eval</b> block to avoid die-ing.
If the call fails and throws an exception we catch it, print it using the <b>warn</b> call stop further
processing of this module by calling <b>return</b>.

```perl
    my $module   = eval { $mcpan->module( $name ) };
    if ($@) {
        warn "Exception: $@";
        return;
    }
```

If we successfully fetched the data from MetaCPAN, we save it in the hash and call the <b>process_distro</b>
function to process the distribution.

```perl
    $data{modules}{ $name } = $module;
    process_distro($module->{distribution});
```


The <b>process_distro</b> function is very similar, but because each distribution can depend on several modules, there
is a loop processing each module.

We know this recursive process will end as there is a finite number of CPAN modules and we made sure we don't try to
process the same module or distribution twice.

The script can also be found in the distribution of the [MetaCPAN::Clients](https://metacpan.org/pod/MetaCPAN::Clients) module.

## Caveat

As far as I know, MetaCPAN takes its information from the META.yml or META.json file that comes with every modern CPAN
distribution. This means that if a distribution does not supply the META file, or if the information within that file
is incorrect, then the data in MetaCPAN will be incorrect as well.

Normally the META files are generated when the developer builds and packs the distribution. The data is derived from
the content of Makefile.PL, Build.PL or dist.ini files depending on the packaging system the developer uses.

So the META files might be missing for old distributions or if the developer does not use any of the standard packaging
systems.

Even if the developer uses the right tools, the data in the META files can be incorrect, or not 100% correct.
Especially when the list of dependencies is dynamic. For example when the list of dependencies are different on
Windows and Linux and Mac OSX.

If the dependencies can be different based on some questions asked during the installation. (e.g. Which database
driver should be used? SQlite, MySQL, or PostgreSQL ?)

There can be optional dependencies adding optional features that won't be listed in the META files.

These dependencies can be resolved in a dynamic way during the installation process, but are not solved in the static
META files.


## What next?

Based on this solution we could build all kinds of interesting tools. For example,
I'd like to make sure that all the dependencies I use have licenses and list
the licenses so the legal department can check if we can use the modules.

Other possible use is to create a script that would tell me common dependencies of two modules,
or probably more interestingly, the list of dependencies that are not common. Assuming I already
have an application using a set of modules. I'd like to find out what additional dependencies
I am going to add if I start using module X?


What other task would you like to do?

If you are already using the MetaCPAN API, what do you use it for?

## Comments

Hi, Gabor!
Thanks for the solution.
Could you tell me if there's a command in the CPAN that shows me the dependencies of a module?
Thanks

<hr>

Hi Gabor, thanks for posting this such nice article. I have recently ran into this scenario where I want to install a set of packages on a remote system where no cpan access is available. only option is to first resolve the circular dependency problem, download the required packages and then proceed.

Tried running the program and its taking forever.. How much time generally does this take to solve just one? haven't tried a full list yet.

Any thoughts or ideas? Thank you in advance. cheers!


