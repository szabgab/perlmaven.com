---
title: "The 19 most important file-system tools in Perl 5"
timestamp: 2012-07-19T12:45:56
tags:
  - cwd
  - tempdir
  - catfile
  - catdir
  - dirname
  - FindBin
  - $Bin
  - File::Spec
  - File::Basename
  - File::Temp
  - Cwd
published: true
author: szabgab
---



When writing Perl scripts that need to deal with the file-system, I often need to load a lot of modules.
Many of the functions I need are scattered around in separate modules. Some are built-in functions of perl,
others are in standard modules coming with perl, yet others need to be installed from CPAN.

Let's go over the 19 most used tools in the kit.


## Current path

Often I need to know what is the current directory I am in. The **Cwd** module has a
function with the same name, but with all lowercase letters **cwd** that will return
the **current working directory**.

<img src="/img/Hdd_icon.svg" style="float: right" />

```perl
use strict;
use warnings;

use Cwd qw(cwd);

print cwd, "\n";
```


## Temporary directory

Often I need to create a bunch of temporary files and I'd like to make
sure they are automatically removed when the script finishes. The easiest way is to create
a temporary directory using the **tempdir** function from **File::Temp** with the CLEANUP
option being turned on.


```perl
use strict;
use warnings;
use autodie;

use File::Temp qw(tempdir);

my $dir = tempdir( CLEANUP => 1 );

print "$dir\n";

open my $fh, '>', "$dir/some_file.txt";
print $fh "text";
close $fh;
```


## Operating System independent path

While the above code will work on both Linux and Windows, people are used to see
back-slashes separating parts of a path on Windows. Besides, this won't work on VMS.
I think. That's where the **catfile** function of **File::Spec::Functions**
comes into play:

```perl
use strict;
use warnings;

use File::Spec::Functions qw(catfile);

use File::Temp qw(tempdir);

my $dir = tempdir( CLEANUP => 1 );

print "$dir\n";
print catfile($dir, 'some_file.txt'), "\n";
```

Try this code. You'll see the name of the temporary directory printed
and the file attached to the end.

## Changing directory

There often cases when it is easier to first change the working directory to
the temporary directory and work there. It can happen a lot
when writing tests but in other cases too. For this we can use the built in
**chdir** function.


```perl
use strict;
use warnings;
use autodie;

use File::Temp qw(tempdir);
use Cwd;

my $dir = tempdir( CLEANUP => 1 );
print cwd, "\n";
chdir $dir;
print cwd, "\n";

open my $fh, '>', 'temp.txt';
print $fh, 'text';
close $fh;
```

That could work well but when File::Temp will try to remove the directory,
we are still "in it" as we have changed the working directory to it.

For example I got the following error message:

```
cannot remove path when cwd is /tmp/P3DZP_rmqg for /tmp/P3DZP_rmqg:
```

In order to avoid that I usually save the path returned by **cwd** before
I change the directory and at the end I call **chdir** again:


```perl
my $original = cwd;

...

chdir $original;
```

There is still a slight problem with this though. What happens if I have to call
**exit()** in the middle of the script or if something throws an exception
that terminates the script before it reaches the **chdir $original**.

Perl has a solution for us, wrapping the last chdir in an **END** block.
This will ensure, that the code is executed no matter when and how we exit
the script.

```perl
my $original = cwd;

...

END {
    chdir $original;
}
```


## Relative path

When writing a project that has multiple files (e.g. one ore more scripts, some modules,
maybe some templates) and I don't want to "install" them, the best directory layout
is to make sure everything is in a fixed place **relative** to the scripts.

So usually I have a project directory in which there is a subdirectory for scripts,
one for modules (lib) , one for templates etc.:

```
project/
     scripts/
     lib/
     templates/
```

How can I make sure the scripts will find the templates? For this I have several solutions:


```perl
use strict;
use warnings;
use autodie;

use FindBin qw($Bin);
use File::Basename qw(dirname);
use File::Spec::Functions qw(catdir);

print $Bin, "\n";                                # /home/foobar/Rocket-Launcher/scripts
print dirname($Bin), "\n";                       # /home/foobar/Rocket-Launcher
print catdir(dirname($Bin), 'templates'), "\n";  # /home/foobar/Rocket-Launcher/templates
```

The **$bin** variable exported by the **FindBin** module will contain the path
to the directory of the current script. In our case that will be a path to the
project/scripts/ directory.

The **dirname** function of **File::Basename** takes a path and returns the same path
removing the last part.

The last line is just the **catdir** function from **File::Spec::Functions**, which
is basically the same as the catfile we saw earlier.

Instead of printing to the screen you would of course use the return value of catdir to specify
the templates.

## Loading modules from a relative path

Almost the same applies to finding and loading the modules that are located
in the lib/ directory of the project. For this we will combine the previous code
with the **lib** pragma. That will change the content of the **@INC** variable
adding the relative path to the beginning of the array.

```perl
use strict;
use warnings;
use autodie;

use FindBin qw($Bin);
use File::Basename qw(dirname);
use File::Spec::Functions qw(catdir);

use lib catdir(dirname($Bin), 'lib');

use Rocket::Launcher;
```

Of course I assume we already have a file called lib/Rocket/Launcher.pm


## Where is the rest?

There is more to this, but I think it is enough as the first part of this series.
If you want to make sure you don't miss the others, [register to the newsletter](/register). It's free.



[Image source](http://commons.wikimedia.org/wiki/File:Hdd_icon.svg)

