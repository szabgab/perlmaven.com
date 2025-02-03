---
title: "How to add a relative directory to @INC"
timestamp: 2015-04-13T09:50:00
tags:
  - Path::Tiny
  - path
  - FindBin
  - $Bin
  - File::Spec
  - catdir
  - File::Basename
  - dirname
  - Dir::Self
  - __DIR__
  - @INC
  - lib
  - rlib
  - FindBin::libs
published: true
books:
  - advanced
author: szabgab
---


When writing an application, or even "just" a module with a command line script,
it is very useful to make sure every `use` statement
will load the modules from a directory <b>relative</b>
to where the main Perl program can be found.

This will make sure that when you are developing the code, it won't,
by accident, load the old installed versions of the modules.

If you check out several copies of the whole project from your version control system.
In each copy the scripts will use the module in the same copy. So you can work on several
changes at the same time without them interfering with each other.



## Directory layout and use-case

A common directory layout of a project would look like this:

```
.../
    project/
        script/
            app.pl
            code.pl
        lib/
            App/
                Module.pm
                Other/
                    Class.pm
```

Though there might be some other files and directories, this is what currently interests us.

There are several executable scripts like the `app.pl` and the `code.pl` in our case.
They are all placed in the directory called `script` inside the project directory.
(Though some people would use the name `bin` instead of `script`, this does not matter for us.)

Each one of these scripts start like this:

```perl
use strict;
use warnings;
use 5.010;

use App::Module;
use App::Other::Class;

...
```

If we run this script it will try to load the file implementing `App::Module`, and later the file
implementing `App::Other::Class`.

In order to find `App::Module` perl will go over the content of
the `@INC` array that has a list of file-system directory paths in it.
It will look for a subdirectory called `App` and within that subdirectory
a file called `Module.pm`.

The content of `@INC` was set when Perl was installed and while in another article we can see
[how to change @INC](/how-to-change-inc-to-find-perl-modules-in-non-standard-locations)
in several ways, but in all those cases we assumed we know the absolute location of the module within the file-system.

In our case we would like to make sure that the `app.pl`
script will find the module in the `lib` directory next to it,
regardless of where we put the whole `project` directory.

We would even like to be able to have 2 or more copies of the whole tree,
and each copy of the `app.pl` script should find
and load the module from the directory next to it.

This is especially important during development. We might make some changes
to the code in one copy of the tree, and we might be working on a totally
different change in the other copy. Maybe even on a totally different version of the application.

So we would like to make sure each script will find the module relative to the location of the script.

In other words we would like to <b>add a directory relative to the location of the script to @INC</b>.

Let me stress that. We are not trying to add a directory relative to the <b>current working directory</b>,
but relative to the directory where the script can be found.

## Solution 1 - FindBin

```perl
use FindBin;
use File::Spec;
use lib File::Spec->catdir($FindBin::Bin, '..', 'lib');
```

The `FindBin` module has a global variable called `$Bin` that we can access as `$FindBin::Bin`.
It contains the path to the directory where the current script can be found. (In our case that would `.../project/script`.)
The `catdir` method of the `File::Spec` module/class can concatenate parts of a file-system path in
a platform specific way. It is almost like [join](/join) except that the string it uses to join the parameters depends
on the Operating System. On Unix/Linux that will be a slash (`/`). On Windows that will be back-slash (`\`).
On some other operating systems it might be something else.

So `File::Spec->catdir($FindBin::Bin, '..', 'lib')` means take the path, go one directory up and then descend into the
`lib` directory.

Passing that path as a parameter to `use lib` will add the path
to the beginning of `@INC`. So our scripts will look like this:

```perl
use strict;
use warnings;
use 5.010;

use FindBin;
use File::Spec;
use lib File::Spec->catdir($FindBin::Bin, '..', 'lib');

use App::Module;
use App::Other::Class;

...
```

One of the advantages of this example is that both modules are standard.

## Solution 2 - $0

In the second solution we rely on `$0` that always contains the name of the
current executable script.

```perl
use File::Basename;
use File::Spec;
use lib File::Spec->catdir(
            File::Basename::dirname(File::Spec->rel2abs($0)),
            '..',
            'lib');
```

Because `$0` might contain just the name of the script we first need to
ask the currently running Perl to calculate the absolute path. We do that using
the `rel2abs` method of the `File::Spec` module. Once we have the
absolute path, we get rid of the last part of the path which is the name of the file
We do that by calling the `dirname` function of `File::Basename</hl.

Then, as before, we use `catdir` to go one directory up (`..`) and
then descend to the `lib` directory.

This solution too uses only standard modules.

## Solution 3 - Cwd

In the above example we could replace the call `File::Spec->rel2abs($0)`
by a call to `Cwd::abs_path($0)`.
That would still work the same way.

## Solution 4 - Dir::Self

Another solution I saw recently uses [Dir::Self](https://metacpan.org/pod/Dir::Self).
When loading, this module will add a symbol `__DIR__` to the name-space of the current code.
This symbol contains the absolute path to the directory where the file is located.
So we only need to compute the relative directory using `catdir`:

```perl
use Dir::Self;
use lib File::Spec->catdir(
            __DIR__,
            '..',
            'lib');
```

This solution already looks better, but it has the drawback of needing an external module.
There is also this thing with the strange-looking `_DIR__` symbol.

Under the hood, the `__DIR__` function uses the following code-snippet to
to calculate the current directory:

```perl
my $file = (caller 0)[1];
File::Spec->rel2abs(join '', (File::Spec->splitpath($file))[0, 1])
```

## Solution 5 - Path::Tiny

The solution that I currently like the best, involves the use of the
[Path::Tiny](https://metacpan.org/pod/Path::Tiny) module

```perl
use Path::Tiny qw(path);
use lib path($0)->absolute->parent(2)->child('lib')->stringify;
```

`Path::Tiny` by default exports the `path` function, but I like to be explicit
- for the sake of the maintenance programmer who will need to figure out where does the `path`
function come from -, so I load the module by writing `use Path::Tiny qw(path);`.

Given an absolute or relative path, the `path` function returns an object representing that
thing in the file-system. We passed the `$0` variable that contains the name of the script
being executed.

The `absolute` method turns it into an absolute path even if it was a relative path originally.

That's important, because if we run the script from the same directory where the script is:
`perl programming.pl`, then `$0` will only contain <b>programming.pl</b> and
it will be hard to find out what is the parent directory. With absolute paths, we don't have
the problem.

The `parent` method will point to the parent directory. While it is longer than writing `'..'`
but our intentions are clearer with `parent`, than if we wrote `'..'` or even if we called
`dirname`.

In addition, though we don't need it for our purposes, you can pass a number to it (e.g. `parent(2)`)
and go several levels up in one call.

Then we are calling the `child` method with the name of the specific child-directory.

This returns a `Path::Tiny` object so we still need to call the `stringify`
method to turn it into a real string.

I think our intentions are much clearer with this code, and besides, the `Path::Tiny` module
is very useful for other tasks as well. We used it in the article
[fetching whois records](/checking-the-whois-record-of-many-domains), for
locating a file and reading the content into memory.

## Solution 6 - Path::Tiny

As suggested by Yary H in the comments, we can even make it shorter and nicer by using the `sibling` method:

```perl
use Path::Tiny qw(path);
use lib path($0)->absolute->parent->sibling('lib')->stringify;
```

## Solution 7 - rlib

I've never seen this before but Tony Edwardson has suggested  [rlib](https://metacpan.org/pod/rlib) which looks great.
It has not seen any release since 1998, but it very simple and it seems to "just work". (I've tried on Linux and OSX.)

```perl
use rlib '../lib';
```


## Solution 8 - FindBin::libs

[FindBin::libs](https://metacpan.org/pod/FindBin::libs) is a bit magical. By default it looks around the location
of the currently running script, finds the `lib` directory and adds it to `@INC`. You only need to load the module:

```perl
use FindBin::libs;
```

It will work with seeral directory layouts. I have tried the following two cases:

```
/bin/script.pl
/lib/Module.pm
```

or if the script is in the root directory of the project:

```
script.pl
/lib/Module.pm
```

Unlike the other solutions, if there is no `lib` directory, this won't add the path to a not-existing directory to `@INC`.


## Conclusion

If you can install CPAN modules, and I really hope for your that you can, I'd recommend `Path::Tiny`, `rlib`, or `FindBin::libs`.


## Comments

Curious if this would be a ok to use to make sure your scipt finds your lib dir.

use lib "../lib";

Seems pretty simple. Is there a reason why you wouldn't use this?

---

That's relative to the current working directory and not to where the script is. That is, it is relative to where *you* are when you run the script.

<hr>

When I run FindBin in taint mode (-T), it give "Insecure dependency in require ..." error.
Here's a post related to this issue. I am not sure if I still be able to use FindBin for this reason.

https://www.perlmonks.org/?node_id=41213

<hr>

Good article that rounds up all the weird and wonderful solutions to this obvious and common problem. It looks like FindBin is the simplest solution (doesn't require any thinking or programming to implement). Perl is a great language but it shoots itself in the foot by not thinking about these simple use-cases; would the heavens fall if Perl just, by default, included the script-dir in @INC?


