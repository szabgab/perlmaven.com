---
title: "Installing a Perl Module from CPAN on Windows, Linux and Mac OSX"
timestamp: 2014-03-13T10:42:33
tags:
  - CPAN
  - cpanm
  - ActivePerl
  - Strawberry Perl
  - DWIM Perl
published: true
author: szabgab
---


When searching a Perl module, sooner or later you will end up on one of two sites sites providing information about CPAN modules.
Both [Meta CPAN](https://metacpan.org/), and <a href="http://search.cpan.org/" rel="nofollow">search.cpan.org</a>
will show you a link to <b>download</b> the module, but in most cases that's <b>not</b> what you need.

So how do you really install Perl modules from CPAN?

(As always, some people will disagree with the recommendations below, they probably have not read
the [article of Dave Cross](http://perlhacks.com/2014/03/installing-modules/), or reached
other conclusions.)


In most cases the installation of a CPAN module works just as installing an app from the Apple Appstore or the Google Play.
Except, that these modules are all open source and free software.

Depending on the Operating System and which Perl distribution you have, the specific instructions differ.
In order to make the examples clearer, let's try to install the module called <b>Try::Tiny</b>.

It has its description both on [Meta CPAN](https://metacpan.org/release/Path-Tiny) and on
<a href="http://search.cpan.org/dist/Path-Tiny/" rel="nofollow">search.cpan.org</a>. Both have the <b>Download</b> links
that we won't click on.

## Cases

* [Windows: Strawberry Perl or DWIM Perl](#dwimperl)
* [Windows: ActivePerl](#activeperl)
* [Windows: GitPerl](#gitperl)
* [Windows: Cygwin Perl](#cygwinperl)
* [Debian/Ubuntu Linux, system Perl with root rights](#debian)
* [Fedora/RedHat/Centos Linux, system Perl with root rights](#fedora)
* [Mac OSX](#osx)
* [Using the cpan client](#cpan-client)
* [Using cpanm](#cpanm)
* [FreeBSD, system Perl with root rights](/install-perl-modules-on-freebsd)


<h2 id="dwimperl">Strawberry Perl or DWIM Perl on Windows</h2>

[Strawberry Perl](http://strawberryperl.com/),
comes with an already configured cpan client. We will use this client to install modules directly from CPAN:

Open the Command Window (Start -> Run -> type in cmd) When you get the "DOS" prompt
type in `cpan Path::Tiny`.
Please note, module names are case sensitive,
so typing `cpan path::tiny` or `cpan PATH::TINY` will <b>not</b> work!

Also, in normal circumstances, the cpan client is expecting the full name of the module, not one part of the name,
and not the name of the zip-file.
So `cpan Path` or `cpan Tiny` will attempt to install different modules.
(One called Path, the other one called Tiny.)

What you need to do is type in:

```
c:> cpan Path::Tiny
```


<h2 id="activeperl">ActivePerl</h2>

There is a graphical tool for this as well, but it might be more simple just to open the
Command Window (Start -> Run -> type cmd). When you get the "DOS" prompt, type in
`ppm install Path::Tiny`. Please note, this too is case sensitive!

```
c:> ppm install Path::Tiny
```

The problem you might encounter is that this command uses the "CPAN store" of ActiveState that for various
technical and legal reasons does not carry all the the modules from CPAN. It can also be out-of date
carrying older versions of the modules. On newer versions of ActivePerl you can also enable a real
cpan-client that will access the CPAN server just as it does in the case of Strawberry/DWIM Perl above.


<h2 id="gitperl">GitPerl</h2>

TBD.

<h2 id="cygwinperl">Cygwin Perl</h2>

TBD. [Cygwin](http://www.cygwin.com/).



<h2 id="debian">Debian/Ubuntu Linux</h2>

If you have <b>root</b> rights, and if you use the <b>system perl</b> located in `/usr/bin/perl`,
then probably the best is to try to install from the package management system of your Linux distribution.
If you don't have root rights, you could ask your system administrator to do it on your behalf.

Apparently there is a nice way to [find out if a Perl module is on Debian or Ubuntu](http://deb.perl.it/).

If the module you are looking for is not available in the repositories of your Debian/Ubuntu/etc. distribution
(and there are only about 10% of the modules available), or if you don't use the system Perl,
then you can follow the instructions with <b>cpan/cpanm</b> below.

To install for the system-perl as root you can use either `aptitude` or `apt-get`
depending on your personal preferences.

If the name of the module in Perl-land is `Path::Tiny`, then the name of the package in Debian/Ubuntu-land
is most likely going to be `libpath-tiny-perl`.

```
$ sudo apt-get install libpath-tiny-perl
```

```
$ sudo aptitude install libpath-tiny-perl
```



<h2 id="fedora">RedHat/Fedora/CentOS Linux</h2>

Just as in the case of Debian/Ubuntu above, the instructions here are relevant if
you use the <b>system perl</b> located in `/usr/bin/perl` and if you have
<b>root</b> rights:

Using the package management system:

```
$ sudo yum install perl-Path-Tiny
```

As Dave Cross mentioned, if you don't know the name of the RH package, you can also use

```
yum install 'perl(Path::Tiny)'".
```

The subtle difference is that the former installs the named RPM whereas the second
installs the RPM that provides the named Perl module.

So if you would like to install the Path::Tiny module then the second command is
actually the better one.

If your vendor does not carry this Perl package, you can add other RPM repositories.
Check out [EPEL](https://fedoraproject.org/wiki/EPEL), and
the [Magnum Solutions CPAN RPM Repository](http://rpm.mag-sol.com/)
maintained by [Dave Cross](http://perlschool.co.uk/).


<h2 id="osx">Mac OSX</h2>

Follow the instructions with <b>cpan/cpanm</b> below.

<h2 id="cpan-client">Using the cpan client</h2>

While the `cpan` program comes with most operating system,
and it works well after some configuration, there is probably a better,
and certainly lighter solution called <b>cpan minus</b> or <b>cpanm</b>.


<h2 id="cpanm">Using cpanm</h2>

This is for Linux and OSX systems.  (For Windows, see described above.)

First, if you don't have it installed yet,
then install [cpan minus](http://cpanmin.us) by typing

```
$ \curl -L http://cpanmin.us | perl - App::cpanminus
```

Once it is installed type:

```
$ cpanm Path::Tiny
```

If you still have questions related to the installation of Perl modules,
please ask them below! I'll try to update this article
to answer those questions and to explain other situations.

Specific instructions for 

* [Linux - Ubuntu 13.10 x64](/install-perl-modules-without-root-rights-on-linux-ubuntu-13-10)


## TODO

Separate explanation of installing using cpan/cpanm as root stepping on the system perl, 
using local::lib to install in a private directory while using system perl.

Using a manually compiled perl.

Using perlbrew, creating "virtual environments".

 
## Comments

Your knowledge has been invaluable to me, thankyou.

<hr>

Hi Gabor,

The command cpanm Path::Tiny for macOX throughs an error :
-bash: cpanm: command not found

Can you please help me with this?

---

You need to install cpanm.

<hr>

I am on Linux but without root permission. Running
\curl -L http://cpanmin.us | perl - App::cpanminu
gave the error
Can't write to ...
Also tried the cpan command with similar results. How do I download a perl module to a local directory under my control ?

---
Solved my problem. Found an excellent description here: https://stackoverflow.com/questions/2980297/how-can-i-use-cpan-as-a-non-root-user

<hr>

Hi Gabor,

I was trying to run following script but no success in it. Mentioned error below. how to install MongoDB package for Perl.? please help.

#!/usr/bin/perl
use strict;
use warnings;
#
use MongoDB;
use MongoDB::Connection;
use MongoDB::OID
use Data::Dumper qw(Dumper);
#
my $client = MongoDB::MongoClient->new(host => 'localhost', port => 27017);
my $db = $client->get_database( 'example_' . $$ . '_' . time );

my $people_coll = $db->get_collection('people');
#
$people_coll->insert( {
name => 'First',
});

$people_coll->insert( {
name => 'Second',
});
#
my $people = $people_coll->find;
while (my $p = $people->next) {
print Dumper $p;
}
#
$db->drop;

ERROR:
Can't locate MongoDB.pm in @INC (@INC contains: /usr/local/lib64/perl5 /usr/local/share/perl5 /usr/lib64/perl5/vendor_perl /usr/share/perl5/vendor_perl /usr/lib64/perl5 /usr/share/perl5 .) at dbs.pl line 5.
BEGIN failed--compilation aborted at dbs.pl line 5.

<hr>

Hi!
I tried to install:

\curl -L http://cpanmin.us | perl - App::cpanminus

But Perl is sending me this error:
Can't write to /Library/Perl/5.18 and /usr/local/bin: Installing modules to /Users/Lary/perl5
! To turn off this warning, you have to do one of the following:
! - run me as a root or with --sudo option (to install to /Library/Perl/5.18 and /usr/local/bin)
! - Configure local::lib in your existing shell to set PERL_MM_OPT etc.
! - Install local::lib by running the following commands
!
! cpanm --local-lib=~/perl5 local::lib && eval $(perl -I ~/perl5/lib/perl5/ -Mlocal::lib)
!
--> Working on App::cpanminus
Fetching http://www.cpan.org/authors... ... OK
Configuring App-cpanminus-1.7043 ... OK
Building and testing App-cpanminus-1.7043 ... FAIL
! Installing App::cpanminus failed. See /Users/Lary/.cpanm/work/1511604389.606/build.log for details. Retry with --force to force install it.

Can you help me? What should I do?
Thank you in advance!

<hr>

I tried to install MongoDB module in my Mac Os Mojave, and it it's impossible...and other modules... I saw I have to install firs, the same problem:
This is the message of CPAN
"Make had returned bad status, install seems impossible"
It's seems to be dependence problems.. can you help me ?
I need this !!

<hr>

Can't locate WWW/Curl.pm in @INC (you may need to install the WWW::Curl module) (@INC contains: /usr/local/Cellar/perl/5.34.0/lib/perl5/site_perl/5.34.0/darwin-thread-multi-2level /usr/local/Cellar/perl/5.34.0/lib/perl5/site_perl/5.34.0 /usr/local/Cellar/perl/5.34.0/lib/perl5/5.34.0/darwin-thread-multi-2level /usr/local/Cellar/perl/5.34.0/lib/perl5/5.34.0 /usr/local/lib/perl5/site_perl/5.34.0/darwin-thread-multi-2level /usr/local/lib/perl5/site_perl/5.34.0) at tempcurl.pl line 4.
Not sure .. what i need to do? Please help

---
follow the instructions in the blog post and install the module.

<hr>
Windows 11 Strawberry and Tk
I could not install cpan install Tk in normal cmd-Window (move did not work)
but in powershell-window it worked fine

