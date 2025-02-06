---
title: "CLI - Command Line Interface in Perl"
timestamp: 2019-04-27T11:30:01
tags:
  - "@ARGV"
  - GetOpt::Long
  - STDIN
published: true
author: szabgab
archive: true
---


Some of the Perl code has [GUI - Graphical User Interface](/gui), many applications have
a [web interface](/modern-web-with-perl), but most of the Perl code we write are command line tools.


A command line tool will get user input from two places:

* Command line paramerers
* Prompts on the STDOUT and responses typed in to the STDIN

Of course they also read files and databases, but the user who runs the code has those two options.

## Command line parameter or command line arguments

The come in the following forms:

```
myapp.pl param1 param2 param3

myapp.pl --name param1 --age param2 --height param3 --debug

myapp.pl -n param1 -a param2 -h param3 -d
```

There are plenty of related articles. Look especially at the first two:

* [Processing command line arguments - @ARGV in Perl](/argv-in-perl)
* [How to process command line arguments in Perl using Getopt::Long](/how-to-process-command-line-arguments-in-perl)
* [Process command line using Getopt::Long (screencast)](/beginner-perl-maven-process-command-line-using-getopt-long-screencast)
* [Command line parameters (screencast)](/beginner-perl-maven-command-line-parameters-screencast)
* [Switching to Moo - adding command line parameters](/switching-to-moo-adding-command-line-parameters)
* [Command line phonebook with MongoDB and Moo](/phonebook-with-mongodb-and-moo)


## STDOUT/STDIN - Standart output/Standard Input

The other possibility is to ask the user questions during the run-time of the process. The code would print out a
question to the screen (STDOUT or Standard Output) and the user would type in the answer that would be received
by the program from the keyboard on STDIN or Standard Input.


* [Prompt, read from STDIN, read from the keyboard in Perl](/read-from-stdin)
* [STDIN in scalar and list context](/stdin-in-scalar-and-list-context)
* [How to read a password on the command line?](/how-to-read-a-password-on-the-command-line)
* [IO::Prompter](/prompt-using-io-prompter)

