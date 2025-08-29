---
title: "Skip tests if prerequisites are not installed"
timestamp: 2015-01-19T17:00:01
tags:
  - Test::Pod
  - Test::Pod::Coverage
  - Test::Version
  - Test::Perl::Critic
  - Travis-CI
  - Test::DistManifest
  - Test::CheckManifest
  - Test::Code::TidyAll
published: true
books:
  - beginner
author: szabgab
---


When writing test for a CPAN module we use various modules that are not required for the actual use of the module.
Some of these modules include the standard and almost always used [Test::More](https://metacpan.org/pod/Test::More),
testing modules such as [Test::Deep](https://metacpan.org/pod/Test::Deep) that are not standard but frequently used.

Then there can be modules such as [DBD::mysql](https://metacpan.org/pod/DBD::myql) to test an application using MySQL
if it is available and some specialized testing modules, for tests that probably only the developer should run.

The first two will be mentioned in the Makefile.PL under the BUILD_REQUIRES or TEST_REQUIRES section and will be pulled in
for the time of testing.

The other two might be only mentioned in the test scripts. How can we skip a whole test file if a required module is not available?


## Author tests and/or optional test

There are several modules that don't test the usability of the module, but the overall healthiness of the modules and the distribution
as a whole. For example making sure that each function has documentation, or that each module has a version number.
It is usually not very important to run these tests on the machine where the module will be used, but nevertheless they are important
for the author or for people who want to contribute to the module.

Let's see a few of them, and how to use them:

## Test::Pod

[Test::Pod](https://metacpan.org/pod/Test::Pod) checks the validity of a POD files, or [POD](/pod-plain-old-documentation-of-perl) embedded in perl scripts and modules.

```perl
use strict;
use warnings;
use Test::More;

eval "use Test::Pod 1.48";
plan skip_all => "Test::Pod 1.48 required for testing POD" if $@;
all_pod_files_ok();
```

## Test::Pod::Coverage

[Test::Pod::Coverage](https://metacpan.org/pod/Test::Pod::Coverage) checks if every function in every module has some [documentation in POD](/pod-plain-old-documentation-of-perl).

```perl
use strict;
use warnings;
use Test::More;

eval "use Test::Pod::Coverage 1.10";
plan skip_all => "Test::Pod::Coverage 1.10 required for testing POD coverage" if $@;
all_pod_coverage_ok();
```


## Test::DistManifest and Test::CheckManifest

[Test::DistManifest](https://metacpan.org/pod/Test::DistManifest)
and 
[Test::CheckManifest](https://metacpan.org/pod/Test::CheckManifest)
are two alternative ways to check if the MANIFEST file in the distribution matches the files that are on the disk
after extraction or before creating the distribution.

[Test::DistManifest](https://metacpan.org/pod/Test::DistManifest) can be used this way:

```perl
use strict;
use warnings;
use Test::More;

eval 'use Test::DistManifest 1.012';
plan skip_all => 'Test::DistManifest 1.012 required to test MANIFEST' if $@;
manifest_ok();
```

[Test::CheckManifest](https://metacpan.org/pod/Test::CheckManifest) can be used this way:

```perl
use strict;
use warnings;
use Test::More;

eval 'use Test::CheckManifest 1.28';
plan skip_all => 'Test::CheckManifest 1.28 required to test MANIFEST' if $@;
ok_manifest();
```


## Test::Version

[Test::Version](https://metacpan.org/pod/Test::Version) checks to see that the version numbers in the modules are sane.
To some value of "sane". It checks if every .pm file has a version number and if every such version number is in the form
of `1.23` or `v1.2.3` though there is also a <i>lax</i> version of this criteria allowing version numbers such as `1.23_45`.

It will also check if the version number in each one of the modules in a distribution is the same. 

Using it is a bit more involved than using the previous modules as one needs to provide a few parameters
to the `use` statement and then [done_testing](/done-testing) needs to be called.

```perl
use strict;
use warnings;
use Test::More;

eval q{use Test::Version 1.004000 qw( version_all_ok ), {
        is_strict   => 1,
        has_version => 1,
        consistent  => 1,
    };
};
plan skip_all => "Test::Version 1.004000 required for testing version numbers" if $@;
version_all_ok();
done_testing;
```




## Test::Code::TidyAll

[Test::Code::TidyAll](https://metacpan.org/pod/Test::Code::TidyAll) checks if the code has been
reformatted according to the rules of [Perl::Tidy](https://metacpan.org/pod/Perl::Tidy) as defined
in the  `.perltidyrc` and `.tidyallrc` files.

```perl
use strict;
use warnings;

use Test::More;

eval 'use Test::Code::TidyAll 0.20';
plan skip_all => "Test::Code::TidyAll 0.20 required to check if the code is clean." if $@;
tidyall_ok();
```

## Test::Perl::Critic

[Test::Perl::Critic](https://metacpan.org/pod/Test::Perl::Critic) will check all the perl files
in the distribution according to the [Perl::Critic](https://metacpan.org/pod/Perl::Critic) ruleset
defined in the `.perlcriticrc` file in the distribution.

```perl
use strict;
use warnings;
use Test::More;

eval 'use Test::Perl::Critic 1.02';
plan skip_all => 'Test::Perl::Critic 1.02 required' if $@;
all_critic_ok();
```


## Travis-CI and optional tests

I am sure there are plenty of other modules that will check some of the files of a distribution, that you
won't necessarily want to run during every installation of the module.

On the other hand, if you are using GitHub and Travis-CI as [described](http://blogs.perl.org/users/neilb/2014/08/try-travis-ci-with-your-cpan-distributions.html)
by Neil Bowers, you might want to ensure that these modules are installed on the Travis-CI server.

You can accomplish that using the following Travis-CI configuration file:

For example, in order to ensure we have Test::Version installed, before actually trying to run the tests of our module, we
can add a **before_install** entry to the `.travis.yml` file of our project:

```
branches:
  except:
    - gh-pages
language: perl
perl:
  - "5.20"
  - "5.18"
  - "5.16"
  - "5.14"
  - "5.12"
  - "5.10"
before_install:
  - cpanm --notest Test::Version
```


Alternatively we could install the version supplied by the OS vendor using

```
before_install:
  - sudo apt-get install -qq libtest-version-perl
```

but currently Travis-CI is using Ubuntu 12.04 LTS which does not distribute Test::Version, and even for modules where
the OS vendor distributes the module, they are usually older versions of the module. So you might be better off
sticking to the installation using `cpanm`.


## AUTHOR_TESTING and RELEASE_TESTING

A Caleb Cushing (author of Test::Version mentioned above) also suggested in his comment, this might not be the best solution for skipping the tests.
He also referred us to the [Lancaster Consensus](http://www.dagolden.com/index.php/2098/the-annotated-lancaster-consensus/) that
was discussed at the <a href="http://act.qa-hackathon.org/qa2013/">QA Hackathon in 2013.

One problem is that if I, as the author of the module under test, forget to install the specific test-related module, then the test will be skipped,
almost silently and I won't notice if I broke some of the requirements I've set to myself.

[Dist::Zilla](http://dzil.org/) provides some nice facilities to allow the author to configure in the dist.ini file certain standard test,
and then Dist::Zilla will generate appropriate test files in the `xt/` directory of the release and run these test during the release process.

Dist::Zilla will also set both the AUTHOR_TESTING and RELEASE_TESTING environment variables to [true](/boolean-values-in-perl) which can
be used in other test script to run certain test only during the release process.

