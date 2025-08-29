---
title: "Testing sessions by mocking time"
timestamp: 2015-03-22T15:30:01
tags:
  - time
  - Test::MockTime
types:
  - screencast
published: true
books:
  - testing
author: szabgab
---


How can we test if a system that handles sessions will properly handle timeout?
Let's say after successful login, the system needs to let us use it for 60 seconds, but after 60 seconds
it has to time out and prompt us for a password. If we want to make sure it really prompts us for a password
we have to wait 60 seconds every time we run our tests. What if the requirement is to time out after 1 year?

Clearly we cannot let our test script wait for that. Even 60 seconds is too much.

Instead of that we can ask perl to lie about the time. In other words, we can mock time.


{% youtube id="lVanBTERBAs" file="testing-session-mocking-time" %}

This is **MySession.pm**. Probably not the best implementation of a session object, but it will work for our purposes.

{% include file="examples/mock-time/MySession.pm" %}

In order to use it we need to create a session object using  the `new` constructor. Then every "user" will log in by calling the `login` method
and providing credentials in the form of username/password. In this code we don't check the credentials, we just add an entry to the `%SESSION` hash
using the `$username` as the key and the current `time` as the value.

Later, on every access our system will call the `logged_in` method with the username. It will check if the given user has an entry in the `%SESSION`
hash, and if the time passed since then is less than the `$TIMEOUT` period.

When we use it, this should happen:

```perl
use MySession;

my $s = MySession->new;
$s->login('foo', 'secret');
say $s->logged_in('foo');   #  true
sleep 61;
say $s->logged_in('foo');   #  false
```

We can now write a test script `time.t`
that we put in the same directory where we already have `MySession.pm`

{% include file="examples/mock-time/time.t" %}

Except that we don't want to wait for 61 seconds for this.

One solution would be to change the value of `$TIMEOUT` in the `MySession.pm` module to something low, so the test will only need
to wait that short period of time, but in complex system you might not be able to do that.


That's where [Test::MockTime](https://metacpan.org/pod/Test::MockTime) comes into play.
Even though it is not actually a `Test::*` module as it does not provide any `ok()` function to be used in a test. It could have been used in any
application if for some reason you'd want to fake time.

The way it works is that at load time it replaces perl's global `time()` function with a subroutine of its own. Then every time the `time()` function
is called, the module has full control over what is returned. It can return a fixed number, as if time froze on a specific second after the epoch (`set_fixed_time`);
or it can return the real time changed by an offset. (either `set_relative_time` or `set_absolute_time`).

We use the function `set_relative_time` provided by `Test::MockTime` which can be used to set this offset.

So the two things we need to change here are: adding `use Test::MockTime qw(set_relative_time);`
and replacing the `sleep 61;` that actually waits for 61 seconds by `set_relative_time(61);`
that just fakes it.

{% include file="examples/mock-time/fake_time.t" %}

Running either version of the test script `perl time.t` will result in:

```
1..3
ok 1 - foo logged in
ok 2 - bar not logged in
ok 3 - foo not logged in - timeout
```

but in the second case this runs 61 seconds faster.

One important note: the `Test::MockTime` module must be loaded before the module we are testing is loaded. Otherwise the mocking will have no impact on that module.

