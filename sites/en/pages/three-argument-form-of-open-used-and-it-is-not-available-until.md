---
title: "Three-argument form of open used and it is not available until perl 5.6."
timestamp: 2016-06-15T07:30:01
tags:
  - Perl::Critic
  - Compatibility::ProhibitThreeArgumentOpen
  - Compatibility::PerlMinimumVersionAndWhy
published: true
author: szabgab
archive: true
---


The [Perl-Critic-Compatibility](https://metacpan.org/release/Perl-Critic-Compatibility) distributions
provides an additional policy for [Perl::Critic](/perl-critic) called
[Compatibility::ProhibitThreeArgumentOpen](https://metacpan.org/pod/Perl::Critic::Policy::Compatibility::ProhibitThreeArgumentOpen).

If your code violates it you'll get a message:

<pre>
Three-argument form of open used at ...  Three-argument open is not available until perl 5.6.
</pre>

but I think this is mostly a distraction.


Normally you should use [use 3-argument open](/always-use-3-argument-open), but that
does not work on perl before version 5.6 came out in 2000. If you have an environment where you need
to use an older version of Perl, I'd suggest you run away. I am not sure what an older version of perl would do
if it encountered a 3-argument open. Would in give a syntax error or would in misunderstand it? Probably the former
so you don't really need a Perl::Critic policy for it.

Nevertheless this policy exists, and if you are not careful, and someone runs perl critic on your code with this
module being installed you'll get a report. Just as [I did](/fix-perl-critic-test-failures-reported-by-cpantesters).


## Example

Let's see an example that will trigger this report:

{% include file="examples/three_argument_open.pl" %}

If I run

```
$ perlcritic --single-policy Compatibility::ProhibitThreeArgumentOpen three_argument_open.pl 
```

I'll get:

<pre>
Three-argument form of open used at line 2, column 1.  Three-argument open is not available until perl 5.6.  (Severity: 5)
Three-argument form of open used at line 4, column 1.  Three-argument open is not available until perl 5.6.  (Severity: 5)
</pre>

Using [old-style open](/beginner-perl-maven-old-style-open) is out of the question, so how could we
make sure we don't get this report?

There are a number of ways to [solve the report problem](/fix-perl-critic-test-failures-reported-by-cpantesters)
in the generic case, but in the specific case we can actually do better.

We can declare in the code that we require a version of perl which is version 5.6 or later.

If we add


```perl
use 5.006;
```

or if we require some later version of Perl:

```perl
use 5.010;
```

then we won't get the above policy violation report.

Having the minimum version number declared early in the code is actually a good idea.
It will help you avoid needing to deal with reports about syntax errors when someone
runs your code on a version of perl older than what you were expecting.

## Setting minimum version

The requirement of a minimum version of perl for 3-argument open is just one special case among
many cases when certain constructs require a minimum version of perl.

There is another [Perl::Critic](/perl-critic) policy that will check the code for
any such violation, and will report what is the minimum version of perl needed for a specific piece
of code.

The policy is called 
[Compatibility::PerlMinimumVersionAndWhy](https://metacpan.org/pod/Perl::Critic::Policy::Compatibility::PerlMinimumVersionAndWhy)
and it is part of the [Perl-Critic-Pulp](https://metacpan.org/release/Perl-Critic-Pulp) distribution.

If we run 

```
$ perlcritic --single-policy Compatibility::PerlMinimumVersionAndWhy three_argument_open.pl 
```

We'll get the following report:

```
_Pulp__open_my_filehandle requires 5.006 at line 2, column 1.  (no explanation).  (Severity: 2)
_three_argument_open requires 5.006 at line 2, column 1.  (no explanation).  (Severity: 2)
```

It explains which construct in your code set which minimum requirements.

Including

```perl
use 5.006;
```

will silence this policy as well.


## Conclusion

I don't recommend the use of the 
[Compatibility::ProhibitThreeArgumentOpen](https://metacpan.org/pod/Perl::Critic::Policy::Compatibility::ProhibitThreeArgumentOpen)
policy, but I recommend the 
[Compatibility::PerlMinimumVersionAndWhy](https://metacpan.org/pod/Perl::Critic::Policy::Compatibility::PerlMinimumVersionAndWhy)
and the inclusion of [minimum version numbers in your source code](/set-minimum-version-in-every-perl-file).




