---
title: "Echo server with logging and timeout"
timestamp: 2015-04-29T09:00:01
tags:
  - Net::Telnet
  - ALRM
  - "%SIG"
  - alarm
  - eval
  - "$@"
published: true
books:
  - net_server
author: szabgab
---


In this article we continue to improve the Echo server we
[started earlier](/getting-started-with-net-server).
Two additions:
* Logging to the server
* Timeout for the client


## Logging on the server

This is the simple part. Inside the `process_request` everything we print to the
Standard Output (`STDOUT`) will go to the client, and everything we print to
the Standard Error (`STDERR`) will go to the console.
So all we have to to is to `print STDERR "some text\n";` and it will show up
on the console.

You can see it in the next example as well.

## Timeout handled by the server

The following code is from the `lib/EchoServer.pm` file,
which is part of the same directory structure we had
[at the beginning.](/getting-started-with-net-server)


```perl
package EchoServer;
use warnings;
use strict;

use base 'Net::Server';

my $timeout = 5; # give the user 5 seconds to type a line
my $EOL   = "\015\012";

sub process_request {
    print "Welcome to the Echo server, please type in some text and press enter. Say 'bye' if you want to leave$EOL";
    print STDERR "New user connected\n";
    eval {
        local $SIG{ALRM} = sub { die "Timeout\n" };

        alarm($timeout);
        while( my $line = <STDIN> ) {
            alarm($timeout);
            $line =~ s/\r?\n$//;
            print qq(You said "$line"$EOL);
            last if $line eq "bye";
        }
        alarm(0);
    };
    my $err = $@;
    alarm(0);
    if ( $err ) {
        chomp $err;
        if ( $err eq 'Timeout' ) {
            print "Timed Out. Disconnecting...$EOL";
            print STDERR "Client timed Out.\n";
        } else {
            print "Unknown internal error. Disconnecting...$EOL";
            print STDERR "Unknown internal error: $err\n";
        }
    } else {
        print STDERR "User said bye\n";
    }
    return;
}

1;
```

The script that runs it located in `bin/echo_server.pl`,
is similar to what we had earlier.

```perl
#!/usr/bin/perl
use strict;
use warnings;

use FindBin;
use lib "$FindBin::Bin/../lib";
use EchoServer;

EchoServer->run(port => 8000);
```

We run the server by typing `perl bin/echo_server.pl` in one console.
Then we connect to it using `telnet localhost 8000` in another console. This is the client.

Firs it will show the banner:

```
Connected to localhost.
Escape character is '^]'.
Welcome to the Echo server, please type in some text and press enter. Say 'bye' if you want to leave
```

Then we can type in `hello` and the server will reply to us:

```
hello
You said "hello"
```

Then we wait 5 seconds and suddenly we see:

```
Timed Out. Disconnecting...
Connection closed by foreign host.
$
```

The first line was sent by the server. The second line was printed by our telnet client
and then we got the prompt back.

If we switch to the console where we launched the server, we will see this output
and the server is still running.

```
2013/08/08-08:46:01 EchoServer (type Net::Server) starting! pid(14978)
Resolved [*]:8000 to [0.0.0.0]:8000, IPv4
Binding to TCP port 8000 on host 0.0.0.0 with IPv4
Group Not Defined.  Defaulting to EGID '1000 4 20 24 46 104 115 120 1000'
User Not Defined.  Defaulting to EUID '1000'
New user connected
Client timed Out.
```

## How does it work?

The operating system has an alarm clock, just as most of us have at home or in our mobile phone. Except that
in the operating system we usually don't set the alarm clock to a specific hour, but instead we set how many
seconds from now we want the alarm to go off.

Using the `alarm($timeout)` function, basically we ask the operating system to send us an `ALRM-signal`
in `$timeout` seconds which happens to be 5 in our case.
Normally nothing would happen when an ALRM signal arrives but we also configure a signal-handler:
`local $SIG{ALRM} = sub { die "Timeout\n" };` tells perl that when an `ALRM` signal is received
we want out script to throw an exception.

Of course we don't really want our script to `die`, so we use an `eval` block to capture
the exception that might happen within the block.

(We also use `local` to make sure we get the previous behavior of the
ALRM handle after leaving the enclosing block. This is to avoid the
possibility of receiving the ALRM signal just as we left the `eval` block
after receiving input from the client.)

Within the `while-loop` we also immediately set the `alarm` again to extend
the wait period. When we leave the while loop in a normal way - after receiving the string "bye"
from the client, we immediately set the `alarm(0)`. This will turn off our alarm clock.

```perl
    eval {
        local $SIG{ALRM} = sub { die "Timeout\n" };

        alarm($timeout);
        while( my $line = <STDIN> ) {
            alarm($timeout);
            $line =~ s/\r?\n$//;
            print qq(You said "$line"$EOL);
            last if $line eq "bye";
        }
        alarm(0);
    };
```

If you are used to try-catch code for capturing exceptions, the `eval` block
was the `try` part. The `catch` part is in the following part.

## Timeout - catch

The first thing we do here is copy the content of `$@` into our own private variable.
This is useful in general so if we call some code that uses `eval` it won't overwrite
the exception we caught.

Then we turn off the `alarm(0)` again. It does not matter to perl if we call `alarm(0)`
several times, but if we left the `eval` block because of an exception other than the one caused
by the `ALRM` signal then the alarm clock is still on. We don't want any wake-up later on.
So we make sure the alarm clock is turned off.

Then we inspect the`$err` variable. If we left the `eval` block without receiving an exception,
this variable will be [undef](/undef-and-defined-in-perl) and we enter the `else`-block.

Inside the `if`-block we handle both the case when we raised the `Timeout` exception and if
some other exception occurred. (Which is very unlikely in our simple example, but that can happen
in more complex code.)

```perl
    my $err = $@;
    alarm(0);
    if ( $err ) {
        chomp $err;
        if ( $err eq 'Timeout' ) {
            print "Timed Out. Disconnecting...$EOL";
            print STDERR "Client timed Out.\n";
        } else {
            print "Unknown internal error. Disconnecting...$EOL";
            print STDERR "Unknown internal error: $err\n";
        }
    } else {
        print STDERR "User said bye\n";
    }
```

Just one more note: In both cases inside the `if` block we print both to
`STDOUT` that goes back to the client
and to `STDERR` that goes to the console of the server.

