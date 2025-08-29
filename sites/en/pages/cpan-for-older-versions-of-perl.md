---
title: "CPAN for older versions of Perl"
timestamp: 2015-02-19T09:50:02
tags:
  - cpxxxan
  - CPAN
published: true
author: szabgab
---


When you install a module using any of the CPAN clients (eg. [cpan](https://metacpan.org/pod/cpan), [cpanp](https://metacpan.org/pod/cpanp), or
[cpanm](https://metacpan.org/pod/cpanm)) you will get the most recent release of the requested module.

What if that does not work on your platform on your version of Perl?


You can use the data collected by the [CPAN Testers](http://cpantesters.org/). For example if you visit the
page listing the [test reports of Term::ReadPassword::Win32](http://www.cpantesters.org/distro/T/Term-ReadPassword-Win32.html),
you will see a big table called **PASS Summary**. This table shows the most recent version
of [Term::ReadPassword::Win32](https://metacpan.org/pod/Term::ReadPassword::Win32), that has received
a **PASS** report on a given version of perl and a given platform.
In that table each row represents a specific version of perl and each column represents an platform.

Perl versions might include entries like 5.8.3 and 5.14.3 RC1.
Platforms will include entries like **Windows (Cygwin)**, **Windows (Win32)**, FreeBSD, GNU/Linux, SunOS/Solaris and others.

A section of the table looks like this:

<img src="/img/cpantesters_term_readpassword_win32.png" alt="CPAN Testers PASS matrix">

Unfortunately we cannot see the columns in this screenshot, but they were as follows:
<ol>
 <li>perl version</li>
 <li>Windows (Cygwin)</li>
 <li>Mac OS X</li>
 <li>Dragonfly BSD</li>
 <li>FreeBSD</li>
 <li>Debian GNU/kFreeBSD</li>
 <li>GNU/Linux</li>
 <li>MidnightBSD</li>
 <li>Windows (Win32)</li>
 <li>NetBSD</li>
 <li>OpenBSD</li>
 <li>SunOS/Solaris</li>
</ol>

Some of the fields are empty. This does not mean the module won't work on that perl/platform pair, it just means no
**PASS** reports were received for that perl/platform pair.

Some of the fields contain 0.05. For example the 5th column (displaying the reports from FreeBSD) in the row of 5.8.9
contains the number 0.05. This means someone has tested the distribution on a FreeBSD system using perl 5.8.9.
The tests passed and the person sent in a report to the CPAN testers.
As of this writing the latest version of Term::ReadPassword::Win32 was 0.05, so this means the latest version of this
module passed its test on at least one computer using perl 5.8.9 running on FreeBSD.

Other fields contain smaller numbers. For example the 5th column row of 5.8.7 contains 0.02. This mean version 0.02
of this module was tested on FreeBSD using perl 5.8.7 and the success report was sent in. This does not mean 0.05 will not
work on FreeBSD using perl 5.8.7, it just means there were no success reports.

Given this information you can visit [MetaCPAN](https://metacpan.org/),
locate the specific version of the module on [CPAN](http://www.cpan.org/),
or if it was already deleted from CPAN, then on [BackPan](http://backpan.perl.org/).
Download it and you can try to install it.

This process is reasonable for one module, but if you need to install more modules, or if this module
has dependencies then this process will quickly become a nightmare.

## cpXXXan to the rescue

The [cpXXXan](http://cpxxxan.barnyard.co.uk/) project maintained by [David Cantrell](http://www.cantrell.org.uk/david/) provides one of the solutions to this problem.
David maintains snapshots of CPAN with modules that will work on specific versions of Perl, or on a specific platforms and snapshots of CPAN at various dates in the past.
(First day of every month since January 1, 2000.)

Not only that, but it also uses the test results of the CPAN testers, and for a particular snapshot it will only include distributions
that has a pass report for the give platform or given version of perl.

This means you can configure your cpan client to use one of these CPAN mirror sites and then you can use the recursive installation capabilities
of the cpan client to install the necessary modules. They will only pull in versions that had a pass-report so the chances that everything will
install automatically are quite high.

Of course you might not get the latest version of each module, but this seems like a reasonable trade-off.

Oh and in case you need another specialized snapshot, David will probably be able to create if for you.


## Better control using Pinto or Carton

Using one of the cpXXXan sites might provide a quick solution when you need to install modules on an older version of perl, but this still does not guarantee
that your application will work with the modules installed this way. After all these modules might be too new for your application,
and in some cases, maybe due to lack of test reports, you might even get an older version of a module when a newer would also work.

The real long-term solution for you would be to use proper version control for your CPAN dependencies as well. There are many ways to do that,
the two recently developed ones are [Pinto](https://metacpan.org/pod/Pinto) and [Carton](https://metacpan.org/pod/Carton).


## Improving cpXXXan for your specific case

The list of distributions in every cpXXXan mirror is limited by the test reports in CPAN Testers. If the particular perl/platform you use does not have
a lot of test reports then the appropriate cpXXXan mirror will also suffer from this. The best you could do is to
[set up a CPAN smoker](http://wiki.cpantesters.org/wiki/GettingStarted) and start providing test reports on your perl/platform pair.

## Improving the results of CPAN Testers

The [CPAN Testers](http://cpantesters.org/) can only provide data sent in by volunteers who run whatever hardware
and operating system is available for them. This means it is mostly Linux and commodity-PC-hardware. Even Microsoft Windows
and Mac OSX tends to be underrepresented. Other Operating System and other hardware has a lot less report.

Therefore if you are interested in data from those system, you should consider setting up a
[CPAN Smoker](http://wiki.cpantesters.org/) and providing the input.


