---
title: "Fixing the release. Twice in a row! (Pod::Tree 1.22 and 1.23)"
timestamp: 2016-02-23T07:25:01
tags:
  - MANIFEST
  - PAUSED
published: true
books:
  - cpan_co_maintainer
author: szabgab
archive: true
---


There were quite a few changes since [version 1.21 was released](/move-packages-to-their-own-files),
it might be time to cut a new release and let the [CPAN Testers](http://cpantesters.org/) do their thing.

Especially as they have already reported that version 1.21 was broken.


A few hour after I've [released version 1.21 of Pod::Tree](/move-packages-to-their-own-files)
Henk van Oers
[asked](https://github.com/szabgab/Pod-Tree/commit/3b7c800429d9b74350e8b3e5f16669115e94da0f#commitcomment-11278767)
on one of the changes that went into the release if I broke it. Specifically he wrote:

<pre>
Can't locate Pod/Tree/Stream.pm ...
Is the dist compete?
</pre>

So I went to [MetaCPAN](https://metacpan.org/release/Pod-Tree) and followed the link to the <b>Testers</b>
that lead me to the [CPAN Testers Matrix](http://matrix.cpantesters.org/?dist=Pod-Tree+1.21)
and to [main CPAN Testers page](http://www.cpantesters.org/distro/P/Pod-Tree.html?oncpan=1&distmat=1&version=1.21).
(Note, both links include the version number of the distribution and show the date relevant to that version.)

There I could see everything was red meaning all the test reports came in as failures.
I clicked on [one of the reports](http://www.cpantesters.org/cpan/report/9342e643-6c01-1014-889d-0738ad0c606e)
and there I could see the error message in more detail:

<pre>
Can't locate Pod/Tree/Stream.pm in @INC (you may need to install the Pod::Tree::Stream module) (@INC contains: ...
</pre>

Naturally we can't "install" Pod::Tree:Stream, we are the ones who are supposed to supply that module. So what is the problem?

Apparently, when I factored out the [packages to their own files](/move-packages-to-their-own-files)
I've forgotten to add the new file to the MANIFEST file and thus they were not added to the distribution.

The tests on my machine passed because the files were in the Git repository.
The tests run by Travis-CI passed, because they use a snapshot from the Git repository.

The tests run by someone who downloaded the distribution from CPAN failed, because some of the files were missing.

This means, that since the release of version 1.21, no one can install the module from CPAN. More specifically, the default installation
methods `cpan Pod::Tree` or `cpanm Pod::Tree` will fail. People can still install an older version of the module,
but for that they have to know how.

Luckily this is not a critical infrastructure module and probably very few people have tried to install it in the last few hours,
but I'd better fix it soon anyway.

But before that, let's see how could we avoid similar problems in the future? (Well, in the distant future I'll
change the system to automatically include all the files that I don't exclude, but for now we don't have that.)

## make disttest

In addition to the <b>make</b>-commands we have already seen, there is another command called <b>disttest</b>.

It prepares the directory with all the files that go into the distribution, just as `make dist` does,
but instead of creating a zip-file from the directory, it `cd`-s into it and runs the tests there.
In case we are getting ready to release version 1.21 of Pod-Tree, `make disttest` create a subdirectory called

`Pod-Tree-1.21/` then it will run:

```
cd Pod-Tree-1.21/
perl Makefile.PL
make
make test
cd ..
```

This means that if there is a file that need to be in the distribution but isn't then we have a good chance of catching it
even before we release the broken package.

You can try checking out the [version](https://github.com/szabgab/Pod-Tree/commit/3b7c800429d9b74350e8b3e5f16669115e94da0f)
that was used to build 1.21 and run 

```
perl Makefile.PL
make
make test
make disttest
```

You'll see the first run of the tests will pass, the second run will fail.


## add missing files to MANIFEST

Now that we know how could we avoid the problem, let's fix the problem.
I've added the 4 new pm files to the MANIFEST:

[commit](https://github.com/szabgab/Pod-Tree/commit/8b1b541d15b5cde28bd1286cce981a74bd600a1a)

Then I ran `make disttest` and noticed it is much faster than the regular test run.
That's what reminded me that I've also added 3 new test-files and none of them were added
to the MANIFEST file.

I had to fix that:
[commit](https://github.com/szabgab/Pod-Tree/commit/59e0718e2c22b3eabfb20d55a74e72cc35d97b63)


## Release 1.22

Now it seems I was ready to release the new version, and so I did:

[commit](https://github.com/szabgab/Pod-Tree/commit/fbceeffccf70344a6176d8d9b5501a7b31664b92).


## Indexing failed

Within a few seconds I got the first e-mail from PAUSE acknowledging the file-upload and within a minute or so
I got a second e-mail with the following subject line:

```
Failed: PAUSE indexer report SZABGAB/Pod-Tree-1.22.tar.gz
```

Inside the e-mail the failure report looked like this:

<pre>
Status of this distro: Decreasing version number
================================================

The following packages (grouped by status) have been found in the distro:

Status: Decreasing version number
=================================

     module : Pod::Tree::BitBucket
     version: undef
     in file: Pod-Tree-1.22/lib/Pod/Tree/BitBucket.pm
     status : Not indexed because Pod-Tree-1.20/lib/Pod/Tree/HTML.pm in
             S/SZ/SZABGAB/Pod-Tree-1.20.tar.gz has a higher version
             number (1.10)

     module : Pod::Tree::StrStream
     version: undef
     in file: Pod-Tree-1.22/lib/Pod/Tree/StrStream.pm
     status : Not indexed because Pod-Tree-1.20/lib/Pod/Tree/HTML.pm in
             S/SZ/SZABGAB/Pod-Tree-1.20.tar.gz has a higher version
             number (1.10)

     module : Pod::Tree::Stream
     version: undef
     in file: Pod-Tree-1.22/lib/Pod/Tree/Stream.pm
     status : Not indexed because Pod-Tree-1.20/lib/Pod/Tree.pm in
             S/SZ/SZABGAB/Pod-Tree-1.20.tar.gz has a higher version
             number (1.20)
</pre>

So apparently this release was also broken. It was so broken that it could not even be indexed by PAUSE.

It took me some time to figure it out, but the problem was again related to the new modules.
Earlier they were in a file that had a version number and PAUSE associated that version number
with all the packages in the specific pm file. When I move the package to a separate file
that new file did not include a version number. So now PAUSE sees the version number
of these packages as `undef`.

For some, probably obvious, reason PAUSE will not index any module that has a smaller version number
than the most recently indexed version of that module. The file will still be on CPAN and people will
still be able to install it, but those who rely on the default installation method won't install this release.
This seems to be a reasonable security measure.

In the longer run I wanted to fix the version numbers and make the the same in all of the module so
now that have to add version numbers to the new files, I can also start doing that.

I quickly added version number to all the modules and release version 1.23:

[commit](https://github.com/szabgab/Pod-Tree/commit/8adfa59893f10965790a19ce88ac5ed2403b2fe2)

A few minutes after uploading to PAUSE, I got the two e-mails. The indexing worked.

Actually there were more than 3 modules without version numbers, but apparently those that were without
in 1.22, have never had a version number. Now they have.

