---
title: "Bumping version numbers in all the modules at once"
timestamp: 2017-09-29T18:30:01
tags:
  - perl-version
  - Perl::Version
published: true
books:
  - cpan_co_maintainer
author: szabgab
archive: true
---


When you maintain a Perl distribution that has several modules, one approach to handle the version numbers of the modules
in the distribution is to always set the to the same number. This means you might update the versiion number of a file
even if you have not changed it, but it makes it a lot easier to know from which distrbution does a file come from.

Manualy updating all the files is a waste of time.

The [Perl::Version](https://metacpan.org/pod/Perl::Version) module can help you setting the version using one command.


For this to work you need to install the Perl::Version module.

```
cpanm Perl::Version
```

that unfortunately, as of version 1.013 it does not automatically install the sample script.
So you'll also need to dowmload that.

Visit [Perl::Version](https://metacpan.org/pod/Perl::Version), find the "Dawnload" link
and download the tar.gz file. Unizp it using <b>tar xzf ...</b> and then copy the <b>perl-version</b>
file from the <b>examples</b> directory.

The following command will also work, at least as long as version 1.013 is on CPAN.

```
wget https://fastapi.metacpan.org/source/BDFOY/Perl-Version-1.013/examples/perl-reversion
```

Made the <b>perl-version</b> file executable:
```
chmod +x perl-version
```

And tried to run it:

```
./perl-version
```


```
$ ./perl-reversion --bump-version
Scanning lib/Pod/Tree/PerlMap.pm 1.25
Scanning META.yml 1.17
Scanning lib/Pod/Tree.pm 1.25
Scanning lib/Pod/Tree/HTML/PerlTop.pm 1.25
Scanning lib/Pod/Tree/HTML/LinkMap.pm 1.25
Scanning lib/Pod/Tree/PerlTop.pm 1.25
Scanning lib/Pod/Tree/PerlBin.pm 1.25
Scanning lib/Pod/Tree/StrStream.pm 1.25
Scanning lib/Pod/Tree/PerlFunc.pm 1.25
Scanning lib/Pod/Tree/PerlDist.pm 1.25
Scanning lib/Pod/Tree/HTML.pm 1.25
Scanning lib/Pod/Tree/PerlPod.pm 1.25
Scanning lib/Pod/Tree/PerlUtil.pm 1.25
Scanning lib/Pod/Tree/BitBucket.pm 1.25
Scanning lib/Pod/Tree/Pod.pm 1.25
Scanning lib/Pod/Tree/Stream.pm 1.25
Scanning lib/Pod/Tree/Node.pm 1.25
Scanning lib/Pod/Tree/PerlLib.pm 1.25
Scanning README 2
Found versions 1.17, 1.25 and 2. Please use
the --current option to specify the current version
```

