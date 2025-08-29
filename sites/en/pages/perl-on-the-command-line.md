---
title: "Perl on the command line"
timestamp: 2013-01-17T14:45:56
tags:
  - -v
  - -e
  - -p
  - -i
published: true
books:
  - beginner
author: szabgab
---


While most of the [Perl tutorial](/perl-tutorial) deals with scripts saved in a
file, we'll also see a couple of examples of **one-liners**.

Even if you are using [Padre](http://padre.perlide.org/)
or some other IDE that would let you run your script from the editor itself,
it is very important to familiarize yourself with the command line (or shell) and
be able to use perl from there.


If you are using Linux, open a terminal window. You should see a
prompt, probably ending with a $ sign.

If you are using Windows open a command window: Click on

Start -&gt; Run -&gt; type in "cmd" -&gt; ENTER

You will see the black window of CMD with a prompt that probably looks like this:

```
c:\&gt;
```

## Perl version

Type in `perl -v`. This will print something like this:

```
c:\&gt; perl -v

This is perl 5, version 12, subversion 3 (v5.12.3)
  built for MSWin32-x86-multi-thread

Copyright 1987-2010, Larry Wall

Perl may be copied only under the terms of either the Artistic License or the
GNU General Public License, which may be found in the Perl 5 source kit.

Complete documentation for Perl, including FAQ lists, should be found on
this system using "man perl" or "perldoc perl".  If you have access to the
Internet, point your browser at http://www.perl.org/, the Perl Home Page.
```

Based on this, I can see that I have version 5.12.3 of Perl installed on this Windows machine.


## Printing a number

Now type in `perl -e "print 42"`.
This will print the number `42` on the screen. On Windows the prompt will appear on the next line

```
c:&gt;perl -e "print 42"
42
c:&gt;
```

On Linux you will see something like this:

```
gabor@pm:~$ perl -e 'print 42'
42gabor@pm:~$
```

Please note, I used single-quote `'` in Linux and double-quote `"` on Windows.
This is due to the different behaviour of the command line on these two operating systems.
Nothing to do with Perl.  In general on Linux/Unix always use single-quotes around the code snippet,
on Windows always use double-quotes.

The result is on the beginning of the line, immediately followed by the prompt.
This difference is due to different in the behavior of the two command-line interpreters.

In this example we use the `-e` flag that tells perl,
"Don't expect a file. The next thing on the command-line is the actual Perl code."

The above examples are of course not too interesting. Let me show you a slightly more complex
example, without explaining it:

## Replace Java by Perl

This command: `perl -i.bak -p -e "s/\bJava\b/Perl/" resume.txt`
will replace all appearance of the word **Java** by the word **Perl** in your
résumé while keeping a backup of the file.

On Linux you could even write this `perl -i.bak -p -e 's/\bJava\b/Perl/' *.txt`
to replace Java by Perl in **all** your text files.

(Again, please note, on Linux/Unix you should probably always use single-quotes on the command line,
while on Windows double-quotes.)

In a later section we'll talk more about one-liners and you'll learn how to use them.
Enough to say, the knowledge of one-liners is a very powerful weapon in your hands.

BTW If you are interested in some very good one-liners, I'd recommend reading
[Perl One-Liners explained](http://www.catonmat.net/blog/perl-book/)
by Peteris Krumins.

If you need to do the same task, but as part of a larger script, check out
the article on [how to replace a string in a file](/how-to-replace-a-string-in-a-file-with-perl).

## Next

The next part is about
[core Perl documentation and CPAN module documentation](/core-perl-documentation-cpan-module-documentation).

## Comments

Hi,

I wanted to write below command line program into a script, could you please help me on this.

perl -pe 's/^/###TEMP/g;' text.rpt | exec perl -pe 'chomp ; s/Scenario/\n Scenario/g ;' | exec perl -pe 's/###TEMP/ ;/g' > ${p}/hh1

<hr>

use strict;
use warnings;


my $inData = <<indata; <p="">
int abc;



.abc(abc);


INDATA

open my $in_fh1, '<', \$inData;


while (my $line = <$in_fh1>) {

if( my ($intro) = $line =~ /([.(]?abc)/g){

print "${intro}_$_;\n" for 1 .. 2;

}

}
close $in_fh1;



My output should be



int abc_1;



int abc_2;



.abc_1(abc_1);



.abc_2(abc_2);


But it is coming



abc_1;



abc_2;



.abc_1;



.abc_2;



Where is the mistake ?

## Comments

Hi,

I wanted to write below command line program into a script, could you please help me on this.

perl -pe 's/^/###TEMP/g;' text.rpt | exec perl -pe 'chomp ; s/Scenario/\n Scenario/g ;' | exec perl -pe 's/###TEMP/ ;/g' > ${p}/hh1

<hr>

use strict;
use warnings;


my $inData = <<indata; <p="">
int abc;



.abc(abc);


INDATA

open my $in_fh1, '<', \$inData;


while (my $line = <$in_fh1>) {

if( my ($intro) = $line =~ /([.(]?abc)/g){

print "${intro}_$_;\n" for 1 .. 2;

}

}
close $in_fh1;



My output should be



int abc_1;



int abc_2;



.abc_1(abc_1);



.abc_2(abc_2);


But it is coming



abc_1;



abc_2;



.abc_1;



.abc_2;



Where is the mistake ?


