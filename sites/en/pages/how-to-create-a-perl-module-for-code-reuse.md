---
title: "How to create a Perl Module for code reuse?"
timestamp: 2013-02-10T09:31:56
tags:
  - package
  - use
  - Exporter
  - import
  - @INC
  - @EXPORT_OK
  - $0
  - dirname
  - abs_path
  - Cwd
  - File::Basename
  - lib
  - module
  - 1;
published: true
books:
  - advanced
author: szabgab
---


You may be creating more and more scripts for your systems, which need to use the same functions.

You already mastered the ancient art of copy-paste, but you are not satisfied with the result.

You probably know lots of Perl modules that allow you to use their functions and you also want to create one.

However, you don't know how to create such a module.


## The module

```perl
package My::Math;
use strict;
use warnings;

use Exporter qw(import);

our @EXPORT_OK = qw(add multiply);

sub add {
  my ($x, $y) = @_;
  return $x + $y;
}

sub multiply {
  my ($x, $y) = @_;
  return $x * $y;
}

1;
```

Save this in somedir/lib/My/Math.pm  (or somedir\lib\My\Math.pm on Windows).

## The script

```perl
#!/usr/bin/perl
use strict;
use warnings;

use My::Math qw(add);

print add(19, 23);
```

Save this in somedir/bin/app.pl (or somedir\bin\app.pl on Windows).

Now run <b>perl somedir/bin/app.pl</b>. (or <b>perl somedir\bin\app.pl</b> on Windows).

It is going to print an error like this:

```
Can't locate My/Math.pm in @INC (@INC contains:
...
...
...
BEGIN failed--compilation aborted at somedir/bin/app.pl line 9.
```

## What is the problem?

In the script we loaded the module with the `use` keyword.
Specifically with the `use My::Math qw(add);` line.
This searches the directories listed in the built-in `@INC` variable looking for a
subdirectory called <b>My</b> and in that subdirectory for a file called <b>Math.pm</b>.

The problem is that your .pm file is not in any of the standard directories
of perl: it is not in any of the directories listed in @INC.

You could either move your module, or you could change @INC.

The former can be problematic, especially on systems where there is a strong separation
between the system administrator and the user. For example on Unix and Linux system
only the user "root" (the administrator) has write access to these directories.
So in general it is easier and more correct to change @INC.

## Change @INC from the command line

Before we try to load the module, we have to make sure the directory of the module is in the @INC array.

Try this:

<b>perl -Isomedir/lib/ somedir/bin/app.pl</b>.

This will print the answer: 42.

In this case, the `-I` flag of perl helped us add a directory path to @INC.



## Change @INC from inside the script

Because we know that the "My" directory that holds our module is in a fixed place
<b>relative</b> to the script, we have another possibility for changing the script:

```perl
#!/usr/bin/perl
use strict;
use warnings;

use File::Basename qw(dirname);
use Cwd  qw(abs_path);
use lib dirname(dirname abs_path $0) . '/lib';

use My::Math qw(add);

print add(19, 23);
```

and run it again with this command:

<b>perl somedir/bin/app.pl</b>.

Now it works.

Let's explain the change:

## How to change @INC to point to a relative directory

This line:
`use lib dirname(dirname abs_path $0) . '/lib';`
adds the relative lib directory to the beginning of `@INC`.

`$0` holds the name of the current script.
`abs_path()` of `Cwd` returns the absolute path to the script.

Given a path to a file or to a directory the call to
`dirname()` of `File::Basename` returns the directory part,
except of the last part.

In our case $0 contains app.pl

abs_path($0) returns  .../somedir/bin/app.pl

dirname(abs_path $0)   returns  .../somedir/bin

dirname( dirname abs_path $0)   returns  .../somedir

That's the root directory of our project.

dirname( dirname abs_path $0) . '/lib'   then points to  .../somedir/lib

So what we have there is basically

`use lib '.../somedir/lib';`

but without hard-coding the actual location of the whole tree.

The whole task of this call is to add the '.../somedir/lib' to be the first element of @INC.

Once that's done, the subsequent call to  `use My::Math qw(add);` will find the
'My' directory in '.../somedir/lib' and the Math.pm in '.../somedir/lib/My'.


The advantage of this solution is that the user of the script does not have to remember
to put the -I... on the command line.

There are other
[ways to change @INC](/how-to-change-inc-to-find-perl-modules-in-non-standard-locations)
for you use in other situations.


## Explaining use

So as I wrote earlier, the `use` call will look for the My directory and the Math.pm file in it.

The first one it finds will be loaded into memory and the `import`
function of My::Math will be called with the parameters after the name of
the module. In our case `import( qw(add) )` which is just the same
as calling `import( 'add' )`.

## The explanation of the script

There is not much left to explain in the script. After the `use` statement
is done calling the `import` function, we can just call the newly imported
<b>add</b> function of the My::Math module. Just as if I declared the function in
the same script.

What is more interesting is to see the parts of the module.


## The explanation of the module

A module in Perl is a namespace in the file corresponding to that namespace.
The `package` keyword creates the namespace. A module name My::Math
maps to the file My/Math.pm. A module name A::B::C maps to the file A/B/C.pm
somewhere in the directories listed in @INC.

As you recall, the `use My::Math qw(add);` statement in the script will load
the module and then call the `import` function. Most people don't
want to implement their own import function, so they load the `Exporter`
module and import the 'import' function.

Yes, it is a bit confusing. The important thing to remember is that Exporter gives you the import.

That import function will look at the `@EXPORT_OK` array in your module
and arrange for on-demand importing of the functions listed in this array.

OK, maybe I need to clarify:
The module "exports" functions and the script "imports" them.


The last thing I need to mention is the `1;` at the end of the module.
Basically the use statement is executing the module and it needs to see some kind
of a true statement there. It could be anything. Some people put there `42;`,
others, the really funny ones put `"FALSE"` there. After all every string
with letters in it is [considered to be true in Perl](/boolean-values-in-perl).
That confuses about everyone. There are even people who put quotes from poems there.

"Famous last words."

That's actually nice, but might still confuse some people at first.

There are also two functions in the module. We decided to export both of them,
but the user (the author of the script) wanted to import only one of the subroutines.


## Conclusion

Aside from a few lines that I explained above, it is quite simple to create a Perl module.
Of course there are other things you might want to learn about modules that will
appear in other articles, but there is nothing stopping you now from moving some common
functions into a module.

Maybe one more advice on how to call your module:

## Naming of modules

It is highly recommended to use capital letter as the first letter of every part in the
module name and lower case for the rest of the letters.
It is also recommended to use a namespace several levels deep.

If you work in a company called Abc, I'd recommend preceding all the modules with the Abc::
namespace. If within the company the project is called Xyz, then all its modules should be in
Abc::Xyz::.

So if you have a module dealing with configuration you might call the package
Abc::Xyz::Config which indicates the file   .../projectdir/lib/Abc/Xyz/Config.pm

Please avoid calling it just Config.pm. That will confuse both Perl (that comes with its own Config.pm)
and you.


