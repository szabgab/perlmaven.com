---
title: "Removal of the current directory (".") from @INC in Perl 5.26 and Travis-CI"
timestamp: 2017-11-29T10:30:01
tags:
  - Travis-CI
  - @INC
  - PERL_USE_UNSAFE_INC
published: true
author: szabgab
archive: true
---


Perl used to have ".", the current directory in [@INC](/search/@INC), the list of directories it uses to load modules from.
due to security concerns in Perl 5.26 it was removed. That means code that relied on "." will break when you upgrade to Perl 5.26.

The Perl delta explains
[how to deal with the removal](https://metacpan.org/pod/release/XSAWYERX/perl-5.26.0/pod/perldelta.pod#Removal-of-the-current-directory-%28%22.%22%29-from-@INC) safely and not so safely.

As of 29 November 2017 when you use [Travis-CI](https://travis-ci.org/), the leading Continuous Integration system of the Open Source world, you will see that the `PERL_USE_UNSAFE_INC` environment variable was set to 1 that tells Perl to add "." back to `@INC` restoring the potential security issue. This is however, as I learned after [reporting the issue](https://github.com/travis-ci/travis-ci/issues/8822), is not done by Travis itself. It was done by [Test::Harness](https://metacpan.org/pod/Test::Harness) that is used in the "make test" phase.

I think this is a bad idea.


This setting, unfortunately does not reflect the harsher natural environment your code will run in and thus the setting will hide issues you might have with your code. In other words. Tests might pass on Perl 5.26 on Travis-CI and on your local test environment, but not on a Perl 5.26 out in the wild.

As it turns out Test::Harness will [only set PERL_USE_UNSAFE_INC if it is not defined yet](https://github.com/Perl-Toolchain-Gang/Test-Harness/blob/62688b0c26fedf4760e809ef90186c47d2307b96/lib/Test/Harness.pm#L150). This means that if you set `PERL_USE_UNSAFE_INC=0` in your `.travis.yml` file that will remove "." from @INC in Perl 5.26. At least as long as Test::Harness will take that in account.

You can and probably also should set `PERL_USE_UNSAFE_INC=0` on your development and testing machines to make them more similar to real world environments.

```
env:
  - PERL_USE_UNSAFE_INC=0
```

I think I also need to apologize to Travis as in the original version of this blog post I blamed this issue on them incorrectly.

I have no idea why does Test::Harness set this environment and unfortunately the [Changes](https://github.com/Perl-Toolchain-Gang/Test-Harness/blob/62688b0c26fedf4760e809ef90186c47d2307b96/Changes) only include the fact of the change, but not the reason why is this envrionemnt variable set?


In any case, there are plenty of way to [change @INC to find Perl modules in non-standard locations](/how-to-change-inc-to-find-perl-modules-in-non-standard-locations) or in a [relative directory](/beginner-perl-maven-changing-inc-relative-path) without compromising the security of your system.

