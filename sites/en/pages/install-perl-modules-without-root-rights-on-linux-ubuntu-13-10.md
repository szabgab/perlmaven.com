---
title: "Install Perl modules without root rights on Linux Ubuntu 13.10 x64"
timestamp: 2014-03-19T15:19:01
tags:
  - cpanm
  - App::cpanminus
  - local::lib
published: true
author: szabgab
---


If you have root rights there might be [other, easier ways to install Perl modules](/how-to-install-a-perl-module-from-cpan)
than the following.

After an initial configuration, many Perl modules from CPAN can be easily installed, but there are quite a few that required
some additional tools. In this article I'll assume that either you already have those installed, or that at least those
you can install as root.

If you don't have those prerequisites then you will need to build the modules on another, similar machine
where you do have root rights and then transfer the whole directory tree. That's another story that
will be covered in a separate article.


## Background

In order to try this I created a droplet at [Digital Ocean](/digitalocean)
running Ubuntu 13.10 x64. Once the droplet was created I ssh-ed to the machine as user
root, updated all the installed packages and rebooted:

```
# aptitude update
# aptitude safe-upgrade
# reboot
```

Then I ssh-ed again, created a user for myself, and switched to that user.

```
# adduser gabor
...
# su - gabor
```

Finally I checked the version of Perl, just so it will be recorded here:

```
$ perl -v
```

```
v5.14.2
```


## Disclaimer

By default `cpanm` will try to install the latest version of each module.
By the time you read this, modules had newer releases, some of which might
not install as smoothly as you can see in this article.

## Prerequisites

Even for the most basic installation you'll need the `make` command. Otherwise you'll encounter an error messages looking like this one:

```
! Can't configure the distribution. You probably need to have 'make'. See /home/gabor/.cpanm/work/1395231034.1109/build.log for details.
```

In order to install you need to be user root and give the following command:

```
# aptitude install make
```

Once you have `make` installed you can install [cpanminus](http://cpanmin.us), which is
a client program to install modules from CPAN.

## Install cpanminus

```
$ curl -L http://cpanmin.us | perl - App::cpanminus
```

The output will look like this:

```
  % Total    % Received % Xferd  Average Speed   Time    Time     Time  Current
                                 Dload  Upload   Total   Spent    Left  Speed
100   303    0   303    0     0    779      0 --:--:-- --:--:-- --:--:--   780
100  262k  100  262k    0     0   447k      0 --:--:-- --:--:-- --:--:--  447k
!
! Can't write to /usr/local/share/perl/5.14.2 and /usr/local/bin: Installing modules to /home/gabor/perl5
! To turn off this warning, you have to do one of the following:
!   - run me as a root or with --sudo option (to install to /usr/local/share/perl/5.14.2 and /usr/local/bin)
!   - Configure local::lib your existing local::lib in this shell to set PERL_MM_OPT etc.
!   - Install local::lib by running the following commands
!
!         cpanm --local-lib=~/perl5 local::lib && eval $(perl -I ~/perl5/lib/perl5/ -Mlocal::lib)
!
--> Working on App::cpanminus
Fetching http://www.cpan.org/authors/id/M/MI/MIYAGAWA/App-cpanminus-1.7001.tar.gz ... OK
Configuring App-cpanminus-1.7001 ... OK
Building and testing App-cpanminus-1.7001 ... OK
Successfully installed App-cpanminus-1.7001
1 distribution installed
```

It has installed `cpan minus` but it is not yet operational. We will also install
[local::lib](https://metacpan.org/pod/local::lib) that can help perl find
the modules installed in your private directory.


## Install local::lib

The actual command I had to give was slightly different from the one printed by the previous
command. I had to run:

```
$ ~/perl5/bin/cpanm --local-lib=~/perl5 local::lib && eval $(perl -I ~/perl5/lib/perl5/ -Mlocal::lib)
```

The output was:

```
--> Working on local::lib
Fetching http://www.cpan.org/authors/id/H/HA/HAARG/local-lib-2.000008.tar.gz ... OK
Configuring local-lib-2.000008 ... OK
==> Found dependencies: ExtUtils::MakeMaker
--> Working on ExtUtils::MakeMaker
Fetching http://www.cpan.org/authors/id/B/BI/BINGOS/ExtUtils-MakeMaker-6.92.tar.gz ... OK
Configuring ExtUtils-MakeMaker-6.92 ... OK
Building and testing ExtUtils-MakeMaker-6.92 ... OK
Successfully installed ExtUtils-MakeMaker-6.92 (upgraded from 6.57_05)
Building and testing local-lib-2.000008 ... OK
Successfully installed local-lib-2.000008
2 distributions installed
```

It worked without any problem.

Let's see if we can find the cpan minus client now:

```
$ which cpanm
/home/gabor/perl5/bin/cpanm
```

That's great, but this will work only in the current shell. Once we log out and log in again, the mapping will go away.
In order to make this permanent edit ~/.bash_profile (I had to create it as I did not have it)
and add the following line:

```
eval $(perl -I ~/perl5/lib/perl5/ -Mlocal::lib)
```

this will ensure that we will find the locally installed cpanm command and perl will
find the locally installed modules, even after we log out and log in again.
(Actually, at this point you might want to try that. Log out. Log in. run `which cpanm`.)


We are basically done now. Let's try to install a couple of modules:

## Install Test::More

```
$ cpanm  Test::More
```

Output:

```
--> Working on Test::More
Fetching http://www.cpan.org/authors/id/R/RJ/RJBS/Test-Simple-1.001002.tar.gz ... OK
Configuring Test-Simple-1.001002 ... OK
Building and testing Test-Simple-1.001002 ... OK
Successfully installed Test-Simple-1.001002 (upgraded from 0.98)
1 distribution installed
```

worked smoothly.


## Install HTML::Template

```
$ cpanm HTML::Template
```

Output:

```
--> Working on HTML::Template
Fetching http://www.cpan.org/authors/id/W/WO/WONKO/HTML-Template-2.95.tar.gz ... OK
Configuring HTML-Template-2.95 ... OK
Building and testing HTML-Template-2.95 ... OK
Successfully installed HTML-Template-2.95
1 distribution installed
```

worked well.

## Expect needs gcc

```
$ cpanm Expect
```

Output:

```
--> Working on Expect
Fetching http://www.cpan.org/authors/id/R/RG/RGIERSIG/Expect-1.21.tar.gz ... OK
Configuring Expect-1.21 ... OK
==> Found dependencies: IO::Pty, IO::Tty
--> Working on IO::Pty
Fetching http://www.cpan.org/authors/id/T/TO/TODDR/IO-Tty-1.10.tar.gz ... OK
Configuring IO-Tty-1.10 ... N/A
! Configure failed for IO-Tty-1.10. See /home/gabor/.cpanm/work/1395231778.4926/build.log for details.
! Installing the dependencies failed: Module 'IO::Pty' is not installed, Module 'IO::Tty' is not installed
! Bailing out the installation for Expect-1.21.
```

This did not work. Looking at the build.log file listed in the error there was a line that told me:

```
ERROR: cannot run the configured compiler 'cc'
```

There was some more explanation, but it boils down to the fact that we don't have `gcc`
installed. We need root rights to install it:

```
# aptitude install gcc
```

After that `cpanm Expect` already worked.

## XML::Parser needs expat

```
$ cpanm XML::Parser
```

The error included a line:

```
! Installing XML::Parser failed. See /home/gabor/.cpanm/work/1395232030.10653/build.log for details. Retry with --force to force install it.
```

The log file revealed we need the development files of expat:

```
# aptitude install libexpat-dev
```

After that `cpanm XML::Parser` could already install the module.

## XML::LibXML needs xml2 and zlib

```
cpanm XML::LibXML
```

Output included

```
! Configure failed for XML-LibXML-2.0113. See /home/gabor/.cpanm/work/1395232400.12839/build.log for details.
```

We had to install:

```
# aptitude install libxml2-dev zlib1g-dev
```

After that the installation `cpanm XML::LibXML` worked.


## LWP::Protocol::https needs libssl

Try

```
$ cpanm LWP::Protocol::https
```

Output included a line telling us:

```
Installing Net::SSLeay failed. 
```

It needs libssl:

```
# aptitude install libssl-dev
```

After that `cpanm LWP::Protocol:https` already worked.


## Net::SSH::Perl needs Math::GMP that needs 

```
cpanm Net::SSH::Perl
```

```
! Installing Math::GMP failed. See /home/gabor/.cpanm/work/1395233001.20342/build.log for details. Retry with --force to force install it.
....

Installing the dependencies failed: Module 'Math::GMP' is not installed
```

The build.log was a bit too big for me to understand so I ran

```
$ cpanm Math::GMP
```

that failed again, but provided a much shorter build.log. From that I already understood I need to install

```
# aptitude install libgmp-dev
```

then `cpanm Net::SSH::Perl` also worked.


## DBD::mysql

```
cpanm DBD::mysql
```

Output:

```
! Configure failed for DBD-mysql-4.026. See /home/gabor/.cpanm/work/1395236954.25241/build.log for details.
```

the error in the build.log includes lines like these:

```
Can't exec "mysql_config": No such file or directory at Makefile.PL line 70.

Cannot find the file 'mysql_config'! Your execution PATH doesn't seem
not contain the path to mysql_config. Resorting to guessed values!
```


So we need to install the development files of the mysql client:

```
# aptitude install libmysqlclient-dev
```

Running `cpanm DBD::mysql` will yield now a different output:

```
! Installing DBD::mysql failed. See /home/gabor/.cpanm/work/1395237315.26506/build.log for details. Retry with --force to force install it.
```

(Previously it failed in the Configuration step. This time in the Installation step.)
Looking in the build.log file I see error like this:

```
...
t/pod.t .............................. skipped: Test::Pod 1.00 required for testing POD
DBI connect('test','gabor',...) failed: Can't connect to local MySQL server through socket '/var/run/mysqld/mysqld.sock' (2) at t/rt25389-bin-case.t line 13
Can't connect to local MySQL server through socket '/var/run/mysqld/mysqld.sock' (2) at t/rt25389-bin-case.t line 13.
# Looks like your test exited with 255 before it could output anything.
t/rt25389-bin-case.t ................. 
Dubious, test returned 255 (wstat 65280, 0xff00)
Failed 8/8 subtests 
DBI connect('test','gabor',...) failed: Can't connect to local MySQL server through socket '/var/run/mysqld/mysqld.sock' (2) at t/rt50304-column_info_parentheses.t line 12
Can't connect to local MySQL server through socket '/var/run/mysqld/mysqld.sock' (2) at t/rt50304-column_info_parentheses.t line 12.
# Looks like your test exited with 255 before it could output anything.
t/rt50304-column_info_parentheses.t .. 
Dubious, test returned 255 (wstat 65280, 0xff00)
Failed 7/7 subtests 
t/rt83494-quotes-comments.t .......... skipped: ERROR: DBI connect('test','gabor',...) failed: Can't connect to local MySQL server through socket '/var/run/mysqld/mysqld.sock' (2) at t/rt83494-quotes-comments.t line 17
t/rt85919-fetch-lost-connection.t .... skipped: ERROR: DBI connect('test','gabor',...) failed: Can't connect to local MySQL server through socket '/var/run/mysqld/mysqld.sock' (2) at t/rt85919-fetch-lost-connection.t line 10
t/rt86153-reconnect-fail-memory.t .... skipped: Skip $ENV{EXTENDED_TESTING} is not set
t/rt91715.t .......................... skipped: ERROR: Can't connect to local MySQL server through socket '/var/run/mysqld/mysqld.sock' (2) 2002 Can't continue test

Test Summary Report
-------------------
t/rt25389-bin-case.t               (Wstat: 65280 Tests: 0 Failed: 0)
  Non-zero exit status: 255
  Parse errors: Bad plan.  You planned 8 tests but ran 0.
t/rt50304-column_info_parentheses.t (Wstat: 65280 Tests: 0 Failed: 0)
  Non-zero exit status: 255
  Parse errors: Bad plan.  You planned 7 tests but ran 0.
Files=58, Tests=6,  4 wallclock secs ( 0.16 usr  0.06 sys +  2.57 cusr  0.46 csys =  3.25 CPU)
Result: FAIL
Failed 2/58 test programs. 0/6 subtests failed.
make: *** [test_dynamic] Error 255
```

The problem is that [DBD::mysql](https://metacpan.org/pod/DBD::mysql) wants to access a MySQL server in order to run some tests.
Once it notices there is no available MySQL server, it actually skips most of the tests, but apparently this version (4.026) had
two test files that still failed.

At this point we can do one or more of the following things: 

1. Decide DBD::mysql isn't that important for our life and skip the installation.
1. Send a bug report to bug-dbd-mysql@rt.cpan.org with the output.
1. Look at the build.log file, configure the MySQL server access and try to install again using `cpanm DBD::mysql`
1. Install the module using the force  `cpanm --force DBD::mysql` (this will run the tests but disregard the failure)
1. Install the module skipping the tests `cpanm --notest DBD::mysql`

Personally, I ran `cpanm --notest DBD::mysql`.


## DBD::Pg - the PostgreSQL driver

```
$ cpanm DBD::Pg
```

Output:

```
! Configure failed for DBD-Pg-3.0.0. See /home/gabor/.cpanm/work/1395240499.31200/build.log for details.
```

The build.log mentions, but that does not give a lot of clue.

```
No POSTGRES_HOME defined, cannot find automatically
```

We have to install:

```
# aptitude install libpq-dev
```

then `cpanm DBD::Pg` already works.

## Moo

Installs without any problem using `cpanm Moo`.

## Moose

Installs smoothly using `cpanm Moose`.

## Dancer

Installs without a problem using `cpanm Dancer`.

## Mojolicious

Installed using `cpanm Mojolicious`.

## Catalyst

`cpanm Catalyst` install all 72 dependencies that were still missing at this point.

## MongoDB

`cpan MongoDB` installed without the need of any external library.

## Starman

`cpanm Starman` failed because of known, and already reported issue in the tests of Net::Server.

So `cpanm --notest Net::Server` and then `cpanm Starman` already works.

## PAR::Packer

Need to install the "Perl development" package, called libperl-dev on Debian/Ubuntu.

`cpanm PAR::Packer`

## DBD::ODBC

```
$ cpanm DBD::ODBC
```

At first it failed.

The build.log told me to install unixodbc-dev.

```
# aptitude install unixodbc-dev 
$ cpanm DBD::ODBC
```


## Other

```
$ cpanm POE
$ cpanm AnyEvent
$ cpanm IO::Async
$ cpanm CHI
$ cpanm Redis
$ cpanm Devel::Cover
$ cpanm Memcached::Client
$ cpanm DBIx::Class
$ cpanm Marpa::R2
$ cpanm GeoIP2
$ cpanm Pinto
$ cpanm Cache

# aptitude install firebird-dev
$ cpanm DBD::Firebird
```


