---
title: "Perl::Critic exclude some policies - fix others (Pod::Tree 1.24)"
timestamp: 2016-03-05T08:05:01
tags:
  - Perl::Critic
published: true
books:
  - cpan_co_maintainer
author: szabgab
archive: true
---


Earlier we used [Perl::Critic](/perl-critic) only at level 5, asking for the most gentle criticism, but there are quite a few
additional policies at level 4 that are quite important. We have already [seen](/eliminating-indirect-method-calls)
what happens if we run `perlcritic` at level 4. Tons of policy violations.


We have already tried the [one policy at a time strategy](/perl-critic-one-policy), when
we set the level of the
[Objects::ProhibitIndirectSyntax](https://metacpan.org/pod/Perl::Critic::Policy::Objects::ProhibitIndirectSyntax)
policy to be level-5. That [worked well](/eliminating-indirect-method-calls)

Let's try something else now.

## Set severity = 4, exclude some policies

We can look at the list of policy violations and and instead of fixing them, we can first just exclude them. The format
we [defined earlier](/eliminating-indirect-method-calls) now comes very handy.
Each line includes the name of the violation. We can copy those names and put them in the `.perlcriticrc` file with
a dash in-front of them. That means they are excluded from being checked.

After going over the report, excluding some violations, running perlcritic again and repeating this several times, I reach this
`.perlcriticrc` file:

```
# please alpha sort config items as you add them

severity = 4
theme = core
verbose = %f: [%p] %m at line %l, column %c.\n

[Objects::ProhibitIndirectSyntax]
severity = 5

[-InputOutput::RequireBriefOpen]
[-Modules::ProhibitMultiplePackages]
[-Modules::RequireEndWithOne]
[-Modules::RequireExplicitPackage]
[-Subroutines::ProhibitBuiltinHomonyms]
[-Subroutines::RequireArgUnpacking]
[-Subroutines::RequireFinalReturn]
[-TestingAndDebugging::RequireUseWarnings]
[-ValuesAndExpressions::ProhibitCommaSeparatedStatements]
[-ValuesAndExpressions::ProhibitConstantPragma]
[-Variables::RequireLocalizedPunctuationVars]
```

After that I could run `perlcritic .` and it did not report any violation.

[commit](https://github.com/szabgab/Pod-Tree/commit/8393e8ca953147763997d0e64ee01c33255ff014).

Now we can check for these policies [one-by-one](/perl-critic-one-policy), fix the some of the modules
and then go on. Once I fix all the code for a specific policy, I can remove that policy from the exclude list.

## InputOutput::RequireBriefOpen

[InputOutput::RequireBriefOpen](https://metacpan.org/pod/Perl::Critic::Policy::InputOutput::RequireBriefOpen)
might not be an earth shattering policy, but it can make it easier to read the code. In a nutshell, it stipulates
that we should call `close` soon after we called `open`. Sounds reasonable.

This [commit](https://github.com/szabgab/Pod-Tree/commit/2d44e9dbcf23aa16c7f660f62055b4d08c932d48) fixed
it in two modules, but the issue remained in some of the test scripts in the `FileCmp` functions.
I did not want to fix those as I think I am going to replace those functions by a module that will have better
error reporting if and when the compared files are not the same.

So I kept the policy in the exclude list.


## Modules::ProhibitMultiplePackages

[Modules::ProhibitMultiplePackages](https://metacpan.org/pod/Perl::Critic::Policy::Modules::ProhibitMultiplePackages)
requires that we won't have more than one `package` in every module.


Running `perlcritic --single-policy Modules::ProhibitMultiplePackages .` revealed that we have this issue in
`t/mapper.t` and in `lib/Pod/Tree/HTML.pm`. Actually we had the same issue in several other modules
but we have already [factored out several packages to their own files](/move-packages-to-their-own-files).
So we only had to fix one module.

Learning from the [earlier mistakes](/fixing-the-release-adding-version-numbers), this time I remembered that I have to add
`lib/Pod/Tree/HTML/LinkMap.pm`, the new filename to `MANIFEST`.
I've also included `our $VERSION = '1.23';` in the new file to satisfy the
[version number rules](/consistent-version-numbers-of-modules).
I also added a `1;` at the end of the new file. Just because I am quite used to that.

I did not want to fix the test script at this time as that's not even a module by itself. We'll see what to do there later.

[commit](https://github.com/szabgab/Pod-Tree/commit/49d50ae5d0fdc2c1b189813d9419643212c04601)

## Modules::RequireExplicitPackage

At first I was not sure what does the 
[Modules::RequireExplicitPackage](https://metacpan.org/pod/Perl::Critic::Policy::Modules::RequireExplicitPackage)
policy really want in the modules. I know it complains about script that don't have `package` keyword and that's
fine, but as far as I remembered all of the `pm` files in the distribution had a `package` statement in them.
Then after reading the documentation I understood. The `package` statement needs to be the first statement in the file.
Only comments and POD can precede it.

This makes sense. I'd go further and I'd even like to enforce a certain order of the `use` statement,
but I am not sure if there is such policy. Maybe I could write one.

In any case, in this [commit](https://github.com/szabgab/Pod-Tree/commit/4e67664c57b5099e8c7bc1b7316461457e2dac14) the
`package` statements were moved to the beginning of the `pm` files.

## TestingAndDebugging::RequireUseWarnings

[TestingAndDebugging::RequireUseWarnings](https://metacpan.org/pod/Perl::Critic::Policy::TestingAndDebugging::RequireUseWarnings)
requires that every file have `use warnings;` at the beginning. (After the `package` statement if it is in the file.)

We have [mostly implemented this already](/use-strict-use-warnings-no-diagnostics), but apparently there was one more
file that did not have `use warnings;` in it.

This [commit](https://github.com/szabgab/Pod-Tree/commit/f11a84c6c2d6a04abd8f58bdba581afe9f46b7b5) fixed it. I could also remove the `[-TestingAndDebugging::RequireUseWarnings]` from the `.perlcriticrc` file.

## Subroutines::RequireArgUnpacking

The idea behind [Subroutines::RequireArgUnpacking](https://metacpan.org/pod/Perl::Critic::Policy::Subroutines::RequireArgUnpacking)
is that one should not access `@_` or `$_[..]` in a middle of a function. The content of `@_` need to be copied ("unpacked")
into local lexical variables. That makes sense as this puts all the argument handling at the top of the function. I'd go even further, at least
in code I maintain, and restrict it to the use of `@_` (no `shift`), but let's go one step at a time.

In most of the modules, the issue could be fixed just by moving the assignment of `@_` to the first row of the subroutine.
In one module though I even had to introduce a new variable, so the code won't access `$_[0]` in the middle of the subroutine.

## Release of version 1.24

With this we have arrived to the release of version 1.24 of Pod::Tree.
We had to update the Changes file and the version number in every module, and then we could release the module to CPAN.

[commit](https://github.com/szabgab/Pod-Tree/commit/8cdd7ea78c78a0ff5fac4eecd33756ad8551def5)

