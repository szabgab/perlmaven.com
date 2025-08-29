---
title: "How to read a password on the command line?"
timestamp: 2014-11-11T08:30:01
tags:
  - Term::ReadPassword::Win32
  - read_password
  - STDIN
  - security
published: true
author: szabgab
---


If a script needs to use a password to do something there are several choices. There are many insecure solutions and a few that are more secure.



## Clear text on the command line

One would be to accept the password in clear-text format on the command line. The value will be in [@ARGV](/argv-in-perl)
which can be processed manually or [using Getopt::Long](/how-to-process-command-line-arguments-in-perl).
Regardless of how we process the values passed on the command line, they are still on the command line. 
This means someone watching over our shoulders will be able to see the password. Even worse the commands we type in will be saved in
the history of the commands (at least on Linux/Unix machines) which means someone who gains access to your local account will be able to look at that.
Even worse, you might backup that file and the backup can reach all kinds of other places as well.


## Read from STDIN

The other solution would be to read from STDIN using the readline operator:

```perl
print "Password: ";
my $pw = <STDIN>;

print $pw;
```

In this case the script will prompt you for the password and you will need to type it in.
This will be better as the original command does not contain the password and thus it is not
saved in the history file, but a person standing behind your shoulder could still see the clear-text
password as you type it in.


## Read from STDIN using Term::ReadPassword::Win32

There is a solution to this problem in the [Term::ReadPassword::Win32](https://metacpan.org/pod/Term::ReadPassword::Win32) module,
which despite its name will work on both on MS Windows and Unix/Linux systems. (It is not my module, but I have started to maintain it a while ago.)

It is also rather simple to use:

```perl
use strict;
use warnings;
use 5.010;

use Term::ReadPassword::Win32 qw(read_password);
my $input = read_password("Password: ");
say $input;
```

This will prompt you for a password, but as you type in the password it won't echo it back.
Well, in the above example we have the `say $input` just so you can see it worked, but
in normal circumstances you would not do that, would you.


Of course if someone standing over your shoulder can read the **keyboard** as you type in the password, that's still
a problem, but for that one of the solutions is just to type very fast.


