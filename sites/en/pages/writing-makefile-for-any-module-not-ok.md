---
title: "Writing Makefile for <any module> -- NOT OK"
timestamp: 2005-05-26T23:45:45
tags:
  - CPAN
published: true
archive: true
---



Posted on 2005-05-26 23:45:45-07 by thorby

I am trying to help an inexperienced user at long distance. She is attempting to install various modules using CPAN under Mac OS X (10.3).
She uses the command sudo perl -MCPAN -e 'install some::module'. There is no shortage of disk space.

No matter what module -- specifically requested, or unsatisfied prerequisite -- CPAN tries to install, it always fails the exact same way, like this:

```
Writing Makefile for Compress::Zlib
-- NOT OK
```

I think the "Writing Makefile for X" message comes from flush() in MakeMakefile.pm, but I have NO idea where the "NOT OK" comes from. The only other error messages follow on from that,
Running make test
Can't test without successful make
Running make install
make had returned bad status, install seems impossible
Please can somebody tell give me some possible causes for this error -- OR suggest some debugging or tracing steps?
Thanks,

Dave Cortesi

Posted on 2005-05-27 08:26:40-07 by eserte in response to 502

AFAIK one has to install some development tools (XCode?) on the Mac to be able to use CPAN.pm.

Posted on 2005-05-27 17:25:07-07 by thorby in response to 503

This user absolutely has devtools installed. Or so she tells me.

However, I do notice that when I have her do cpan> o conf the only difference between her output and mine is the line make which in my system says /usr/bin/make and in hers, is blank.

Let us suppose that she doesn't have /usr/bin/make -- in what way would this cause the consistent error, quote

Writing Makefile for what::ever
NOT OK

Is /usr/bin/make being invoked here?

I should say, that I had her run the test after cpan> debug all and there were no additional error messages.

Posted on 2005-05-28 17:58:55-07 by thorby in response to 506

The problem was in the configuration. When she set make to /usr/bin/make suddenly the error went away.
For the record, between the user and me we wasted at least 8 hours of person-time because CPAN couldn't issue a simple error message, "this install fails because I can't run make."
BTW -- where does that message "NOT OK" come from, anyway? I could never find it.

Posted on 2005-05-30 08:48:18-07 by eserte in response to 508

It's in CPAN.pm, the "make" function.

Posted on 2006-03-24 00:29:49-08 by dull in response to 512

This is all very interesting!! Same things happened to me on a Ubuntu Dapper F5 (virtual machine) install!!

Posted on 2006-03-24 00:34:52-08 by dull in response to 2025

and of course i did not have make installed; I am dull for a reason, but still but still this message is bogus: Writing Makefile for what::ever NOT OK When it could very easily tell me: IDIOT::Install Make ...$%%

Posted on 2006-07-29 13:04:42-07 by jeremiah in response to 2026

I am having the same issue. However, make _is_ installed on my machine. The OS I am running where I see this problem is Mac OS X, I do not get this issue under Ubuntu. I have a version of make, and o conf sees it. If anyone knows a possible work-around I would be grateful.

Posted on 2007-01-16 07:05:55-08 by skavengerx3 in response to 508

I'm having the same problem(I'm a rookie). How do you set make to /usr/bin/make

Posted on 2007-01-16 08:24:38-08 by skavengerx3 in response to 508

I'm having the same problem(I'm a rookie). How do you set make to /usr/bin/make

Posted on 2007-01-22 06:29:02-08 by gavr in response to 4046

```
perl -MCPAN -e shell
CPAN> o conf make /usr/bin/make
```

(or if your using a sun box, its /usr/ccs/bin/make) Check the setting by typing CPAN> o conf to list off the option settings. :o)

Posted on 2007-02-16 23:03:51-08 by fshiekh in response to 4105

Did all the above, make is included in the list when I run o conf, made sure make is in /usr/bin 
Still get the same error when running "make fixdeps" for my RT3 installation on Ubuntu-Server6.10 
Error is 
-- NOT OK
Running make test
Can't run test witout successful make
Running make install 
make had returned bad status, install seems impossible

any suggestions on what to do next? I'm pretty new at this... 
Thanks,
Francesca

Posted on 2007-02-17 03:44:12-08 by schwern in response to 4367

What you should do is download and try to install a Perl module from CPAN without using the CPAN shell. Test-Simple is a good example because it has almost no dependencies and doesn't do anything fancy.
Download it. Unpack it. perl Makefile.PL. make. make test. sudo make install.
If that doesn't work then at least you'll have all the error messages you need. If it does work your CPAN shell is misconfigured. Talk to the Ubuntu folks. Or the CPAN shell folks. This isn't about MakeMaker.

Posted on 2007-05-09 07:34:29-07 by seancoady in response to 4105

Thanks, changing it to /usr/bin/make worked for me too. Don't forget to commit the configuration changes so that they take effect every time: o conf make /usr/bin/make o conf commit

Posted on 2008-03-12 07:51:56-07 by pietie in response to 5095

Hey thanks, this helped me alot as well

Posted on 2008-04-09 13:46:19-07 by hotrod in response to 7326

My problem on Solaris 10 was a bit different. I set the correct $PATH as noted for Solaris earlier in the posts. Each time I tried doing install Bundle::CPAN or the Net::LDAP module I got

```
make: Warning: Ignoring DistributedMake -j option make: Fatal error: No dmake max jobs argument after -j flag /usr/ccs/bin/make -j3 -- NOT OK.
```

I edited the /usr/perl5/5.8.4/lib/CPAN/Config.PM file and changed the 'make_arg' = q[-j3] parameter to 'make_arg' = q[] and now I can install the bundle and any other module directly from the CPAN shell. I am not a programmer, but evidently the version of make that I installed for Solaris could not handle the "number of jobs" flag.

Posted on 2009-10-14 23:04:23-07 by bluecabbie in response to 508

Thanks for posting the answer. I ran into the same problem on an older Mac running as a server. I used 

nano /Users/xxxx/.cpan/CPAN/MyConfig.pm 

to add the path to make and it cleared everything up. It is hard to believe that this has been a problem for 4 years now 

Posted on 2010-01-08 21:28:46-08 by dualsweat in response to 11598


Hello I am somewhat new to Linux and very new to PERL. I am also receiving the same message as posted above. 

I tried using this command as mentioned above but it still fails. I am running Debian Linux sarge.

```
perl -MCPAN -e shell CPAN> o conf make /usr/bin/make 
```

I got into this whole mess by trying to install NET::SSH:Perl. This has been a nightmare.

```
Checking if your kit is complete...
Looks good
Writing Makefile for Math::GMP
cp lib/Math/GMP.pm blib/lib/Math/GMP.pm
AutoSplitting blib/lib/Math/GMP.pm (blib/lib/auto/Math/GMP)
/usr/bin/perl /usr/local/share/perl/5.8.4/ExtUtils/xsubpp  -typemap /usr/share/perl/5.8/ExtUtils/ty
+pemap -typemap typemap  GMP.xs > GMP.xsc && mv GMP.xsc GMP.c
cc -c   -D_REENTRANT -D_GNU_SOURCE -DTHREADS_HAVE_PIDS -DDEBIAN -fno-strict-aliasing -I/usr/local/i
+nclude -D_LARGEFILE_SOURCE -D_FILE_OFFSET_BITS=64 -O2   -DVERSION=\"2.06\" -DXS_VERSION=\"2.06\" -
+fPc
GMP.xs:4:17: gmp.h: No such file or directory
GMP.c: In function `XS_Math__GMP_new_from_scalar':
GMP.c:153: error: `mpz_t' undeclared (first use in this function)
GMP.c:153: error: (Each undeclared identifier is reported only once
GMP.c:153: error: for each function it appears in.)
GMP.c:153: error: `RETVAL' undeclared (first use in this function)
GMP.c: In function `XS_Math__GMP_new_from_scalar_with_base':
GMP.c:178: error: `mpz_t' undeclared (first use in this function)
GMP.c:178: error: `RETVAL' undeclared (first use in this function)
GMP.c: In function `XS_Math__GMP_destroy':
GMP.c:201: error: `mpz_t' undeclared (first use in this function)
GMP.c:201: error: `n' undeclared (first use in this function)
GMP.c:205: error: syntax error before ')' token
GMP.c: In function `XS_Math__GMP_stringify_gmp':
GMP.c:229: error: `mpz_t' undeclared (first use in this function)
GMP.c:229: error: `n' undeclared (first use in this function)
GMP.c:238: error: syntax error before ')' token
GMP.c: In function `XS_Math__GMP_get_str_gmp':
GMP.c:270: error: `mpz_t' undeclared (first use in this function)
GMP.c:270: error: `n' undeclared (first use in this function)
GMP.c:280: error: syntax error before ')' token
GMP.c: In function `XS_Math__GMP_sizeinbase_gmp':
GMP.c:312: error: `mpz_t' undeclared (first use in this function)
GMP.c:312: error: `n' undeclared (first use in this function)
GMP.c:319: error: syntax error before ')' token
GMP.c: In function `XS_Math__GMP_uintify_gmp':
GMP.c:343: error: `mpz_t' undeclared (first use in this function)
GMP.c:343: error: `n' undeclared (first use in this function)
GMP.c:349: error: syntax error before ')' token
GMP.c: In function `XS_Math__GMP_add_ui_gmp':
GMP.c:373: error: `mpz_t' undeclared (first use in this function)
GMP.c:373: error: `n' undeclared (first use in this function)
GMP.c:378: error: syntax error before ')' token
GMP.c: In function `XS_Math__GMP_intify_gmp':
GMP.c:401: error: `mpz_t' undeclared (first use in this function)
GMP.c:401: error: `n' undeclared (first use in this function)
GMP.c:407: error: syntax error before ')' token
GMP.c: In function `XS_Math__GMP_mul_2exp_gmp':
GMP.c:431: error: `mpz_t' undeclared (first use in this function)
GMP.c:431: error: `n' undeclared (first use in this function)
GMP.c:433: error: `RETVAL' undeclared (first use in this function)
GMP.c:437: error: syntax error before ')' token
GMP.c: In function `XS_Math__GMP_div_2exp_gmp':
GMP.c:464: error: `mpz_t' undeclared (first use in this function)
GMP.c:464: error: `n' undeclared (first use in this function)
GMP.c:466: error: `RETVAL' undeclared (first use in this function)
GMP.c:470: error: syntax error before ')' token
GMP.c: In function `XS_Math__GMP_powm_gmp':
GMP.c:497: error: `mpz_t' undeclared (first use in this function)
GMP.c:497: error: `n' undeclared (first use in this function)
GMP.c:499: error: `mod' undeclared (first use in this function)
GMP.c:500: error: `RETVAL' undeclared (first use in this function)
GMP.c:504: error: syntax error before ')' token
GMP.c:511: error: syntax error before ')' token
GMP.c:518: error: syntax error before ')' token
GMP.c: In function `XS_Math__GMP_mmod_gmp':
GMP.c:545: error: `mpz_t' undeclared (first use in this function)
GMP.c:545: error: `a' undeclared (first use in this function)
GMP.c:546: error: `b' undeclared (first use in this function)
GMP.c:547: error: `RETVAL' undeclared (first use in this function)
GMP.c:551: error: syntax error before ')' token
GMP.c:558: error: syntax error before ')' token
GMP.c: In function `XS_Math__GMP_mod_2exp_gmp':
GMP.c:585: error: `mpz_t' undeclared (first use in this function)
GMP.c:585: error: `in' undeclared (first use in this function)
GMP.c:587: error: `RETVAL' undeclared (first use in this function)
GMP.c:591: error: syntax error before ')' token
GMP.c: In function `XS_Math__GMP_add_two':
GMP.c:618: error: `mpz_t' undeclared (first use in this function)
GMP.c:618: error: `m' undeclared (first use in this function)
GMP.c:619: error: `n' undeclared (first use in this function)
GMP.c:620: error: `RETVAL' undeclared (first use in this function)
GMP.c:624: error: syntax error before ')' token
GMP.c:631: error: syntax error before ')' token
GMP.c: In function `XS_Math__GMP_sub_two':
GMP.c:658: error: `mpz_t' undeclared (first use in this function)
GMP.c:658: error: `m' undeclared (first use in this function)
GMP.c:659: error: `n' undeclared (first use in this function)
GMP.c:660: error: `RETVAL' undeclared (first use in this function)
GMP.c:664: error: syntax error before ')' token
GMP.c:671: error: syntax error before ')' token
GMP.c: In function `XS_Math__GMP_mul_two':
GMP.c:698: error: `mpz_t' undeclared (first use in this function)
GMP.c:698: error: `m' undeclared (first use in this function)
GMP.c:699: error: `n' undeclared (first use in this function)
GMP.c:700: error: `RETVAL' undeclared (first use in this function)
GMP.c:704: error: syntax error before ')' token
GMP.c:711: error: syntax error before ')' token
GMP.c: In function `XS_Math__GMP_div_two':
GMP.c:738: error: `mpz_t' undeclared (first use in this function)
GMP.c:738: error: `m' undeclared (first use in this function)
GMP.c:739: error: `n' undeclared (first use in this function)
GMP.c:740: error: `RETVAL' undeclared (first use in this function)
GMP.c:744: error: syntax error before ')' token
GMP.c:751: error: syntax error before ')' token
GMP.c: In function `XS_Math__GMP_bdiv_two':
GMP.c:780: error: `mpz_t' undeclared (first use in this function)
GMP.c:780: error: `m' undeclared (first use in this function)
GMP.c:781: error: `n' undeclared (first use in this function)
GMP.xs:293: error: `quo' undeclared (first use in this function)
GMP.xs:294: error: `rem' undeclared (first use in this function)
GMP.c:789: error: syntax error before ')' token
GMP.c:796: error: syntax error before ')' token
GMP.c: In function `XS_Math__GMP_mod_two':
GMP.c:827: error: `mpz_t' undeclared (first use in this function)
GMP.c:827: error: `m' undeclared (first use in this function)
GMP.c:828: error: `n' undeclared (first use in this function)
GMP.c:829: error: `RETVAL' undeclared (first use in this function)
GMP.c:833: error: syntax error before ')' token
GMP.c:840: error: syntax error before ')' token
GMP.c: In function `XS_Math__GMP_cmp_two':
GMP.c:867: error: `mpz_t' undeclared (first use in this function)
GMP.c:867: error: `m' undeclared (first use in this function)
GMP.c:868: error: `n' undeclared (first use in this function)
GMP.c:874: error: syntax error before ')' token
GMP.c:881: error: syntax error before ')' token
GMP.c: In function `XS_Math__GMP_gmp_legendre':
GMP.c:905: error: `mpz_t' undeclared (first use in this function)
GMP.c:905: error: `m' undeclared (first use in this function)
GMP.c:906: error: `n' undeclared (first use in this function)
GMP.c:912: error: syntax error before ')' token
GMP.c:919: error: syntax error before ')' token
GMP.c: In function `XS_Math__GMP_gmp_jacobi':
GMP.c:943: error: `mpz_t' undeclared (first use in this function)
GMP.c:943: error: `m' undeclared (first use in this function)
GMP.c:944: error: `n' undeclared (first use in this function)
GMP.c:950: error: syntax error before ')' token
GMP.c:957: error: syntax error before ')' token
GMP.c: In function `XS_Math__GMP_gmp_probab_prime':
GMP.c:981: error: `mpz_t' undeclared (first use in this function)
GMP.c:981: error: `m' undeclared (first use in this function)
GMP.c:988: error: syntax error before ')' token
GMP.c: In function `XS_Math__GMP_pow_two':
GMP.c:1012: error: `mpz_t' undeclared (first use in this function)
GMP.c:1012: error: `m' undeclared (first use in this function)
GMP.c:1014: error: `RETVAL' undeclared (first use in this function)
GMP.c:1018: error: syntax error before ')' token
GMP.c: In function `XS_Math__GMP_gcd_two':
GMP.c:1046: error: `mpz_t' undeclared (first use in this function)
GMP.c:1046: error: `m' undeclared (first use in this function)
GMP.c:1047: error: `n' undeclared (first use in this function)
GMP.c:1048: error: `RETVAL' undeclared (first use in this function)
GMP.c:1052: error: syntax error before ')' token
GMP.c:1059: error: syntax error before ')' token
GMP.c: In function `XS_Math__GMP_gmp_fib':
GMP.c:1087: error: `mpz_t' undeclared (first use in this function)
GMP.c:1087: error: `RETVAL' undeclared (first use in this function)
GMP.c: In function `XS_Math__GMP_and_two':
GMP.c:1111: error: `mpz_t' undeclared (first use in this function)
GMP.c:1111: error: `m' undeclared (first use in this function)
GMP.c:1112: error: `n' undeclared (first use in this function)
GMP.c:1113: error: `RETVAL' undeclared (first use in this function)
GMP.c:1117: error: syntax error before ')' token
GMP.c:1124: error: syntax error before ')' token
GMP.c: In function `XS_Math__GMP_xor_two':
GMP.c:1151: error: `mpz_t' undeclared (first use in this function)
GMP.c:1151: error: `m' undeclared (first use in this function)
GMP.c:1152: error: `n' undeclared (first use in this function)
GMP.c:1153: error: `RETVAL' undeclared (first use in this function)
GMP.c:1157: error: syntax error before ')' token
GMP.c:1164: error: syntax error before ')' token
GMP.c: In function `XS_Math__GMP_or_two':
GMP.c:1191: error: `mpz_t' undeclared (first use in this function)
GMP.c:1191: error: `m' undeclared (first use in this function)
GMP.c:1192: error: `n' undeclared (first use in this function)
GMP.c:1193: error: `RETVAL' undeclared (first use in this function)
GMP.c:1197: error: syntax error before ')' token
GMP.c:1204: error: syntax error before ')' token
GMP.c: In function `XS_Math__GMP_gmp_fac':
GMP.c:1232: error: `mpz_t' undeclared (first use in this function)
GMP.c:1232: error: `RETVAL' undeclared (first use in this function)
GMP.c: In function `XS_Math__GMP_gmp_copy':
GMP.c:1256: error: `mpz_t' undeclared (first use in this function)
GMP.c:1256: error: `m' undeclared (first use in this function)
GMP.c:1257: error: `RETVAL' undeclared (first use in this function)
GMP.c:1261: error: syntax error before ')' token
GMP.c: In function `XS_Math__GMP_gmp_tstbit':
GMP.c:1287: error: `mpz_t' undeclared (first use in this function)
GMP.c:1287: error: `m' undeclared (first use in this function)
GMP.c:1294: error: syntax error before ')' token
GMP.c: In function `XS_Math__GMP_gmp_sqrt':
GMP.c:1318: error: `mpz_t' undeclared (first use in this function)
GMP.c:1318: error: `m' undeclared (first use in this function)
GMP.c:1319: error: `RETVAL' undeclared (first use in this function)
GMP.c:1323: error: syntax error before ')' token
make: *** [GMP.o] Error 1
  TURNSTEP/Math-GMP-2.06.tar.gz
  /usr/bin/make -- NOT OK
Running make test
  Can't test without successful make
Running make install
  Make had returned bad status, install seems impossible
Failed during this command:
 TURNSTEP/Math-GMP-2.06.tar.gz                : make NO

cpan[4]> exit    
```


(This article is based on a thread on the CPAN::Forum.)
<!-- from http://cpanforum.com/threads/502 -->

