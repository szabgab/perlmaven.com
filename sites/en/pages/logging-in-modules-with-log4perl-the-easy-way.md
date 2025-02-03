---
title: "Logging in modules with Log4perl the easy way"
timestamp: 2016-03-17T20:59:01
tags:
  - Log::Log4perl
  - Log::Log4perl::Level
types:
  - screencast
published: true
author: szabgab
---


In the previous article we saw how we can [get started logging with Log::Log4perl](/logging-with-log4perl-the-easy-way) in a script.
This time we'll see the example extended to a module.


{% youtube id="CmmPRLafJq4" file="logging-in-modules-with-log4perl-the-easy-way" %}

In order to show how this works, we have two files:

```
root/
   log.pl
   My/EasyApp.pm
```


The `My/EasyApp.pm` file has the following content: The `new` constructor is basic here
and the `run` method just fetches the logger object and calls its method. The responsibility
to set up the logging lies with the script launching it. I think this is a better approach then letting the module initialize the logger.
After all, modules won't run on their own.

```perl
package My::EasyApp;
use strict;
use warnings;

use Log::Log4perl ();

sub new {
    my $self = bless {}, shift;
    return $self;
}

sub run {
    my $logger = Log::Log4perl->get_logger();
    $logger->fatal("FATAL from EasyApp");
    $logger->debug("DEBUG from EasyApp");
}

1;
```

Someone unaware of the logging code in the module will try to use it as follows:

```perl
use strict;
use warnings;
use 5.010;

use My::EasyApp;
my $app = My::EasyApp->new;
$app->run;
```

When running `perl log.pl` the script will emit a warning:

```
Log4perl: Seems like no initialization happened. Forgot to call init()?
```

This is of course disturbing as the module should be fully usable even without logging turned on.

## Initialize the logger in the module - on condition

We can change the module to initialize the logger if it has not been initialized by the time the constructor is
called. In this case we initialize the logger but turn any logging OFF:

```perl
use Log::Log4perl::Level ();
sub new {
    my $self = bless {}, shift;

    if (not Log::Log4perl->initialized()) {
        Log::Log4perl->easy_init( Log::Log4perl::Level::to_priority( 'OFF' ) );
    }

    return $self;
}
```

Running the script again will now work silently as expected.


## Turning on logging in the script


```perl
use strict;
use warnings;
use 5.010;

use My::EasyApp;
use Log::Log4perl ();
use Log::Log4perl::Level ();

Log::Log4perl->easy_init(Log::Log4perl::Level::to_priority( 'WARN' ));

my $app = My::EasyApp->new;
$app->run;
```

The output:

```
2014/08/25 10:34:29 FATAL from EasyApp
```

## Less typing in the module

The one thing that sometimes disturbs me, is that in every method in the module I'll have to call

```perl
my $logger = Log::Log4perl->get_logger();
```

in order to have the logger object. There is a way to reduce the typing, we can import the `get_logger`
method from [Log::Log4perl](https://metacpan.org/pod/Log::Log4perl).

We can then write:

```perl
use Log::Log4perl qw(get_logger);

sub run {
    my $logger = get_logger();
    $logger->fatal("FATAL from EasyApp");
    $logger->debug("DEBUG from EasyApp");
}
```

or even the following, if we don't min the extra calls:

```perl
sub run {
    get_logger->fatal("FATAL from EasyApp");
    get_logger->debug("DEBUG from EasyApp");
}
```


## The full code of the module

Just to make it easier to copy-paste, this code uses both approaches at the same time in three separate methods.

```perl
package My::EasyApp;
use strict;
use warnings;

use Log::Log4perl qw(get_logger);
use Log::Log4perl::Level ();

sub new {
    my $self = bless {}, shift;
    if (not Log::Log4perl->initialized()) {
        Log::Log4perl->easy_init(Log::Log4perl::Level::to_priority( 'OFF' ));
    }
    return $self;
}

sub run {
    my ($self) = @_;
    $self->run1;
    $self->run2;
    $self->run3;
}

sub run1 {
    my $logger = Log::Log4perl->get_logger();
    $logger->fatal("FATAL from EasyApp using \$logger");
}

sub run2 {
    my $logger = get_logger();
    $logger->fatal("FATAL from EasyApp using \$logger with get_logger()");
}

sub run3 {
    get_logger->fatal("FATAL from EasyApp using get_logger");
    get_logger->debug("DEBUG from EasyApp");
}

1;
```

running the script will result in

```
2014/08/25 10:51:07 FATAL from EasyApp using $logger
2014/08/25 10:51:07 FATAL from EasyApp using $logger with get_logger()
2014/08/25 10:51:07 FATAL from EasyApp using get_logger
```

## Conclusion

You can start adding logging code to your module and make sure it is off when the user of your module does not care.


