---
title: "How to get notification when specific contact goes online in Skype?"
timestamp: 2013-12-05T11:30:01
tags:
  - Skype::Any
published: true
books:
  - cook_book
author: szabgab
---


Skype has plenty of notification options. For example you can separately configure it to give sound or visual notification when one of you contacts comes on-line. Unfortunately it is an all-or-nothing option. Either you get notified for every contact or for none of them.

The constant pop-ups disturb me, but I'd like to get alerted when my mother comes on-line.

Luckily I found [Skype::Any](https://metacpan.org/pod/Skype::Any) written by Takumi Akiyama. It's wonderful. It let's you connect to your running Skype client and then it can do all kinds of magic.



## Platforms

Before looking at the actual code. As I read in the documentation, the module
(version 0.06) it only works on Linux and Mac OSX. Patches for Windows are welcome.

I tried this on Mac OSX.

After installing [Skype::Any](https://metacpan.org/pod/Skype::Any)
I also had to install
[Cocoa::Skype](https://metacpan.org/pod/Cocoa::Skype), and
[Cocoa::EventLoop](https://metacpan.org/pod/Cocoa::EventLoop) separately.

The module also comes with a warning. Apparently Skype is
[shutting down part of this API](https://support.skype.com/en/faq/FA12349/skype-says-my-application-will-stop-working-with-skype-in-december-2013-why-is-that) in December 2013. That's now. So this whole solution might go away in a few weeks. We'll see.

## The Selective Skype Notification Agent

```perl
use strict;
use warnings;
use 5.010;

use Skype::Any;

my $skype = Skype::Any->new(name => "Selective Notification Agent");

$skype->user(sub {
    my ($user, $status) = @_;
    say $status;
    say $user->handle;
    say $user->fullname;
    say '---';
});

$skype->run;
```

That's the whole script.

When you run this script it will try to connect the **already running** Skype client.
The Skype client will ask for your permission.
(For a screenshot see the [documentation of Skype::Any](https://metacpan.org/pod/Skype::Any).) You can let this script connect to your Skype once or always. Later you can turn this off, from within Skype.

Also, as far as I understand the permission is given to a third-party application with a specific name. By default Skype::Any would use the name **Skype::Any**, but in the constructor we gave it another name.

Anyway, once the connection is established, the events in the Skype client will generate call-backs in our script. We are interested in the user-related events, so register the event handler `$skype->user` passing an anonymous subroutine to it.

When a user changes their status, this function will be called and two values will be passed. The first one is a [Skype::Any::Object::User](https://metacpan.org/pod/Skype::Any::Object::User) object and the second one is the new status of the user. In the short time I ran this script I only saw the strings `NA`, `OFFLINE`, and `ONLINE`.

The Skype::Any::Object::User has all kinds of interesting methods providing details about that specific contact, but the most interesting to us is the `handle` field. This is the unique Skype ID of the person.

In the above example I only printed it along with the `fullname` but I could do other interesting things.

## Filtering Selected Users

I could create a hash of `"username" => "Text message"` pairs for the important people. (In this case my mother), and print the message only when the user handle matches one of the keys:

```perl
my %vip = (
    mothers_handle => 'Your mom is online!',
    handle_of_boss => 'Pretend you are busy working!',
);

$skype->user(sub {
    my ($user, $status) = @_;
    return if $status ne 'ONLINE';
    my $handle = $user->handle;
    if (exists $vip{ $handle }) {
        say $vip{ $user->handle };
        system qq{say "$vip{ $handle }"};
    }
});
```

First we disregard notifications where the user has just went off-line by
`next if $status ne 'ONLINE';`.

Then if the `handle` exists as a key in our hash, we do something.
Specifically I just read about the `say` command available on Mac.
It would read the text to me. So instead of a visual notification
I went with a speaker telling me what to do.

You might have a better idea what to do there.

