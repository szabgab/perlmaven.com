---
title: "gettext function not found. Please install libintl at Makefile.PL"
timestamp: 2010-01-26T12:19:32
tags:
  - gettext
  - libintl
published: true
archive: true
---



Posted on 2010-01-26 12:19:32.850585-08 by milan

On FreeBSD when you try to compile the Locale::gettext using Perl 5.10.1 you may get an error message that says: gettext function not found.
Please install libintl at Makefile.PL line 18. So my solution is pretty simple:

CC='cc -L/usr/local/lib -I/usr/local/include' perl Makefile.PL
Tada! My logic is we piggy back off of the environment variable that is already built-in into the Makefile.pl and have it go for the compiler,
but also inject the various paths (since apparently it's having trouble finding the libintl library on its own). With this method you will be able to compile successfully. BEFORE:

```
prompt> perl Makefile.PL
checking for gettext... no
checking for gettext in -lintl... no
gettext function not found. Please install libintl at Makefile.PL line 18.
```


AFTER:

```
prompt> CC='cc -L/usr/local/lib -I/usr/local/include' perl Makefile.PL
checking for gettext... no
checking for gettext in -lintl... yes
checking for dgettext in -lintl... yes
checking for ngettext in -lintl... yes
checking for bind_textdomain_codeset in -lintl... yes
Writing Makefile for Locale::gettext

prompt> make
cp gettext.pm blib/lib/Locale/gettext.pm
/usr/bin/perl /usr/local/lib/perl5/5.10.1/ExtUtils/xsubpp -typemap /usr/local/lib/perl5/5.10.1/ExtUtils/typemap gec
Please specify prototyping behavior for gettext.xs (see perlxs manual)
cc -c -DHAS_FPSETMASK -DHAS_FLOATINGPOINT_H -fno-strict-aliasing -pipe -fstack-protector -I/usr/local/include -O c
Running Mkbootstrap for Locale::gettext ()
chmod 644 gettext.bs
rm -f blib/arch/auto/Locale/gettext/gettext.so
LD_RUN_PATH="/usr/local/lib" cc -shared -L/usr/local/lib -fstack-protector gettext.o -o blib/arch/auto/Locale/get
chmod 755 blib/arch/auto/Locale/gettext/gettext.so
cp gettext.bs blib/arch/auto/Locale/gettext/gettext.bs
chmod 644 blib/arch/auto/Locale/gettext/gettext.bs
Manifying blib/man3/Locale::gettext.3

prompt> make install
Files found in blib/arch: installing files in blib/lib into architecture dependent library tree
Installing /usr/local/lib/perl5/site_perl/5.10.1/i386-freebsd/auto/Locale/gettext/gettext.so
Installing /usr/local/lib/perl5/site_perl/5.10.1/i386-freebsd/auto/Locale/gettext/gettext.bs
Installing /usr/local/lib/perl5/site_perl/5.10.1/i386-freebsd/Locale/gettext.pm
Installing /usr/local/man/man3/Locale::gettext.3
Appending installation info to /usr/local/lib/perl5/5.10.1/i386-freebsd/perllocal.pod
```

Hope this helps.

Posted on 2010-01-26 12:24:32.943902-08 by milan in response to 12249

Keep in mind that you can also substitute the compiler (cc) for any other compiler you need (e.g. gcc). Milan Adamovsky

(This article is based on a thread on the CPAN::Forum.)
<!-- from http://cpanforum.com/threads/11249 -->


