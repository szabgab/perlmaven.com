---
title: "7 of the most useful Perl command line options"
timestamp: 2018-08-31T12:00:56
tags:
  - -v
  - -e
  - -E
  - -p
  - -i
published: true
author: szabgab
---


Perl has a lot of command line options. Some of them can be used to do very useful things, others are more esoteric.
In the [Perl tutorial](/perl-tutorial) we already saw how to use [Perl on the command line](/perl-on-the-command-line),
let's now extend that list.


## -v to get the Perl version

This options just shows the version number of the Perl interpreter and the Copyright information:

```
$ perl -v


This is perl 5, version 20, subversion 1 (v5.20.1) built for darwin-thread-multi-2level

Copyright 1987-2014, Larry Wall

Perl may be copied only under the terms of either the Artistic License or the
GNU General Public License, which may be found in the Perl 5 source kit.

Complete documentation for Perl, including FAQ lists, should be found on
this system using "man perl" or "perldoc perl".  If you have access to the
Internet, point your browser at http://www.perl.org/, the Perl Home Page.
```


## -V to get compiler details

Besides the version number, this command line option will tell Perl to print
all the information about the platform we are currently running on (In the following
example osname=darwin means Mac OSX.

It also provides the configuration parameters - the way our version of
[Perl was compiled](/how-to-build-perl-from-source-code). The
same information is available via the [Config](https://metacpan.org/pod/Config) module during the runtime
of our code.

The `%ENV` part, if available, shows the Perl-related environment variables that
are currently in effect. These environment variables can be set in the Unix/Linux
shell or the Windows Command Window, before running Perl.

Finally it lists the content of the [@INC](/search/@INC) array, that controls where Perl will look for modules
to load. One can [change @INC](/how-to-change-inc-to-find-perl-modules-in-non-standard-locations) in several ways.

```
$ perl -V

Summary of my perl5 (revision 5 version 20 subversion 1) configuration:
   
  Platform:
    osname=darwin, osvers=13.3.0, archname=darwin-thread-multi-2level
    uname='darwin air.local 13.3.0 darwin kernel version 13.3.0: tue jun 3 21:27:35 pdt 2014; root:xnu-2422.110.17~1release_x86_64 x86_64 '
    config_args='-de -Dprefix=/Users/gabor/perl5/perlbrew/perls/perl-5.20.1_WITH_THREADS -Dusethreads -Aeval:scriptdir=/Users/gabor/perl5/perlbrew/perls/perl-5.20.1_WITH_THREADS/bin'
    hint=recommended, useposix=true, d_sigaction=define
    useithreads=define, usemultiplicity=define
    use64bitint=define, use64bitall=define, uselongdouble=undef
    usemymalloc=n, bincompat5005=undef
  Compiler:
    cc='cc', ccflags ='-fno-common -DPERL_DARWIN -fno-strict-aliasing -pipe -fstack-protector -I/usr/local/include',
    optimize='-O3',
    cppflags='-fno-common -DPERL_DARWIN -fno-strict-aliasing -pipe -fstack-protector -I/usr/local/include'
    ccversion='', gccversion='4.2.1 Compatible Apple LLVM 5.1 (clang-503.0.40)', gccosandvers=''
    intsize=4, longsize=8, ptrsize=8, doublesize=8, byteorder=12345678
    d_longlong=define, longlongsize=8, d_longdbl=define, longdblsize=16
    ivtype='long', ivsize=8, nvtype='double', nvsize=8, Off_t='off_t', lseeksize=8
    alignbytes=8, prototype=define
  Linker and Libraries:
    ld='env MACOSX_DEPLOYMENT_TARGET=10.3 cc', ldflags =' -fstack-protector -L/usr/local/lib'
    libpth=/usr/local/lib /Applications/Xcode.app/Contents/Developer/Toolchains/XcodeDefault.xctoolchain/usr/bin/../lib/clang/5.1/lib /Applications/Xcode.app/Contents/Developer/Toolchains/XcodeDefault.xctoolchain/usr/lib /usr/lib
    libs=-lgdbm -ldbm -ldl -lm -lutil -lc
    perllibs=-ldl -lm -lutil -lc
    libc=, so=dylib, useshrplib=false, libperl=libperl.a
    gnulibc_version=''
  Dynamic Linking:
    dlsrc=dl_dlopen.xs, dlext=bundle, d_dlsymun=undef, ccdlflags=' '
    cccdlflags=' ', lddlflags=' -bundle -undefined dynamic_lookup -L/usr/local/lib -fstack-protector'


Characteristics of this binary (from libperl): 
  Compile-time options: HAS_TIMES MULTIPLICITY PERLIO_LAYERS
                        PERL_DONT_CREATE_GVSV
                        PERL_HASH_FUNC_ONE_AT_A_TIME_HARD
                        PERL_IMPLICIT_CONTEXT PERL_MALLOC_WRAP
                        PERL_NEW_COPY_ON_WRITE PERL_PRESERVE_IVUV
                        USE_64_BIT_ALL USE_64_BIT_INT USE_ITHREADS
                        USE_LARGE_FILES USE_LOCALE USE_LOCALE_COLLATE
                        USE_LOCALE_CTYPE USE_LOCALE_NUMERIC USE_PERLIO
                        USE_PERL_ATOF USE_REENTRANT_API
  Built under darwin
  Compiled at Sep 16 2014 21:55:45
  %ENV:
    PERLBREW_BASHRC_VERSION="0.63"
    PERLBREW_HOME="/Users/gabor/.perlbrew"
    PERLBREW_MANPATH="/Users/gabor/perl5/perlbrew/perls/perl-5.20.1_WITH_THREADS/man"
    PERLBREW_PATH="/Users/gabor/perl5/perlbrew/bin:/Users/gabor/perl5/perlbrew/perls/perl-5.20.1_WITH_THREADS/bin"
    PERLBREW_PERL="perl-5.20.1_WITH_THREADS"
    PERLBREW_ROOT="/Users/gabor/perl5/perlbrew"
    PERLBREW_VERSION="0.63"
  @INC:
    /Users/gabor/perl5/perlbrew/perls/perl-5.20.1_WITH_THREADS/lib/site_perl/5.20.1/darwin-thread-multi-2level
    /Users/gabor/perl5/perlbrew/perls/perl-5.20.1_WITH_THREADS/lib/site_perl/5.20.1
    /Users/gabor/perl5/perlbrew/perls/perl-5.20.1_WITH_THREADS/lib/5.20.1/darwin-thread-multi-2level
    /Users/gabor/perl5/perlbrew/perls/perl-5.20.1_WITH_THREADS/lib/5.20.1
    .
```

## -e execute code on the command line

For one-off tasks it can be very useful to be able to run a piece of Perl code without creating a file.
The code itself needs to be between quotes. Due to differences between the Unix/Linux shell 
and the MS Windows Command prompt we need to use different quotes around our code.

On Unix/Linux systsem (including Mac OSX) it is recommended to put our code in single quotes as in the following
example:

```
$ perl -e 'print qq{Hello World\n}'

Hello World
```

On MS Windows we must use double quotes around our code.

```
$ perl -e "print qq{Hello World\n}"

Hello World
```

Internally, it is probably the best to use [q and qq](/quoted-interpolated-and-escaped-strings-in-perl)
instead of single-quote and double-quote, respectively. That might help reduce the confusion caused by
the behavior of the shell and command prompt.


## -E execute code on the command line with all the latest features enabled

Since version 5.10 of Perl has been released, Perl includes some additional
keywords (called features) in the language. For improved backward compatibility these keywords are only
enabled if the user explicitly ask for them with `use feature ...`. For example by writing `use feature qw(say);`,
or by declaring a minimal version of Perl with `use 5.010;`.

On the command line we can achieve the same by using `-E` instead of `-e`.
It will turn on all the features of the version of Perl we are currently running.

For me the most important of all these features, at least in one-liners is the
[say keyword introduced in perl 5.10](/what-is-new-in-perl-5.10--say-defined-or-state).
It is just `print` with a trailing newline added. Nothing fancy, but makes the one-liners even shorter.

The above examples would look like these:

Unix/Linux:

```
$ perl -E 'say q{Hello World}'

Hello World
```

MS Windows:

```
$ perl -E "say q{Hello World}"

Hello World
```

You can notice the change from `qq` to `q`. As we don't need to include a newline `\n` in our
strings we could switch from [qq to q](/quoted-interpolated-and-escaped-strings-in-perl).

## -n wrap the -e/-E code in a while loop

If we provide the `-n` command line option it will wrap our code provided using either the `-e`
or the `-E` options in a `while` with a [diamond operator](/the-diamond-operator).

So

```
perl -n -E 'say if /code/' file.txt
```

is the same as

```
while (<>) {
    say if /code/;
}
```

That will go over all the lines of all the files provided on the command line
(in this case it is file.txt) and print out every line that matches the `/code/` regex.


## -p is like -n with print $_

The `-p` option is very similar to the `-n` flag, but it also prints the content of `$_`
at the end of each iteration.

So we could write:

```
perl -p -E 's/code/foobar/' file.txt
```

which would become

```
while (<>) {
    s/code/foobar/
    print;
}
```

That will print the result to the screen.

## -i for in-place editing

The most common use of `-p` is together with the `-i` option that provides "in-place editing".
It means that instead of printing to the screen, all the output generated by our one-liner will be written back to the same file it was taken from.

So this one-liner will replace the first appearance of the string "code" by "foobar" in every line of the file "file.txt".

```
perl -i -p -E 's/code/foobar/' file.txt
```



## Screencasts

There are a number of screencasts showing some of the command line options:

[Perl on the command line](/beginner-perl-maven-command-line)

[One-liner sum of column in CSV](/beginner-perl-maven-oneliner-sum-of-csv)

Another article show an example of [Perl on the command line using -e, -p, -i](/perl-on-the-command-line).

## Comments

Your code snippet for -p has a bug (two bugs; -p works subtly differently from what your translation suggests, which you can show by including a next in the program): you need a ; after the s/// statement, or it's not valid Perl.

<hr>

Ooh. I didn't know -E. I'd been using -M5.010 -e.

<hr>
Thanks..Can we see at which line the changes has been done?
<hr>


perl main_raman_bfl.pl -p 1 -i 1 -e 0
This Perl not built to support threads
Compilation failed in require at main_raman_bfl.pl line 5.
BEGIN failed--compilation aborted at main_raman_bfl.pl line 5.

What is issue?

