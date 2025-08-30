---
title: "Finding files in a directory tree using Perl"
timestamp: 2013-09-09T23:30:00
tags:
  - Path::Iterator::Rule
  - recursive
  - directory tree
published: true
author: szabgab
---



There are several ways to traverse a directory tree in Perl. It can be done with the function
calls `opendir` and `readdir` that are part of the Perl language.
It can be done using the `File::Find` module that comes with Perl.

In this article we'll look at [Path::Iterator::Rule](https://metacpan.org/pod/Path::Iterator::Rule).


## Overview: The Rule, all and iter

In order to use the module we need two things:

1. First we create a Path::Iterator::Rule object representing a set of rules.
1. Then we can use that object to list the file-system elements in a certain list of directories.

The first step is to create the rules:

```perl
use Path::Iterator::Rule;
my $rule = Path::Iterator::Rule->new;
```

This rule object has no restrictions yet, we'll see those later. It will return every
item in the file-system. Once we have the `$rule` object, we use that to traverse the directories.
The traversing can be done in two ways:

1. The `all` method will traverse the given directories and return a list of file-system
elements: `my @files = $rule->all( @dirs )`.
We then probably go over the list using a `for` loop:

```perl
for my $file ( $rule->all( @dirs ) ) {
    say $file;
}
```

2. The `iter` method will return an iterator. `my $it = $rule->iter( @dir );`.
Then we can retrieve the file-system elements one-by-one by
dereferencing the iterator code-reference:

```perl
my $it = $rule->iter( @dir );
while ( my $file = $it->() ) {
    say $file;
}
```

(`$it` is a reference to a subroutine. With the `$it->()` syntax we call the underlying
subroutine without passing to it any parameter.)

Calling `all` will ensure that changes to the directory structure during the `for-loop`
won't alter the result. If we are processing a large directory structure, however, this requires a long
up-front time spent collecting the items, and a much bigger memory allocation,
than in the case of the `iter` method.

## Basic examples

Let's see two basic examples for the above two cases. We expect the user to
provide the list of directories on the command line. Hence we pass `@ARGV`
as the list of directories, to the `all` and `iter` methods.

The first example uses the `all` method to collect all the
matching file-system elements in the memory:

```perl
use strict;
use warnings;
use 5.010;

use Path::Iterator::Rule;

die "Usage: $0 DIRs" if not @ARGV;

my $rule = Path::Iterator::Rule->new;

for my $file ( $rule->all( @ARGV ) ) {
    say $file;
}
```

In the second example, we use the `iter` method to create an iterator,
and then call it repeatedly to get all the matching file-system elements:

```perl
use strict;
use warnings;
use 5.010;

use Path::Iterator::Rule;

die "Usage: $0 DIRs" if not @ARGV;

my $rule = Path::Iterator::Rule->new;

my $it = $rule->iter( @ARGV );
while ( my $file = $it->() ) {
    say $file;
}
```

## Rules

After seeing the basics, the really interesting part is setting the rules. So let's see a few of them:

### size

```perl
$rule->size("> 1000");
```

means only find files larger than 1000 bytes.

The same could be expressed as

```perl
$rule->size("> 1k");
```

(1k = 1000, and 1ki = 1024, in accordance with the
[IEC standard](http://physics.nist.gov/cuu/Units/binary.html) as implemented
by [Number::Compare](https://metacpan.org/pod/Number::Compare).)

Similarly one could write

```perl
$rule->size("< 1000");
```

to find the smaller files.

We can even combine the two:

```perl
$rule->size("< 1024")->size("> 1000");
```

In general we can **stack rules on the other**

### file-name

```perl
$rule->name("*.xml");
```

will only find files with xml extension and

```perl
$rule->name("*.pm");
```

will only find files with pm extension.

Because it is a Perl module, for the latter we even have a special rule:

```perl
$rule->perl_module;
```

will also match the pm files only.

Of course if we would like to match any Perl file, we can use the
appropriate rule:

```perl
$rule->perl_file;
```

### negative rules

What if we want to find all the non-pm files?
First we create a rule that means "not pm file",
then we can use this rule in a **boolean rule-expression**:

```perl
my $no_pm_rule = $rule->clone->name("*.pm");
$rule->not( $no_pm_rule );
```

Please note, we have to `clone` the rule, our rule would
be both **only match pm** and **only match not pm**. That would be an empty set.

If we don't intend to reuse it later, we don't even need to save the new rule in
a variable. We can write this:

```perl
$rule->not( $rule->clone->name("*.pm") );
```

Even better, most of the rules already have a negative version so we can write this:

```perl
$rule->not_name("*.pm");
```

### directory depth

All the elements that are at least 4 subdirectory deep from the one passed to the
`iter` method:

```perl
$rule->min_depth(4);
```

Don't go deeper than 3 subdirectories:

```perl
$rule->max_depth(3);
```

If we pass 0 to `max_depth` we will get only the directories we passed to `iter`.
If `max_depth` is 1, we will get the immediate content of those directories.

### skipping directories

If you are familiar with [ack](http://beyondgrep.com/), you know it automatically skips the
**.git** directory.
How can we achieve the same?
We create a cloned rule that matches the ".git" and then we tell our main rule to `skip` those matches

```perl
$rule->skip( $rule->clone->name(".git") );
```

Of course, because skipping directories is a very common task, it has its own rule:

```perl
$rule->skip_dirs(".git");
```

But, then again, skipping the .git directory is really, really common, so it has its own rule:

```perl
$rule->skip_git;
```

Of course ack skips the meta directories of all the version control system, so we should be able to do
that too:

```perl
$rule->skip_vcs;
```

(See the [documentation](https://metacpan.org/pod/Path::Iterator::Rule) to understand the specifics.)

If you are not familiar with [ack](http://beyondgrep.com/), it is a perfect time to install it and start using it!

### peek in the files

Lastly, let's see how can we set rules based on the content of the files:

```perl
$rule->contents_match(qr/package/);
```

Obviously this can slow down the traversing quite a bit,
as this will require reading the file, but it can be very convenient.

## An example

Lastly, let's see a full example where we combine several rules
in a nicely formatted way:

```perl
use strict;
use warnings;
use 5.010;

use Path::Iterator::Rule;

die "Usage: $0 DIRs" if not @ARGV;

my $rule = Path::Iterator::Rule->new;
$rule->size("> 1000")
     ->perl_file
     ->contents_match(qr/package/);


my $it = $rule->iter( @ARGV );
while ( my $file = $it->() ) {
    say $file;
}
```

If you like this module, please send a thank-you note to
[David Golden](https://metacpan.org/author/DAGOLDEN), the author.

## Comments

I am getting the following errors while trying to use your example:
Can't locate Path/Iterator/Rule.pm in @INC (@INC contains: /usr/lib/perl5/5.10.0/x86_64-linux-thread-multi /usr/lib/perl5/5.10.0 /usr/lib/perl5/site_perl/5.10.0/x86_64-linux-thread-multi /usr/lib/perl5/site_perl/5.10.0 /usr/lib/perl5/vendor_perl/5.10.0/x86_64-linux-thread-multi /usr/lib/perl5/vendor_perl/5.10.0 /usr/lib/perl5/vendor_perl .)

---

You need to install Path::Iterator::Rule https://perlmaven.com/cant-locate-inc-module-install-in-inc

---

I have used : /pkg/qct/software/perl/5.22.0/bin/perl, and it is working


