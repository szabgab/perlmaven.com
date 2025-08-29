---
title: "Getting started with Net::Server - building an echo server"
timestamp: 2015-04-01T08:10:01
tags:
  - files
published: true
books:
  - net_server
author: szabgab
---


In this article you will learn the basics on building a server using [Net::Server](https://metacpan.org/pod/Net::Server).

Why would you want to use [Net::Server](https://metacpan.org/pod/Net::Server)? Just visit that page on MetaCPAN and click on
the [Reverse dependencies](https://metacpan.org/requires/distribution/Net-Server?sort=[[2,1]]) list on the right hand side.
These are the modules that depend on Net::Server. I could just point out [Starman](https://metacpan.org/release/Starman)
which is probably the best stand-alone PSGI server on the market, but there are tens of other modules and applications depending
on Net::Server. It can provide a good foundation for you too.


## Installing Net::Server

Start by installing [Net::Server](https://metacpan.org/pod/Net::Server).
I'll have a detailed article or two on installing any CPAN module, though in general you just type `cpan Net::Server`
or `cpanm Net::Server`.

## Skeleton

Before getting into the more complex examples, let's see the skeleton of the most basic server.

This code goes in the `bin/skeleton.pl`

```perl
#!/usr/bin/perl
use strict;
use warnings;

use FindBin;
use lib "$FindBin::Bin/../lib";
use SkeletonServer;

SkeletonServer->run(port => 8000);
```

First we add the `lib` directory to `@INC`.
There are plenty of [other, nicer ways](/how-to-add-a-relative-directory-to-inc) to do this, but using
`FindBin` is simple.

Then we load the server and run it, opening it on port 8000.

This code goes into the `lib/SkeletonServer.pm` file.

```perl
package SkeletonServer;
use warnings;
use strict;

use base 'Net::Server';

sub process_request {
    # do your stuff
}

1;
```

It subclasses the `Net::Server`. The only thing it needs to implement is the `process_request` method.
Once that's done we are ready. We can launch the server by running:

`perl bin/skeleton_server.pl`

It will print something like this on the console:

```
2013/08/06-12:37:08 SkeletonServer (type Net::Server) starting! pid(2685)
Resolved [*]:8000 to [0.0.0.0]:8000, IPv4
Binding to TCP port 8000 on host 0.0.0.0 with IPv4
Group Not Defined.  Defaulting to EGID '1000 4 20 24 46 104 115 120 1000'
User Not Defined.  Defaulting to EUID '1000'
```

That's it, you have the skeleton running. You can now stop it by pressing Ctrl-C.


## Simple Echo Server


We have a new module called `lib/SimpleEchoServer.pm` with the following content:

```perl
package SimpleEchoServer;
use warnings;
use strict;

use base 'Net::Server';
my $EOL   = "\015\012";

sub process_request {
    print "Welcome to the Echo server, please type in some text and press enter. Say 'bye' if you want to leave$EOL";

    while( my $line = <STDIN> ) {
        $line =~ s/\r?\n$//;
        print qq(You said "$line"$EOL);
        last if $line eq "bye";
    }
}

1;
```

Let's go over this code. Basically every time a client connects to this server, the server will
bind the remote connection to the `process_request` method as if that was just a simple script:

Anything printed to the Standard Output `STDOUT` from this function will arrive
to the client on the other side of the socket.

Anything the client sends to the server, will arrive to the Standard Input `STDIN` of
this server. So you write the `process_request` method just as if you were writing a
command line script. How much easier can this get?

OK, there are two difference.

First, instead of using `chomp` to get rid of the trailing newlines we use a regex.
This is because the actual meaning of `\n` depends on the operating system (Windows vs Unix/Linux)
and we can't be fully sure which kind of newline was sent from the client. So we try to get rid of
all the carriage return `CR` and line feed `LF` characters.
(See the article about [text files](/what-is-a-text-file) for a deeper, but still not comprehensive
explanation.)

Second, instead of printing newline using `\n` we use this strange
variable `$EOL` that contains `\015\012`. That's just a carriage return
(decimal 10 octal 015) and a line feed (decimal 10 octal 012). The reason we send this
is because most Internet protocols use this as a newlines.

See the quote from [Wikipedia](http://en.wikipedia.org/wiki/Newline)

<i>
Most textual Internet protocols (including HTTP, SMTP, FTP, IRC and many others) mandate the use of ASCII CR+LF
('\r\n', 0x0D 0x0A) on the protocol level, but recommend that tolerant applications recognize lone LF ('\n', 0x0A) as well.
In practice, there are many applications that erroneously use the C newline character '\n' instead.
</i>

In a nutshell we need to be **flexible in what we accept and strict in what we send**.

BTW Don't ask me why is it written in octal and not hexa in this case. I think it is just
because that's what was in the documentation of `Net::Server`.


`bin/simple_echo_server.pl`:

```perl
#!/usr/bin/perl
use strict;
use warnings;

use FindBin;
use lib "$FindBin::Bin/../lib";
use SimpleEchoServer;

SimpleEchoServer->run(port => 8000);
```

The only change in the script is that it is now called `bin/simple_echo_server.pl`
for more clarity, and the name of the module we use and run is `SimpleEchoServer`
instead of `SkeletonServer`.

Let's run the script now by typing `perl bin/simple_echo_server.pl` in the console.
We get the following output:

```
2013/08/06-12:41:07 SimpleEchoServer (type Net::Server) starting! pid(2764)
Resolved [*]:8000 to [0.0.0.0]:8000, IPv4
Binding to TCP port 8000 on host 0.0.0.0 with IPv4
Group Not Defined.  Defaulting to EGID '1000 4 20 24 46 104 115 120 1000'
User Not Defined.  Defaulting to EUID '1000'
```

Now let's switch to another console and type:
`telnet localhost 8000`
This will connect to the server on the same machine and print the following:

```
Trying ::1...
Trying 127.0.0.1...
Connected to localhost.
Escape character is '^]'.
Welcome to the Echo server, please type in some text and press enter. Say 'bye' if you want to leave
```

The first 4 lines were printed by the `telnet` client, the 5th line was already sent by our server.

Now we can type in text and get responses:

```
hello
You said "hello"
world
You said "world"
```

When we want to quite we just type in **bye**. The server will echo it back, but then the
`while` loop terminates because of this line of code: `last if $line eq "bye";`:

```
bye
You said "bye"
Connection closed by foreign host.
```

The last line was already printed by the telnet client.

Meanwhile in the server console nothing happened. The server still runs. We could now
open another telnet session to the same server.

Instead of that we just press Ctrl-C in the window where the server runs and we will see the following printed,
and get our regular prompt back:

```
2013/08/06-12:41:39 Server closing!
... $
```

## Multiple concurrent connections

Let's see what happens if we try to connect to the same server with more than one client at the same time.

We launch the server in one terminal by typing `perl bin/simple_echo_server.pl`.
In another terminal we type `telnet localhost 8000` and we see what we saw earlier. We can type some text and
get response:

```
Trying ::1...
Trying 127.0.0.1...
Connected to localhost.
Escape character is '^]'.
Welcome to the Echo server, please type in some text and press enter. Say 'bye' if you want to leave
hello
You said "hello"
```

We open a 3rd terminal and type `telnet localhost 8000` there too. We see this:

```
Trying ::1...
Trying 127.0.0.1...
Connected to localhost.
Escape character is '^]'.
```

Please note, we don't see the welcome text that we saw in the other client.
We try to type in `hi` but no response.

Switching back to terminal 2, we can type again there and get response:

```
world
You said "world"
```

In terminal 3 still nothing happened.

Then we say goodbye in terminal 2 that will echo and quit as we expect:

```
bye
You said "bye"
Connection closed by foreign host.
... $
```

If we now switch to terminal 3 we see the following:

```
Trying ::1...
Trying 127.0.0.1...
Connected to localhost.
Escape character is '^]'.
hi
Welcome to the Echo server, please type in some text and press enter. Say 'bye' if you want to leave
You said "hi"
```

The first `hi`, after the `Escape ...` is what we typed. Once we quite the other client
this started to work, printed out the welcome message and handled the text we typed in.
We can now keep typing here and say "bye" once we want to close the connection.

What we saw is that the server could not handle more than one clients at a time. This might be OK
during development, and initial testing, but in most applications we would want to have a server
that can handle multiple connections.

`Net::Server` solves this in a beautiful way. We just need to edit our server code.
Instead of inheriting from `Net::Server` we will need to inherit from one of the other
servers. We just need to replace `use base 'Net::Server';` by `use base 'Net::Server::PreFork';`.

If we launch the server now, and try to connect using two telnet clients at the same time, it will just work.

## Conclusion

Writing a simple echo server was very easy and it can already handle multiple connections at the same time.

Let's leave it as it is now, and get back building more complex servers in another article.

