---
title: "Segmentation Fault (core dumped) while connecting to Oracle using DBD::Oracle"
timestamp: 2006-12-16T05:33:33
tags:
  - DBD::Oracle
  - DBI
published: true
archive: true
---



Posted on 2006-12-16 05:33:33-08 by austin

Hi Need Help I am getting Segmentation fault when running the perl script.

```
aussvcd01% ./fw1_audit.pl
Function Called Connecting to Oracle Segmentation Fault (core dumped
```

Here are some useful lines from DBD installation

```
Looks good
LD_RUN_PATH=/oracle/app/oracle/product/10.2.0/lib32:
/oracle/app/oracle/product/10.2.0/rdbms/lib32
Using DBD::Oracle 1.19.
Using DBD::Oracle 1.19.
Multiple copies of Driver.xst found in:
/usr/local/lib/perl5/site_perl/5.8.8/i86pc-solaris/auto/DBI/
/usr/local/lib/perl5/site_perl/5.8.7/i86pc-solaris/auto/DBI/ at Makefile.PL line 1635
Using DBI 1.53 (for perl 5.008008 on i86pc-solaris) installed in
/usr/local/lib/perl5/site_perl/5.8.8/i86pc-solaris/auto/DBI/
Writing Makefile for DBD::Oracle
```

Posted on 2006-12-18 11:48:11-08 by byterock in response to 3821

Having a quick look at is it seem the error is being throw on DBI rather than DBD.
I have no suggestion right now but you would be much better off posting your question
to dbi-users@perl.org (you don't need to subscribe in order to post)
and you won't be automatically subscribed either as very few people
use this form for dbi or driver support. dbi-users is where you'll get the best support

Posted on 2007-01-31 16:49:33-08 by jplynch in response to 3832

I'm not sure if I am having the same problem or not, so I will post here first.
I recently patched my oracle version to 9.2.0.8 and suddenly all my perl programs
that connect to Oracle die with a segmentation fault.
I figured I just needed to recompile DBD::Oracle.
To be on the safe side I recompiled DBI as well.
If I run the programs as root they run fine, but if I switch to one of the other
users on the system I get a segmentation fault.
My first suspect is I am seeing a permission issue. Anyone have any thoughts?

Thanks. -Paul

Posted on 2009-02-10 23:59:41-08 by whocares in response to 3820

...After having spent several useless hours trying to find an answer to this
question on both Google and Metalink, and then trying to decipher stack
trace output from core dump, it turns out that there was no setting
in my .profile (in some cases, .bash_profile) file for LD_LIBRARY_PATH.

If Oracle was working just fine, but suddenly you come in to work and find it to have crashed...
And then- when you go to start the listener, rman, or sqlplus, and you get the mysterious error:

```
Segmentation Fault (core dumped)

BE SURE YOU HAVE A VALID SETTING FOR THE LD_LIBRARY_PATH
```

To determine this, simply type: `echo $LD_LIBRARY_PATH` at the UNIX command prompt. ...
It should return the i`$ORACLE_HOME/lib` directory.

BTW- We're using Oracle 10.2.0.3 on Solaris 10.

Hope this saves you more time than I wasted! ;-)

Posted on 2012-04-05 01:47:48.838754-07 by rampu in response to 9919

For an issue to be resolved we had to change the system date to
back dated ( 1994) in aix O/s verion 6.1. After doing this when we tried to connect
to the oracle 11g database with sqlplus we were getting segmentation fault
(core dumped) error and not allowing us to start the database.
When we changed to current date we were able to connect and bring up the database.
We need to have this is to be back dated for an issue ?
please suggest how to proceed further on this?

(This article is based on a thread on the CPAN::Forum.)
<!-- from http://cpanforum.com/threads/3820 -->

