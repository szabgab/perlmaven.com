---
title: "Getting Started with Perl::Critic (the linter for Perl)"
timestamp: 2018-01-21T11:30:01
tags:
  - Perl::Critic
  - perlcritic
published: true
author: szabgab
archive: true
---


It seems I've written quite a few [articles about Perl::Critic](/perl-critic), but still when I got to a new
client I was not sure how to get started. I had to assemble it from several of my blog-post and from sever open source
projects I am involved in. So here is a quick starter that works for me.


Install Perl::Critic

Create a file called `.perlcriticrc` with the following:

```
severity = 5
#verbose = 11
#verbose = %f: [%p] %m at line %l, column %c.\n%d\n
verbose = %f: [%p] %m at line %l, column %c.\n
theme = core

[TestingAndDebugging::RequireUseWarnings]
severity = 5

[Modules::ProhibitEvilModules]
modules_file = .forbidden_modules
```

Create the `.forbidden_modules` file with the following:

```
Switch           Use if, elsif instead of the deprecated Switch module
Fatal            Use autodie instead of Fatal
```

run `perlcritic *` on all the perl files.


If you've never used Perl::Critic on this code, and if this is a relatively old codebase you will probably get tons of violations reported.
Within the square brackets (`[]`) of each line you will find the name of each policy violation that you can look up in our
[list of Perl::Critic policies](/perl-critic).

You will need to look at one or two cases of each violation type and read why is that a problem.

If you change the configuration file and allow the `verbose` mode with the `%d` then you'll get extensive explanation
right in the report. That can be useful at this point though it can be rather annoying as well.

You probably won't be able to fix all of them at once so you will need to prioritize and you will need to decide how do you prefer to fix the problems.
Go file-by-file and fix all the violations or go [violation-by-violation](/perl-critic-one-policy) and go through the whole code-base fixing it everywhere.

While we were only using level 5, the most important violations, even among these there are more important ones.

The best strategy might be to prioritize the policies, and go file-by-file fixing the most important violations first.

In order to avoid getting reports about violations that you don't want to deal with now, you can add a few lines
to the `.perlcritic` file to skip specific violations. The way I do this is that I look at the output
of the `perlcritic` command on my files and based on the policies that this code violates I create the file.

```
[-Modules::RequireBarewordIncludes]
[-BuiltinFunctions::ProhibitStringyEval]
[-InputOutput::ProhibitBarewordFileHandles]
[-InputOutput::ProhibitTwoArgOpen]
[-Subroutines::ProhibitExplicitReturnUndef]
[-TestingAndDebugging::RequireUseStrict]
[-Subroutines::ProhibitSubroutinePrototypes]
 
[-Variables::ProhibitConditionalDeclarations]
[-TestingAndDebugging::ProhibitNoStrict]
[-BuiltinFunctions::ProhibitSleepViaSelect]
[-Variables::RequireLexicalLoopIterators]
[-ClassHierarchies::ProhibitOneArgBless]
[-Modules::RequireFilenameMatchesPackage]
[-ControlStructures::ProhibitMutatingListFunctions]
[-ValuesAndExpressions::ProhibitLeadingZeros]
[-BuiltinFunctions::RequireGlobFunction]
[-Subroutines::ProhibitReturnSort]
[-InputOutput::ProhibitInteractiveTest]
```

I can't really tell what should be the priority for you and for your code-base.

I'd certainly prioritize [use strict](/strict) and [use warnings](/always-use-warnings) very hight,
but it might be a lot of work and there might be some resistance in the organization.

Some of the others might also be seen as revealing bugs immediately so it might be easier to get support for
fixing those first.


