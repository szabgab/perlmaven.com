---
title: "The value of a clean Continuous Integration (CI) system (for Data-Trace)"
timestamp: 2022-10-07T16:00:01
tags:
  - Data::Trace
  - GitHub
published: true
types:
  - screencast
author: szabgab
archive: true
show_related: true
---


One of the difficult things while introducing Continuous Integration (CI) on a clean environment is convincing people that there is value in it.
I got lucky when  I was adding GitHub Actions as a CI system to the [Data-Trace](https://metacpan.org/dist/Data-Trace) distribution
as I can now demonstrate the value.


{% youtube id="Z1YGYWUVLhw" file="perl-the-value-of-clean-ci-for-data-trace.mp4" %}

I found the distribution on [CPAN Digger](https://cpan-digger.perlmaven.com/) as a recently uploaded distribution that does not have any CI configured.

I cloned the repository and tried to run the tests:

```
cpanm --installdeps .
perl Build.PL
perl Build
perl Build test
```

The tests passed, but I noticed that some of them were skipped:

```
t/00-load.t .......... 1/? # Testing Data::Trace 0.07, Perl 5.034000, /usr/bin/perl
t/00-load.t .......... ok
t/01-usage-simple.t .. ok
t/manifest.t ......... skipped: Author tests not required for installation
t/pod-coverage.t ..... skipped: Author tests not required for installation
t/pod.t .............. skipped: Author tests not required for installation
All tests successful.
Files=5, Tests=17,  1 wallclock secs ( 0.02 usr  0.00 sys +  0.29 cusr  0.05 csys =  0.36 CPU)
Result: PASS
```

So I ran the tests again, this time with the **RELEASE_TESTING** environment having a true value.

```
RELEASE_TESTING=1 perl Build test
```

```
t/00-load.t .......... 1/? # Testing Data::Trace 0.07, Perl 5.034000, /usr/bin/perl
t/00-load.t .......... ok
t/01-usage-simple.t .. ok
t/manifest.t ......... skipped: Test::CheckManifest 0.9 required
t/pod-coverage.t ..... 1/2
#   Failed test 'Pod coverage on Data::Tie::Watch'
#   at /usr/share/perl5/Test/Pod/Coverage.pm line 133.
# Coverage for Data::Tie::Watch is 71.4%, with 2 naked subroutines:
#   base_watch
#   callback
# Looks like you failed 1 test of 2.
t/pod-coverage.t ..... Dubious, test returned 1 (wstat 256, 0x100)
Failed 1/2 subtests
t/pod.t .............. ok

Test Summary Report
-------------------
t/pod-coverage.t   (Wstat: 256 Tests: 2 Failed: 1)
  Failed test:  2
  Non-zero exit status: 1
Files=5, Tests=21,  0 wallclock secs ( 0.02 usr  0.01 sys +  0.39 cusr  0.06 csys =  0.48 CPU)
Result: FAIL
Failed 1/5 test programs. 1/21 subtests failed.
```

Now, as you can also see, some of the tests failed.

It is clear that the author wants to have these tests verify something (and for our purposes it does not matter what),
but has forgotten to run the "author tests" recently.

This is when I thought I have an opportunity to show the usefulness of a CI system.

One thing I also missed in this report was that one of the tests was still skipped because I did not have Test::CheckManifest installed.

## GitHub Action configuration file

I added the following configuration file as **.github/workflows/ci.yml** and pushed out the changes to my forked version of the repository.

{% include file="examples/data-trace-ci.yml" %}

The first version of the file looked like the above, but did not have the line:

```
  cpanm Test::CheckManifest Test::Pod::Coverage Test::Pod
```

and the following two lines were enabled:

```
      #env:
      #  RELEASE_TESTING: 1
```

The CI job passed on Linux and Mac, but failed on Windows.

The reason was that on Linux and Mac none of the modules that were required for the author tests were installed and thus those tests were skipped.

The condition to run the tests was having the RELEASE_TESTING environment variable on and having the required extra modules installed.

On Windows, however, we use Strawberry Perl and apparently it already comes with some of the extra modules installed. So there some of the
author tests were executed and one of them failed.

## Install extra dependencies

The next step was to install the required extra modules on the CI system as well by adding the following line:

```
  cpanm Test::CheckManifest Test::Pod::Coverage Test::Pod
```

This time the tests failed on all 3 platforms and to my surprise there were more failures than on my local computer.

That was the point when I checked again and saw that earlier I missed this skip on my local computer.


## Disable Author tests

Having seen the author tests fail on the CI-system I commented out the setting of the environment-variables
and by that disabled the author tests.
This time all the tests passed on all 3 platforms.

That's how I sent the Pull-Request.

The reasons is that the CI system should **always** pass.

If the authors accepts the PR, they will have a working CI system. They might not have the time to fix these issues
now, but at least the regular tests pass on the CI and they will be notified by email if one of the regular test
fails.

When they have time to fix these issues they will only need to enable the environment variable and from that point on
the author tests will also be executed on every push.








