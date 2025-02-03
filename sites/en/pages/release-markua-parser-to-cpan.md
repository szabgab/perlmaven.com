---
title: "Release the Markua::Parser to CPAN"
timestamp: 2020-06-07T22:33:01
tags:
  - files
published: true
books:
  - markua
author: szabgab
archive: true
---


If you are working on an in-house project you probably won't want to release it to CPAN. In that case you are welcome
to skip this part. However even it that case it might be useful for you to know how modules can be packaged for CPAN.
After all even for in-house project you might set up a private CPAN repository injecting your modules.
For that case it is a good idea to know how to package the code.

Some people will say it is too early to make an official release. After all we can only parse a very limited Markua syntax.

So why do I release it anyway and how do I do it?


## Getting feedback

One of the most important part of any development work, both proprietary and Open Source is the learning.
We need to learn what the clients really want. We need to understand the spec better. We need to make sure our code
runs on all the platforms we would like it to run.

The motto of Open Source "Release early, release often" says it very nicely.

For proprietary applications it is usually called Continuous Delivery and Continuous Deployment.

## CPAN Testers

I have some hope that after releasing the code to CPAN a few more people will look at it and comment on
it, but that's not the most important thing at this point.

Once I upload a module to CPAN it will be picked up by the [CPAN testers](http://www.cpantesters.org/)
and it will be tested in many Operating systems and many versions of Perl. A great way to make sure the code
works everywhere.

## Changes

The Changes file is the simplest at this point. It should list all the changes made since the previous
release, but as this is our first release we don't have much to do with it:

{% include file="examples/markua-parser/0764270/Changes" %}


## Add POD to the module

POD that stands for Plain Old Documentation is a markup language used in Perl to add user-documentation
to Perl code. We add a short explanation of what is this module and how to use it.

We also add some Copyright and License information.

{% include file="examples/markua-parser/0764270/lib/Markua/Parser.pm" %}

## Update Makefile.PL

Now that we have added the POD to the module, we can take the ABSTRACT from there.
We need to set the `LICENSE` field. We can include links to the GitHub repository
of the project to make it easier for visitors of [MetaCPAN](https://metacpan.org/)
to find the source code and contribute. There is some explanation about
the various fields in the article [Makefile.PL of ExtUtils::MakeMaker](/makefile-pl-of-extutils-makemaker).

{% include file="examples/markua-parser/0764270/Makefile.PL" %}

## MANIFEST and MANIFEST.SKIP

When we create the distribution we are going to run `make manifest` that will create a file
called `MANIFEST` and then it will use the content of that file to know which files to include
in the distribution.

The `MANIFEST.SKIP` file is a place where we can create rules which files to include in
the `MANIFEST` file and which not.

{% include file="examples/markua-parser/0764270/MANIFEST.SKIP" %}

## Creating the distribution

```
perl Makefile.PL
make
make test
make manifest
make dist
```

This will create a file called `Markua-Parser-0.01.tar.gz`. We can upload that to
[PAUSE](https://pause.perl.org/) the upload server of CPAN.

```
git add .
git commit -m "prepare files for the first release to CPAN"
git push
```

[commit](https://github.com/szabgab/perl5-markua-parser/commit/07642702d36d9705ebe23672e747e117d72b661c)

We also put a tag on this commit to make it easier to find the version that was used for this release.

```
git tag -m v0.01 -a v0.01
git push --tags
```


