---
title: "undefined reference to boot_DynaLoader"
timestamp: 2006-01-24T02:21:32
tags:
  - ExtUtils::Embed
published: true
archive: true
---



Posted on 2006-01-24 02:21:32-08 by guitarmarkus

Hi, I'm trying to use PERL inside C code. I got to the point where I can run a simple perl program in C code. Now I want to use some existing code that uses dynamic loading such as use Data::Dumper;
I read in many places that you have to add some "glue" code for it to work:

```
EXTERN_C void boot_DynaLoader (pTHX_ CV* cv);
EXTERN_C void boot_Socket (pTHX_ CV* cv);
EXTERN_C void xs_init(pTHX) { char *file = __FILE__;
    dXSUB_SYS;
    /* DynaLoader is a special case */
    newXS("DynaLoader::boot_DynaLoader", boot_DynaLoader, file);
    newXS("Socket::bootstrap", boot_Socket, file);
}
```

but when I try compiling I get an error:

```
Building target:
testC i686-pc-linux-gnu-gcc -L/usr/lib/ -rdynamic -L/usr/local/lib /usr/lib/perl5/5.8.6/i686-linux/auto/DynaLoader/DynaLoader.a -L/usr/lib/perl5/5.8.6/i686-linux/CORE
   -lperl -lpthread -lnsl -ldl -lm -lcrypt -lutil -lc -o testC seq
Test.o test.o -lperl -lJudy seq
Test.o: In function xs_init': ../seq
Test.c:26: undefined reference to boot_DynaLoader' ../seq
Test.c:27: undefined reference to boot_Socket'
```

I use all the flags and libraries that were used to build my perl. I run on Linux with GenToo.

I've been struggling with this one for half a day and running out of ideas... Anybody have a clue what could be wrong?

Thanks Mark

Posted on 2006-07-25 13:37:33-07 by skanchi in response to 1693

the DynaLoader.a is in 'ar' format. so you can extract the object file in it by issuing the command: ar xv DynaLoader.a

You then, copy the extracted DynaLader.o in your build directory. and specfiy it to the ld.


Posted on 2007-05-24 13:37:18-07 by karthic in response to 1693

Hi,

EXTERN_C void boot_Socket (pTHX_ CV* cv) is not always required.

The following will generate perlxsi.c that will have what is exactly required

```
perl -MExtUtils::Embed -e xsinit -- -o perlxsi.c
```

In my case, i didnt get that reference boot_Socket.


For more refrence, refer [here](http://perldoc.perl.org/perlembed.html#Using-Perl-modules%2c-which-themselves-use-C-libraries%2c-from-your-C-program)

- Karthic

Posted on 2007-05-24 13:39:44-07 by karthic in response to 1693

And it should not be

```
-L/usr/local/lib /usr/lib/perl5/5.8.6/i686-linux/auto/DynaLoader/DynaLoader.a
```


It should be

```
/usr/local/lib /usr/lib/perl5/5.8.6/i686-linux/auto/DynaLoader/DynaLoader.a
```

- Karthic

(This article is based on a thread on the CPAN::Forum.)
<!-- from http://cpanforum.com/threads/1693 -->

