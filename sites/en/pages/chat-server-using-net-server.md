---
title: "Chat server using Net::Server"
timestamp: 2015-05-09T07:30:01
tags:
  - Net::Server::Multiplex
  - chat server
published: true
books:
  - net_server
author: szabgab
---


In the [previous articles](/net-server) we first used
the [Net::Server](https://metacpan.org/pod/Net::Server) module
directly that could handle only one client at a time.
That was good for development but not very useful in the general case.

Then we switched to using [Net::Server::PreFork](https://metacpan.org/pod/Net::Server::PreFork)
that could handle multiple servers.
The switch was seamless, and it could handle several clients, but that was still not good to develop
a chat server. In this article we'll see how that can be done.


## The Problems

The problem with the previous approach is that for each concurrent client it had a separate process.
This can work well if there are relatively few clients at the same time. Which means either
there are few clients altogether, or each client connection is for a short period of time.

For a chat server this might not be ideal as this would mean the clients have to connect/authenticate/disconnect
frequently. Even for checking if there is some incoming message.

There is another issue though. Each client connects to a separate process on the server. If we want to allow the
clients to communicate via the server (e.g. chat) then the separate server processes - each handling one client -
need to, somehow, communicate with each other.

(BTW you could do a little experiment with the Pre-forking echo server. Change the code in the
last example of the simple [echo server](/getting-started-with-net-server)
so that the server will send back its process id number (in `$$`) to the client
it talks to. Then connect with two or more clients and you will see the numbers are different for each
concurrent client.)

There is another solution though. We could use the
[Net::Server::Multiplex](https://metacpan.org/pod/Net::Server::Multiplex) that will launch
only one server process, but will be able to handle several client connections by setting up asynchronous
communication.

Because the Multiplex server works on callbacks and the methods are not always "live",
we have to write the whole application in a different way. The Multiplex server never
calls the `process_request` method, it has different ways to work. Let's see how:

The following example and explanation is partially based on the samplechat.pl script
available in the [Net-Server distribution](https://metacpan.org/release/Net-Server).

## Getting started with Net::Server::Multiplex

This is the first step in building our chat server. We save this file in `lib/MuxEchoServer.pm`.

In this code we've sub-classed Net::Server::Multiplex.
This code alone would already be ready to accept connections, but would not know how to handle any input.
So we also implement the `mux_input` method. This will be called when there is some input
arriving from the client. If we use `telnet` to connect to this server then every time
we hit the ENTER in the client, it will send the text we typed to the server
and the sever will call the `mux_input` method.
If we use some different client to connect that would send chunks without a newline at the end,
or maybe with several newlines embedded in the string, then this method would be still called.

It needs to be able to handle several input lines at once, and then it needs to `return` quickly.
As there is only one server process, if this method takes a long time to run then the server
cannot handle other clients in the same time and it well be "stuck" for everyone else.
We'll see a demonstration of this.

So, when there is some input that arrived from the client, the `mux_input` method is called
and it is passed 4 variables. The first one is the server instance, we save in `$self`.
The second one is an [IO::Multiplex](https://metacpan.org/pod/IO::Multiplex) object
that actually does the real work. We put it in the `$mux` variable.
The 3rd parameter is the socket opened to the client. Each connected client has its own socket.
In many cases we don't need to use this as the Standard Output (`STDOUT`) is also connected
to the same socket. So we can just `print` without any special parameter and the text
will be sent to the client.
The 4th parameter contains a reference to a string with the input (sent from the client) in it.

Inside the `mux_input` method we dereference the `$in_ref` variable by adding
another `$`-sign at the front: `$$in_ref`.

```perl
package MuxEchoServer;
use warnings;
use strict;

use base 'Net::Server::Multiplex';
my $EOL   = "\015\012";

sub mux_input  {
    my ($self, $mux, $fh, $in_ref) = @_;

    while ($$in_ref =~ s/^(.*?)\r?\n//) {
        next unless $1;
        my $text = $1;
        print "You said  $text$EOL";
        print $fh "You really said $text$EOL";
        if ($text eq 'bye') {
            close(STDOUT);
        }
    }
}

1;
```

The script to launch this is called `bin/mux_echo_server.pl` and looks like this:

```perl
#!/usr/bin/perl
use strict;
use warnings;

use FindBin;
use lib "$FindBin::Bin/../lib";
use MuxEchoServer;

MuxEchoServer->run(port => 8000);
```

We can run the above script `perl bin/mux_echo_server.pl` and in another two windows
we can type `telnet localhost 8000` and then type in text. Both telnet clients
can work at the same time, or more correctly <b>seemingly at the same time</b>.


## Welcome Server

In the next step we add a welcome message. If you'd like to preserver the earlier file then
copy it to be called `lib/MuxWelcomeServer.pm`. Change the `package` to
have `package MuxWelcomeServer;` and add the following code:

The `mux_connection` method is called <b>every time a new client connects to the
server</b>. It receives 3 parameters: The current object in `$self` which will be unique
per connection, the [IO::Multiplex](https://metacpan.org/pod/IO::Multiplex) object
saved in the `$mux` variable and the file-handle (saved in `$fh`)
to the current connection which is again probably not going to be used.

The object contains the IP address of the client in the `$self->{peeraddr}` field.
Some other information about the connection is kept in the `$self->{net_server}{server}`
attribute. For example the port number of the client that connected to our server.

To make it easier to access we copy it to `$self->{peerport}` and then create
a variable `$port` that contains the IP address and the port number of the client.
We do this only to identify the client connection in a slightly more user-friendly way
that the internal memory address of the object.

`print STDERR ...` will print to the console of the server.

`print ...` will send the message to the current client.`

```perl
sub mux_connection {
    my ($self, $mux, $fh) = @_;

    $self->{peerport} = $self->{net_server}{server}{peerport};
    my $peer = "$self->{peeraddr}:$self->{peerport}";
    print STDERR "DEBUG: Client [$peer] just connected...\n";
    print "Welcome, to the server!$EOL";
    print $fh "Welcome again$EOL";
```

Change the script to load the `MuxWelcomeServer`, run the script and then connect
from two different clients. You will see each one welcomes you while on the console
we can see report when each client is connected.

## Goodbye server

When a client disconnects (either by typing "bye" and getting the server to call
`close(STDOUT)` or by pressing `Ctrl-]` and then typing `quit`,
the server will call the `mux_close` method.

The parameters are as usual. The current object, the IO::Multiplex object and the
file handle to the current connection. Except that the last parameter is IMHO
totally useless as this is a file-handle that has already been closed.
So if we try to print to it `print $fh "Goodbye$EOL";`, we'll get a warning:
`print() on closed file-handle GEN1` on the console of the server.

So that line is quite pointless.

There is another issue with this call back. There can be various reasons the
client cannot connect (e.g. at a later point we will see how can the server
reject connections based on IP address). This method will be called in those
cases as well. Even though the `mux_connection` method has never been
called. We should check somehow if it was called. As we set the `peerport`
field in the `mux_connection` method, we can check the existence of
that value and print something to the console of the server when a
client disconnects.

```perl
sub mux_close {
    my ($self, $mux, $fh) = @_;

    if (exists $self->{peerport}) {
        print $fh "Goodbye$EOL"; # pointless call
        my $peer = "$self->{peeraddr}:$self->{peerport}";
        print STDERR "DEBUG: Client [$peer] closed connection!\n";
    }
}
```

## Broadcast server

Let's make another step. Let's add a method that will send a message
to every connected client when a new client connects.
We can rename our module to be `lib/MuxBroadcastServer.pm`,
change the `package` and create an appropriate script called
`bin/mux_broadcast_server.pl`.

The changes in the module are the addition of the `broadcast`
method. It is not a standard method of `Net::Serverbin/mux_broadcast_server.pl`.

The changes in the module are the addition of the `broadcast`
method. It is not a standard method of `Net::Server::Multiplex`,
it is something we made up.

```perl
sub broadcast {
    my ($self, $mux, $msg) = @_;

    foreach my $fh ($mux->handles) {
        print $fh $msg;
    }
}
```

The `$mux->handles` method will return the list of all the currently
connected clients. More specifically the file-handles connected to
those clients. The `broadcast` method just iterates over them and send
a message to each one of them.
We can now add two calls to this method:

Add this to the `mux_connection` method:

```perl
    $self->broadcast($mux, "Please welcome $peer, who just joined us$EOL");
```

the following to the `mux_close` method:

```perl
    $self->broadcast($mux, "Unfortunately $peer left us$EOL");
```

And the following to `mux_input`

```perl
    my $peer = "$self->{peeraddr}:$self->{peerport}";
    $self->broadcast($mux, "Client $peer said: $text$EOL");
```

Now if you launch the server and connect to it from two clients
you will see that when the second client connects, the
first client will receive a message about it.
When either client send a message the other one will receive it,
and when one of them disconnects, the other will be notified.

Unfortunately the `broadcast` method sends the message
to every client, including the one that sent it. In order to avoid
this we make an little change to the broadcast method:

We accept another parameter - the current file-handle in `$my_fh`
and skip it in the `foreach` loop:

```perl
sub broadcast {
    my ($self, $mux, $msg, $my_fh) = @_;

    foreach my $fh ($mux->handles) {
        next if $fh eq $my_fh;
        print $fh $msg;
    }
}
```

We also change each call to the `broadcast` method and pass
the current file-handle as the last parameter.

## The Chat server

After removing the extensive echo-ing and other unnecessary print statements we get the
following code in `lib/MuxChatServer.pm`:

```perl
package MuxChatServer;
use warnings;
use strict;

use base 'Net::Server::Multiplex';
my $EOL   = "\015\012";


sub mux_connection {
    my ($self, $mux, $fh) = @_;

    $self->{peerport} = $self->{net_server}{server}{peerport};
    my $peer = "$self->{peeraddr}:$self->{peerport}";
    print STDERR "DEBUG: Client [$peer] just connected...\n";
    print "Welcome, to the server!$EOL";
    $self->broadcast($mux, "Please welcome $peer, who just joined us$EOL", $fh);
}


sub mux_input  {
    my ($self, $mux, $fh, $in_ref) = @_;

    while ($$in_ref =~ s/^(.*?)\r?\n//) {
        next unless $1;
        my $text = $1;
        #print "You said  $text$EOL";
        my $peer = "$self->{peeraddr}:$self->{peerport}";
        $self->broadcast($mux, "Client $peer said: $text$EOL", $fh);
        if ($text eq 'bye') {
            close(STDOUT);
        }
    }
}

sub broadcast {
    my ($self, $mux, $msg, $my_fh) = @_;

    foreach my $fh ($mux->handles) {
        next if $fh eq $my_fh;
        print $fh $msg;
    }
}

sub mux_close {
    my ($self, $mux, $fh) = @_;

    if (exists $self->{peerport}) {
        my $peer = "$self->{peeraddr}:$self->{peerport}";
        print STDERR "DEBUG: Client [$peer] closed connection!\n";
        $self->broadcast($mux, "Unfortunately $peer left us$EOL", $fh);
    }
}

1;
```

And this is the script that launches it:

```perl
#!/usr/bin/perl
use strict;
use warnings;

use FindBin;
use lib "$FindBin::Bin/../lib";
use MuxChatServer;

MuxChatServer->run(port => 8000);
```

