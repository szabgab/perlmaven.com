---
title: "Fixing test failure on Windows - Properly quoting regexes - Accepting GitHub pull request"
timestamp: 2017-10-10T13:30:01
tags:
  - GitHub
published: true
books:
  - cpan_co_maintainer
author: szabgab
archive: true
---


[A. Sinan Unur](https://www.nu42.com/) who recently put a lot of effort into Windows compatibility
of Perl modules opened an [issue](https://github.com/szabgab/Pod-Tree/issues/6) and reported the tests
of [Pod::Tree](https://metacpan.org/pod/Pod::Tree) failing with perl compiled using MSVC 2013 on Windows 10. 

He quickly followed it with a [pull request](https://github.com/szabgab/Pod-Tree/pull/7) fixing the problem.


In case you are not familiar with it, a <b>pull-request</b> is a notification of a change (or a bunch of changes)
made by someone for one of your GitHub repositories. You can either accept them and merge them into your repository,
or you can reject them, or something in-between. For example you can add comments to it and as the author of those changes
to make further adjustments before you can merge the changes.


In this case the change was really simple. 

This line

```perl
$pod =~ s(^$PodDir/)();
```

was replaced by this line:

```perl
$pod =~ s(^\Q$PodDir\E/)();
```

The problem was that the `$PodDir` could contain characters that would be interpreted by the regex engine as special characters
even though what we wanted was exact matchig.
Specifically there was a sequence of characters starting with a back-slash (`\`) character that looked like a Unicode property definition
but that was invalid. See the [error report](https://github.com/szabgab/Pod-Tree/issues/6).

The `\Q` character tells the regex engine to treat every character in the regex as regular character with no special meaning
from that point till the end of the regex or till it encounters `\E`. So as far as I know the `\E` at the end was not
required for this solution, but being explicit with it makes the code clearer.


## Accepting the Pull-request

I got an e-mail notification about the Pull-request with a link. Following that link I could easily see the changes Sinan made.
As I have [Travis-CI](/enable-travis-ci-for-continous-integration) on this repository,
I could also see that not test was broken by this change. At least not on Linux.
With the click of a button on the GitHub UI, I could merge the pull-request.

The original [commit by Sinan](https://github.com/szabgab/Pod-Tree/commit/3969622b626e9fa892b88177ede11c4fb2366df2).

The [commit merging his changes](https://github.com/szabgab/Pod-Tree/commit/570e218e9c590fc68556217cf5bfb2d8c6aeae7a).

