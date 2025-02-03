---
title: "Testing a simple TCP/IP server using Net::Telnet"
timestamp: 2015-04-23T08:00:01
tags:
  - Net::Telnet
published: true
books:
  - testing
  - net_server
author: szabgab
---


Before we continue to develop our TCP/IP based server using `Net::Server`, let's take a look at how
we can test the server? We are going to use [Test::More](https://metacpan.org/pod/Test::More),
the standard testing system of Perl and [Net::Telnet](https://metacpan.org/pod/Net::Telnet),
that is a telnet client implementation in Perl.


This test will assume a Unix/Linux system, but later we are going to change it to work on Windows as well.

## The test script

The test script saved in the `t/01-simple-echo-server.t` file looks like this:

```perl
use strict;
use warnings;

my $pid = fork();
die 'Could not fork' if not defined $pid;

if (not $pid) {
    close STDERR;
    exec("$^X bin/simple_echo_server.pl");
}

END {
  if ($pid) {
    kill 2, $pid;
    wait;
  }
}

sleep 1;
require Test::More;
import Test::More;
require Net::Telnet;
plan(tests => 7);
my $t = Net::Telnet->new();
ok($t->open(Host => 'localhost', Port => 8000, Timeout => 10), 'connected');

{
    my ($pre, $match) = $t->waitfor('/(?<=if you want to leave)/');
    is($pre, "Welcome to the Echo server, please type in some text and press enter. Say 'bye' if you want to leave", 'banner');
    is($match, '', 'empty');
}

{
    $t->print('hello');
    my ($pre, $match) = $t->waitfor('/You said "hello"/');
    like($pre, qr/^\s*$/, 'just newline');
    is($match, 'You said "hello"', 'reply by the server');
}
{
    $t->print('bye');
    my ($pre, $match) = $t->waitfor('/You said "bye"/');
    like($pre, qr/^\s*$/, 'just newline');
    is($match, 'You said "bye"', 'reply by the server');
}
```

It is placed next to the `lib` and `bin` directories we created for the [Simple echo server](/getting-started-with-net-server).
We can run the test using `prove -l t/01-simple-echo-server.t` and it will print out the following:

```
t/01-simple-echo-server.t .. ok
All tests successful.
Files=1, Tests=7,  1 wallclock secs ( 0.03 usr  0.01 sys +  0.12 cusr  0.01 csys =  0.17 CPU)
Result: PASS
```

(Actually in this case we could leave the `-l` flag out, but I think it is better to have it in our muscle memory.)

If we want a more verbose output we can add a `-v` flag and run:
`prove -lv t/01-simple-echo-server.t` getting the following output:

```
t/01-simple-echo-server.t ..
1..7
ok 1 - connected
ok 2 - banner
ok 3 - empty
ok 4 - just newline
ok 5 - reply by the server
ok 6 - just newline
ok 7 - reply by the server
ok
All tests successful.
Files=1, Tests=7,  1 wallclock secs ( 0.03 usr  0.01 sys +  0.12 cusr  0.01 csys =  0.17 CPU)
Result: PASS
```

The first showed us a summary of the test cases collected by the
[Test::Harness](https://metacpan.org/pod/Test::Harness), the
second one was the raw TAP output.

## Explaining the test script

We need to test a client-server application. For this we are going to launch our server from the
test script in a forked process. This is useful as we then know the process id of the server and
we can shut it down at the end of our test.

We also have to deal with a couple of other issues. If we have Test::More loaded in a script
it will expect to have a "plan" and to have test assertions in it. In our case only the client
is a real test script, the server is not. So we have to make sure we load `Test::More`
only in the parent process, which is going to be the client.
We also have to make sure that none of the output from the server will be mixed in with the output
of our test script or it can confuse the `Test::Harness`.

Let's go over the test script.

## Forking to launch the server

This code [forks](/fork), and the child process runs the server. Because the server will print various
things on the Standard Error channel of its console, first `close STDERR` in the child
process. Then we call `exec` to run the external script. This will make sure the external
script has the same process id as the child process and when the external script exits, the
child process itself exits. For that reason there is no need to call `exit` in the
child process.

```perl
my $pid = fork();
die 'Could not fork' if not defined $pid;

if (not $pid) {
    close STDERR;
    exec("$^X bin/simple_echo_server.pl");
}
```

## Closing the server when the test ends

We want to make sure the server stops working after the test script
finishes, even if the test script died an unnatural death. (e.g. by throwing an exception.)
So we send `kill 2` to the process id of the child process. We do it only if `$pid`
had a value so this block will only run in the parent process.
We wrap our code in and `END` block. This will ensure the code is executed even if
something throws an exception in the test script:

```perl
END {
  if ($pid) {
    kill 2, $pid;
    wait;
  }
}
```

## Loading Test::More late and planning late

Then we sleep a bit, just to let the server launch - this is a bit problematic.
On very slow systems 1 second might not be enough for the server to launch, on fast systems this
is a waste of time. Even if it is only one second. The good thing is that there is a simple solution.

After sleeping we load `Test::More`, using the `require` function. We don't call `use`
as that would load `Test::More` at compile-time and thus it would be loaded even before the forking.
Regardless of the physical location of the `use`-statement. `require` on the other hand will
load the module during run-time. `import` will, well, import the various testing functions such as `ok()`
and `is()` and `plan()`.

We also load `Net::Telnet` in the client. We don't need to import anything from there as it is an object
oriented module.
Then we declare the expected number of test cases using `plan(tests => 7);`.
In this case we need to put parentheses after the parameters of `plan()` just as after `ok()` and all the
other testing functions, because they are not declared yet when perl compiles this part of the code.
We would not need the parentheses if we loaded `Test::More` with `use` during compile time, but we do need
the parentheses now.

```perl
sleep 1;
require Test::More;
import Test::More;
require Net::Telnet;
plan(tests => 7);
```

## Connect to the server

This is just creating a `Net::Telnet` object and then opening a connection to the server.
The result is going to be [true](/boolean-values-in-perl) if the connection succeeded.

Nothing fancy here:

```perl
my $t = Net::Telnet->new();
ok($t->open(Host => 'localhost', Port => 8000, Timeout => 10), 'connected');
```

## Waiting for the banner

Once our connection is established, the server is supposed to send a welcome message to the client.
It is sometimes called a <b>banner</b>. So we tell the telnet client to wait for a sign that should be the end of the
banner. As our application does not have a `prompt` we have to rely on the expected content. So we call
the `waitfor` method of the `Net::Telnet` object with a regular expression. For historical reasons this
needs to be a regex inside a string. That's why we have both single-quote `'` and a slash `/`.

The telnet client collects everything the server sends to the client in a buffer. The `waitfor` method watches that
buffer and tries to match the regex. Once the regex is matched the `waitfor` method returns two values.
(At least when it is called in list context as we called it.)
The second value is the actual match. (What would be in `$&` normally. The first value is the content of the
buffer up to the beginning of the match.
In this case we used `(?<= ... )` around the regex. This is a fixed-width look-behind. It means we are looking
for something that fits the regex between the parentheses, but when it matches it won't be part of `$&`.
This means we are expecting `$&` and thus the `$match` variable to be empty and the `$pre` variable
to contain the whole banner. Even the part that was in our regex.

Once we have `$pre` and `$match` we can use the regular testing functions `is()` to compare
them to the expected values.

```perl
{
    my ($pre, $match) = $t->waitfor('/(?<=if you want to leave)/');
    is($pre, "Welcome to the Echo server, please type in some text and press enter. Say 'bye' if you want to leave", 'banner');
    is($match, '', 'empty');
}
```

One more thing about this code. We put the 3 lines in a pair of curly braces because in the next few tests we will want to
use the same variables (`$pre` and `$match`) and we want to avoid accidentally checking an older
version of these values in a later test case. Putting them in a block restricts their scope.

## Testing the echo

The rest of the test script is the main part of the testing, but we have covered almost all the aspects of
the test script already. One thing remains. In both of the cases below, first we call the `print`
method of `Net::Telnet`. This simply sends its parameter to the server.

Then we go back our previous ritual, waiting for specific responses from the server.

```perl
{
    $t->print('hello');
    my ($pre, $match) = $t->waitfor('/You said "hello"/');
    like($pre, qr/^\s*$/, 'just newline');
    is($match, 'You said "hello"', 'reply by the server');
}
{
    $t->print('bye');
    my ($pre, $match) = $t->waitfor('/You said "bye"/');
    like($pre, qr/^\s*$/, 'just newline');
    is($match, 'You said "bye"', 'reply by the server');
}
```


