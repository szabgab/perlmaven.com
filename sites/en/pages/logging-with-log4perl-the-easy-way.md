---
title: "Logging with Log4perl the easy way"
timestamp: 2015-09-24T20:15:01
tags:
  - Log::Log4perl
  - Log::Log4perl::Level
types:
  - screencast
published: true
author: szabgab
---


Logging can be very useful for finding problems in a running application. It can be also very useful for people who are not
familiar with an application or a module who want to learn how the code works maybe in order to fix a bug or add a feature.

[Log::Log4perl](https://metacpan.org/pod/Log::Log4perl) is a complex module for logging
with lots of knobs to fiddle with, but there is an easy way to get started using it.


{% youtube id="BVhSPYZjjHg" file="logging-with-log4perl-the-easy-way" %}

## Log in a script

In the most simple case we use it to add logging messages to a script. We need to load the module importing the `:easy` key
that will import 6 functions for the 6 logging levels provided by Log::Log4perl and 6 variables with corresponding names.

```perl
use strict;
use warnings;
use 5.010;

use Log::Log4perl qw(:easy);
Log::Log4perl->easy_init($WARN);

FATAL "This is", " fatal";
ERROR "This is error";
WARN  "This is warn";
INFO  "This is info";
DEBUG "This is debug";
TRACE "This is trace";
```

Running this script will print out:

```
2014/08/24 09:59:37 This is fatal
2014/08/24 09:59:37 This is error
2014/08/24 09:59:37 This is warn
```

In the code we can use any of the 6 methods to send logging messages. These logging functions will accept any number of parameters and will concatenate them as can be seen
in the case of the FATAL call.

Once such calls were added to the script we can use the `easy_init` method to set the minimal level to be actually logged. Because in the above example
we set the minimal log-level to be WARN, only the message that have higher priority (FATAL, ERROR and WARN) will be actually printed.

By default Log::Log4perl will print to the STDERR (Standard error) channel which is by default connected to the screen.

If we set the log level to `FATAL` by writing

```perl
Log::Log4perl->easy_init($FATAL);
```

then the above code will only print only one line.

## Turn off logging

If we don't call the `easy_init` method at all, nothing will be printed.
Alternatively, a probably better approach is to explicitly turn it off using

```perl
Log::Log4perl->easy_init($OFF);
```

## Using methods

Using these functions might be easy, but as the application growth, you might be better of with a more object oriented approach.
In order to use the OOP way, one can fetch the internal logger object using the `get_logger` and then call the appropriate
method names (the lower case version of the levels).

```perl
use strict;
use warnings;
use 5.010;

use Log::Log4perl qw(:easy);
Log::Log4perl->easy_init($WARN);

my $logger = Log::Log4perl->get_logger();
$logger->fatal( "This is", " fatal");
$logger->error( "This is error");
$logger->warn(  "This is warn");
$logger->info(  "This is info");
$logger->debug( "This is debug");
$logger->trace( "This is trace");
```

This still requires importing the `:easy` tag in order to have the variables `$FATAL`, `$ERROR`, `$WARN` to set the minimal level.
In order to avoid importing even those variables we can use the `to_priority` function of [Log::Log4perl::Level](https://metacpan.org/pod/Log::Log4perl::Level).
Normally the variables such as `$WARN` contain a numerical value, but the `to_priority` function can convert the string representation of the level-name
into that numerical value:

```perl
use Log::Log4perl ();
use Log::Log4perl::Level ();

Log::Log4perl->easy_init( Log::Log4perl::Level::to_priority( 'WARN' ) );
```

## Full example

```perl
use strict;
use warnings;
use 5.010;

use Log::Log4perl ();
use Log::Log4perl::Level ();

Log::Log4perl->easy_init(Log::Log4perl::Level::to_priority( 'WARN' ));

my $logger = Log::Log4perl->get_logger();
$logger->fatal( "This is", " fatal");
$logger->error( "This is error");
$logger->warn(  "This is warn");
$logger->info(  "This is info");
$logger->debug( "This is debug");
$logger->trace( "This is trace");
```


## Comments

where does logger log to...I mean there must be a file where all all these logging message is stored.

see https://search.cpan.org/~mschilli/Log-Log4perl-1.49/lib/Log/Log4perl.pm#Initialize_via_a_configuration_file

It's done in a configuration file that you setup and use:

use Log::Log4perl;
Log::Log4perl->init("log.conf");

<hr>

How can we trace back the log file, I mean where exactly these errors will be stored?

<hr>

hey,
the variable $WARN has to be set to Log::Log4perl::Level::to_priority( 'WARN' ) ?

