---
title: "Eliminating indirect method calls"
timestamp: 2016-02-21T07:50:01
tags:
  - Objects::ProhibitIndirectSyntax
  - perlcritic
published: true
books:
  - cpan_co_maintainer
author: szabgab
archive: true
---


While in the <a href="">previous article</a> we seemed to have finished the refactoring based on Perl::Critic,
but in fact we have only covered level 5, the violation considered most important.

There are a few issues that are IMHO important but are categorized as level 4.

Specifically I am looking for eliminating the indirect method call syntax.


## Remove Exporter

Before going on though, I recall I saw in one of the files a `require Exporter;` while
the documentation says that the module does not export anything. Let's see what's going on there.

I used [ack](http://beyondgrep.com/) to search for the word `Exporter` in the source code
and indeed I found it in `lib/Pod/Tree.pm` in two places:

```
$ ack Exporter
lib/Pod/Tree.pm
7:require Exporter;
14:use base qw(Exporter);
```

When opening the file I looked for the word EXPORT (looking for `@EXPORT`, or `@EXPORT_OK`, or even `%EXPORT_TAGS`),
but none of them were present. This, as far as I understand means the [Exporter](https://metacpan.org/pod/Exporter) module does
not do anything there. We can safely remove both lines.

[commit](https://github.com/szabgab/Pod-Tree/commit/4fdc22b9ce39c64bd5c7c200d2449170410578eb)

## Better output format for Perl:Critic

Let's see now go back to Perl::Critic and see which ones of the level 4 policies
are violated by the code?

I ran

```
perlcritic -4 .
```

that generated way too much output. Partially because there are a lot of violation, but mostly because in
`.perlcriticrc` we set `verbose = 11` which generated 20-30 lines of explanation
for every violation. I'd like to have a more compact report.

After playing with the verbosity numbers I gave up and went to read the
[documentation of perlcritic](https://metacpan.org/pod/distribution/Perl-Critic/bin/perlcritic).
It shows that in addition to the numerical verbosity levels, one can build her own format using the
formatting place holders. The one I got settled (for now) looks like this:

```
perlcritic -4 --verbose "%f: [%p] %m at line %l, column %c.\n" .
```

It still prints a lot of lines because there are a lot of violations, but it only prints
one line per violation, and that line contains both the filename and the name of the violation.

This is especially useful if you'd like to fix the code
[one policy at a time](https://perlmaven.com/perl-critic-one-policy)
in several files.

We can even configure the verbosity in the `.perlcriticrc` file, but please note,
there should be no `"` in the configuration file. Mine looks like this now:

```
# please alpha sort config items as you add them

severity = 5
theme = core
verbose = %f: [%p] %m at line %l, column %c.\n
```

And we can now 
[commit](https://github.com/szabgab/Pod-Tree/commit/37317bf725feba651dd05f89a55062b897408bfc) this.

With this output format configured in `.perlcriticrc` we can run 
`perlcritic -4 lib/Pod/Tree.pm` to see the violations in a specific file.

```
lib/Pod/Tree.pm: [Subroutines::RequireFinalReturn] Subroutine "new" does not end with "return" at line 15, column 1.
lib/Pod/Tree.pm: [Subroutines::RequireFinalReturn] Subroutine "load_file" does not end with "return" at line 24, column 1.
lib/Pod/Tree.pm: [Objects::ProhibitIndirectSyntax] Subroutine "new" called using indirect syntax at line 29, column 11.
lib/Pod/Tree.pm: [Subroutines::RequireFinalReturn] Subroutine "load_fh" does not end with "return" at line 37, column 1.
lib/Pod/Tree.pm: [Objects::ProhibitIndirectSyntax] Subroutine "new" called using indirect syntax at line 44, column 15.
lib/Pod/Tree.pm: [Subroutines::RequireFinalReturn] Subroutine "load_string" does not end with "return" at line 56, column 1.
lib/Pod/Tree.pm: [Subroutines::RequireFinalReturn] Subroutine "load_paragraphs" does not end with "return" at line 69, column 1.
lib/Pod/Tree.pm: [Subroutines::RequireFinalReturn] Subroutine "loaded" does not end with "return" at line 83, column 1.
lib/Pod/Tree.pm: [Subroutines::RequireFinalReturn] Subroutine "_load_options" does not end with "return" at line 85, column 1.
lib/Pod/Tree.pm: [Subroutines::RequireFinalReturn] Subroutine "_parse" does not end with "return" at line 94, column 1.
lib/Pod/Tree.pm: [Subroutines::RequireFinalReturn] Subroutine "_add_paragraph" does not end with "return" at line 111, column 1.
lib/Pod/Tree.pm: [Subroutines::RequireFinalReturn] Subroutine "_make_nodes" does not end with "return" at line 136, column 1.
lib/Pod/Tree.pm: [Subroutines::RequireFinalReturn] Subroutine "_make_for" does not end with "return" at line 174, column 1.
lib/Pod/Tree.pm: [Subroutines::RequireFinalReturn] Subroutine "_make_sequences" does not end with "return" at line 190, column 1.
lib/Pod/Tree.pm: [Subroutines::ProhibitBuiltinHomonyms] Subroutine name is a homonym for builtin function dump at line 203, column 1.
lib/Pod/Tree.pm: [Subroutines::RequireFinalReturn] Subroutine "dump" does not end with "return" at line 203, column 1.
lib/Pod/Tree.pm: [Subroutines::RequireFinalReturn] Subroutine "get_root" does not end with "return" at line 208, column 1.
lib/Pod/Tree.pm: [Subroutines::RequireFinalReturn] Subroutine "set_root" does not end with "return" at line 210, column 1.
lib/Pod/Tree.pm: [Subroutines::ProhibitBuiltinHomonyms] Subroutine name is a homonym for builtin function push at line 215, column 1.
lib/Pod/Tree.pm: [Subroutines::RequireFinalReturn] Subroutine "push" does not end with "return" at line 215, column 1.
lib/Pod/Tree.pm: [Subroutines::ProhibitBuiltinHomonyms] Subroutine name is a homonym for builtin function pop at line 222, column 1.
lib/Pod/Tree.pm: [Subroutines::RequireFinalReturn] Subroutine "pop" does not end with "return" at line 222, column 1.
lib/Pod/Tree.pm: [Subroutines::RequireFinalReturn] Subroutine "walk" does not end with "return" at line 229, column 1.
lib/Pod/Tree.pm: [Subroutines::RequireArgUnpacking] Always unpack @_ first at line 236, column 1.
lib/Pod/Tree.pm: [Subroutines::RequireFinalReturn] Subroutine "_walk" does not end with "return" at line 236, column 1.
lib/Pod/Tree.pm: [Subroutines::RequireFinalReturn] Subroutine "has_pod" does not end with "return" at line 255, column 1.
lib/Pod/Tree.pm: [Modules::RequireEndWithOne] Module does not end with "1;" at line 263, column 1.
```

## Check for a single Perl::Critic policy

Among all these violation currently I am most interested in this one:

```
lib/Pod/Tree.pm: [Objects::ProhibitIndirectSyntax] Subroutine "new" called using indirect syntax at line 29, column 11.
```

Once I know the name of the policy I can use it and run the following:

```
perlcritic --single-policy Objects::ProhibitIndirectSyntax lib/Pod/Tree.pm 
```

to see specifically this violation in `lib/Pod/Tree.pm`.

This resulted in two hits:

```
lib/Pod/Tree.pm: [Objects::ProhibitIndirectSyntax] Subroutine "new" called using indirect syntax at line 29, column 11.
lib/Pod/Tree.pm: [Objects::ProhibitIndirectSyntax] Subroutine "new" called using indirect syntax at line 44, column 15.
```

I could also run it on all the directory tree using:

```
perlcritic --single-policy Objects::ProhibitIndirectSyntax .
```

which reports the same violation in many different places.

Alternatively, I could change the `.perlcriticrc` file adding these lines:

```
[Objects::ProhibitIndirectSyntax]
severity = 5
```

This will change the severity-level of this specific violation to level 5
and thus when we run

```
perlcritic .
```

this violation will be included as well.

This will be good later when we would like to be sure that the test script
we added to execute Perl::Critic includes this rule as well.
Unfortunately, because of the many places this issue happens, we would be overwhelmed by the
many reports. For now let's add these two lines to the `.perlcriticrc` file,
but let's keep them commented out.

[commit](https://github.com/szabgab/Pod-Tree/commit/e11a22367fc97f07ab4df38439456f4bc2b62caa)

## Replace indirect calls with direct calls

Then we can go on and replace the indirect calls such as

```perl
new Text::Template SOURCE => $tSource
```

by direct calls using the arrow syntax:

```perl
Text::Template->new( SOURCE => $tSource )
```

We can do this in the code, but also in the documentation!

See the [commit](https://github.com/szabgab/Pod-Tree/commit/45d8f7b1c55395214b1729ee55b79c870fb63090).

Then we can keep running `perlcritic --single-policy Objects::ProhibitIndirectSyntax .`
and keep fixing this issue in other files as well.

In all the modules:
[commit](https://github.com/szabgab/Pod-Tree/commit/ddf876292a36eb4e100e13c9b857f9fad92bce24)


In all the test scripts:
[commit](https://github.com/szabgab/Pod-Tree/commit/f5b202108c5da39730c4f0ce7c0e1e061d594632)

...and in the command-line scripts:
[commit](https://github.com/szabgab/Pod-Tree/commit/f82ff4dc54347ca473cab510c7f03d486ecfa614)

## Enable Objects::ProhibitIndirectSyntax

Finally we can enable the two lines in `.perlcriticrc` and let the regular tests check that
no indirect object calls enter the code.

[commit](https://github.com/szabgab/Pod-Tree/commit/820b1caaeea741d401538100541c58a942ccfe34)


