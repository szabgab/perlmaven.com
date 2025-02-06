---
title: "How to capture and save warnings in Perl"
timestamp: 2013-05-07T10:30:01
tags:
  - warnings
  - state
  - "__WARN__"
  - "%SIG"
  - "$SIG{}"
  - local
published: true
books:
  - advanced
author: szabgab
---


On one hand it is recommended to have warnings turned on in every Perl script and module,
on the other hand you don't want your customers to see warnings from Perl.

On one hand you want to <b>use warnings</b> at the beginning of the code and have your safety
net

On the other hand, usually  showing up on their screen.
In most cases they won't know what to do with them. If you are lucky those would just frighten them.
If you are unlucky they'd try to fix them... (and I am not thinking about other Perl programmers now.)

On the third hand (is this an octopus or what?) you would like to save the warnings for later analysis.


Furthermore, there are lots of Perl scripts and applications in various places that neither `use warnings`
nor have `-w` on the sh-bang line. Adding `use warnings` will likely generate lots of warnings.

The long term solution is, of course, to eliminate all the warnings but
what do you do in the short term?

Even in the long term, just as you cannot make totally bug-free code, you cannot ensure
that your application will never print a warning.

Or can you?

<b>You can catch the warnings before they are printed to the screen.</b>

## Signals

Perl has a built-in hash called `%SIG`, in which the keys are the names of
the signals available in you operating system. The values are subroutines
(more specifically references to subroutines), that will be called when
the specific signal arrives.

In addition to the standard signals of your operating system Perl added
two internal "signals". One of them is called `__WARN__` and is triggered
every time some code calls the `warn()` function.
The other one is called `__DIE__` and it is triggered when `die()`
is called.

In this article we are going to see how this works for warnings.

## Anonymous subroutines

`sub { }` is an anonymous subroutine, that is, a subroutine that does not have a name
but it has a body. (In this example even the body, the block, is empty but I hope you
get the point.)

## Capture warnings - do nothing

If you added code like this:

```perl
  local $SIG{__WARN__} = sub {
     # here we get the warning
  };
```

You effectively said that every time there is a waning anywhere in the code - don't do anything.
Basically you hide all the warnings.

## Capture warnings - and turn them into exceptions

You could also write:

```perl
  local $SIG{__WARN__} = sub {
    die;
  };
```

Which would call die() whenever a warning happened.
Which means you turn every warning into an exception.

If you also wanted to keep the warning message in that exception you could write:

```perl
  local $SIG{__WARN__} = sub {
    my $message = shift;
    die $message;
  };
```

the actual warning message is passed as the first (and only) parameter to the
anonymous function.

## Capture warnings - and log them

You probably want something in the middle:

Make the warnings less noisy but keep them for later inspection:

```perl
  local $SIG{__WARN__} = sub {
    my $message = shift;
    logger($message);
  };
```

Where we assume that logger() is your implementation of a, well logger.

## Logging

Hopefully your application already has a logging mechanism. If not, this might be a good
reason to add one. Even if you cannot add one, you might be able to use the built-in
logging mechanism of your operating system. That means syslog on Linux and
Event Logger on MS Windows. I am sure other
OS-es have their own built-in logging mechanism too.

In our example we use a simple home made logger() function just to represent
the idea.

## Full example capturing and logging warnings

```perl
  #!/usr/bin/perl
  use strict;
  use warnings;

  local $SIG{__WARN__} = sub {
    my $message = shift;
    logger('warning', $message);
  };

  my $counter;
  count();
  print "$counter\n";
  sub count {
    $counter = $counter + 42;
  }


  sub logger {
    my ($level, $msg) = @_;
    if (open my $out, '>>', 'log.txt') {
        chomp $msg;
        print $out "$level - $msg\n";
    }
  }
```

The above code will add to the log.txt file the following line:

```perl
  Use of uninitialized value in addition (+) at code_with_warnings.pl line 14.
```

The `$counter` variable and the `count()` subroutine are just part of a simple
example that will generate a warning.


## Warning in the warn handle

One lucky aspect of __WARN__ is that when the code in the __WARN__ handle
is executed it is automatically disabled. So warnings in a warn handle
won't cause an infinite loop.

You can read the details of __WARN__ in perldoc perlvar.

## Avoid multiple warnings

There is a concern of having the same warning printed very often filling
the log-file with a lot of repeated lines. We can easily reduce the
number of copies of the same warning by a simple use of a cache-like feature.

```perl
  #!/usr/bin/perl
  use strict;
  use warnings;


  my %WARNS;
  local $SIG{__WARN__} = sub {
      my $message = shift;
      return if $WARNS{$message}++;
      logger('warning', $message);
  };

  my $counter;
  count();
  print "$counter\n";
  $counter = undef;
  count();

  sub count {
    $counter = $counter + 42;
  }

  sub logger {
    my ($level, $msg) = @_;
    if (open my $out, '>>', 'log.txt') {
        chomp $msg;
        print $out "$level - $msg\n";
    }
  }
```

As you can see, we reset the `$counter` variable to `undef`
and called the `count()` function again to generate the same warning
again.

We also replaced the subroutine of the `__WARN__` with a slightly more
complex version:

```perl
  my %WARNS;
  local $SIG{__WARN__} = sub {
      my $message = shift;
      return if $WARNS{$message}++;
      logger('warning', $message);
  };
```

Before calling the logger we check if the current string is in the `%WARNS` hash.
If it isn't, we add it and then call logger(). If it was already there, we just call return
and don't log the event a second time.

You might recall, the same idea was used when we wanted
to have [unique values in an array](/unique-values-in-an-array-in-perl).

## What is this local?

In all the examples you saw, I used the `local` function to
localize the effect. Strictly speaking we did not need that in these
examples as we were assuming the above code would be the first thing
in your main script. In that case it does not matter as you are still
in a global scope.

Yet, better to get used to it. (thanks to Peter Rabbitson for reminding me)

The `local` is important to limit the effect of our change if you are
using this code within a module. Especially if you distribute it.
Without the localization the effect would be felt in all the application.
The `local` limits it to the enclosing block.

## Avoiding the global %WARNS hash

If you are using Perl 5.10 or newer you can improve that code and eliminate the
global %WARNS. In order for that to work you have to write `use v5.10;`
at the beginning of your script and then you can use the `state` keyword
inside the anonymous subroutine to declare the variable.

```perl
  #!/usr/bin/perl
  use strict;
  use warnings;

  use v5.10;

  local $SIG{__WARN__} = sub {
      state %WARNS;
      my $message = shift;
      return if $WARNS{$message}++;
      logger('warning', $message);
  };
```


You can read more details about the [state keyword](/what-is-new-in-perl-5.10--say-defined-or-state)
of Perl.

(Thanks to Joel Berger for reminding me of `state`).


## Comments

Gabor, many thanks for another great tutorial. I've been looking for something conclusive on Perl error handling and this is perfect.

<hr>

How do you report invalid calls to the logger so that you can find them? I can't for the life of me figure out how to save the error in the signal handler and carp after it returns.

UPDATE: For anyone having the same problem, I figured it out. It's necessary to restore the default WARN handler before calling carp. It apparently calls warn, and the signal is caught again. This works:

my $fh = shift;
# Catch warnings from printf
my $error = '';
local $SIG{__WARN__} = sub { $error = $_[0] };
printf( $fh $format, @_ );
# Restore defalt WARN handler so carp doesn't get caught! 
$SIG{__WARN__} = 'DEFAULT';
# Report any printf warnings from caller's perspective
carp "$error" if $error;


