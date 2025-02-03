---
title: "Modules - Behind the scenes"
timestamp: 2017-03-01T08:30:11
tags:
  - perldoc
  - -l
  - -m
types:
  - screencast
books:
  - advanced
published: true
author: szabgab
---


Let's look at some module that are installed with perl by default, and let's look a bit behind
the scenes of the modules.


<slidecast file="advanced-perl/libraries-and-modules/behind-the-scenes" youtube="5P3EbdwGNmQ" />

You already know that when perl encounters a `use` statement, it will look for a file with the same
name, but with `.pm` extension in the directories listed in the `@INC` array.

So if we write `use Cwd;`, perl will look for a file called `Cwd.pm` in
the directories listed in `@INC`.

What is in `@INC` you can check using `perl -V` as explained in [this episode](/require-at-inc).

## perldoc

If you don't have the `perldoc` command installed then on Linux system you usually need to install the
package called `perl-doc` in order to have the `perldoc` command.

If you have it then you can type `perldoc Cwd` (or the name of any other module) and it will
show the documentation of the module. (Use the space-bar to go forward a page and use the `q` key to quit the reader.)

Running `perldoc -l Cwd` will print out the location of the file containing the module:  `/usr/lib/perl5/Cwd.pm`.

This can be a useful aid to make sure the correct version of the module is loaded.


`perldoc -m Cwd` will show the source code of the file implementing the module.

As we flip though the source code of Cwd we can see it uses `strict` and we can also
see the following snippet:

```perl
@EXPORT = qw(cwd getcwd fastcwd fastgetcwd);
push @EXPORT, qw(getdcwd) if $^O eq 'MSWin32';
@EXPORT_OK = qw(chdir abs_path fast_abs_path realpath fast_realpath);
```

We can see how it inserts values to the `@EXPORT` ok, but the next line
is interesting. It pushes another entry onto the `@EXPORT` array if the operating system is MS Windows.

From this you can see that these variables can be quite dynamic and can be filled based on various conditions.

There is also the `@EXPORT_OK` array with additional functions that [can be imported optionally](/on-demand-import).
If they are needed, but they won't be imported by default.

So now you also know how to look at the source code of a module on your system. Alternatively you can browse to the module on MetaCPAN,
for example to the  [Cwd](https://metacpan.org/pod/Cwd) module and click on the "Source" link on the left hand side.
That will show the source code of the most recent version of the module.

