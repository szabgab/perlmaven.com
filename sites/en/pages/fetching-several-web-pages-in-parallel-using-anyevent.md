---
title: "Fetching several web pages in parallel using AnyEvent"
timestamp: 2015-04-15T10:10:01
tags:
  - AnyEvent
published: true
books:
  - anyevent
author: szabgab
---



In another article we covered
[several ways to download HTML pages](/simple-way-to-fetch-many-web-pages)
from the Internet.

They all had the same drawback, that they work in serial. One request had to finish before the
next one could be made. While this make the program simple to write, it wastes a lot of time
and resources.

After all the CPU in your computer does not do anything while it is waiting for the response from the remote
server, and your network is not saturated either.

If you had 100 pages to download, and each one took 6 sec. That would take a total of 600 sec = 10 minutes.

If you retrieved 10 pages at a time in parallel, you could reduce the total time to 1 minute.

How can you do that?


## HTTP requests using AnyEvent

First let's see a solution that would download <b>all</b> the URLs
in parallel.

```perl
use strict;
use warnings;
use 5.010;

use AnyEvent;
use AnyEvent::HTTP;

my @urls = qw(
    https://perlmaven.com/
    https://cn.perlmaven.com/
    https://br.perlmaven.com/
);

my $cv = AnyEvent->condvar;

foreach my $url (@urls) {
    say "Start $url";
    $cv->begin;
    http_get $url, sub {
        my ($html) = @_;
        say "$url received, Size: ", length $html;
        $cv->end;
    };
}

say 'Before the event-loop';
$cv->recv;
say 'Finish';
```

## Explanation

We are using the [AnyEvent](https://metacpan.org/pod/AnyEvent) module,
and with that we use the `http_get` function
of the [AnyEvent::HTTP](https://metacpan.org/pod/AnyEvent::HTTP) helper module.

Basically AnyEvent provides its own loop, the so-called <b>event-loop</b> that runs when
we call `$cv->recv`. `$cv` has an internal counter. It is increased by every
`$cv->begin` call and decreased by every `$cv->end` call.

The even-loop that was initiated by `$rc->recv` will run until this counter goes back
to 0.


Before reaching the `$cv->recv` call, we had to prepare all the HTTP requests
(3 in the above example). In each iteration of the for-loop, we call `$cv->begin` once.
This increments a counter inside the `$cv` object, and then we call the
`http_get` function of the `AnyEvent::HTTP` module.
This call inserts and HTTP request into the internal queue of AnyEvent. It does <b>not</b>
fetch the page yet, it just puts the request in the internal queue.

The `http_get` function has two parameters. The first one, the `$url` is the address
of the page to be fetched. The second one is an anonymous function that works as a call-back.

When the event-loop of AnyEvent, will send out the first HTTP request, it won't stop to wait for the response.
Instead it will wait for the response while doing other things. In our case the "other things" will
be sending out two more HTTP requests. Once those have been sent, AnyEvent will keep waiting
at the `$cv->recv` call, till the counter in the `$cv` object becomes 0.

Because the `http_get` does not wait for the response, it cannot "return" the result either.
Instead, when the response arrives, AnyEvent will call the anonymous function we passed to `http_get`
as a second parameter. It will also pass the content of the remote page as the first argument to the
anonymous function.

The anonymous function is quite simple:

```perl
 sub {
        my ($html) = @_;
        say "$url received, Size: ", length $html;
        $cv->end;
    };
```

It receives the content of the remote page as its first parameter. Prints out the address of the requested page
which is in `$url` variable, and then prints out the size of the downloaded page. In a real example
there would be a lot more processing, but I did not want to hide the important parts of the solution.
The last statement of the function is calling `$cv->end`. This will decrement the counter that
`$cv->begin` incremented.

As we called `begin` 3 times, the counter went up to 3. It will reach 0 after all 3 calls returned.

At that point the `$cv-recv` will stop waiting and the script will print out <b>Finish</b> and exit.

If we run the script we'll see output like this:

```
Start https://perlmaven.com/
Start https://cn.perlmaven.com/
Start https://br.perlmaven.com/
Before the event-loop
https://br.perlmaven.com/ received, Size: 12664
https://cn.perlmaven.com/ received, Size: 13322
https://perlmaven.com/ received, Size: 20172
Finish
```

First the 3 "Start" entries are printed before the "Before the event-loop" is reached. Then, during the
execution of `$cv->recv` we receive the 3 URLs. Please note, they have not arrived in the same order
as we sent them. Finally, after the counter went back to 0, the "Finish" line is reached.


## Throttle

Having 2-3 network operations in parallel will reduce the total elapsed time,
but it will increase the load on our CPU and our network. As the number
of parallel operations grow, the additional time-savings get smaller and smaller,
while at one point some other part of the system becomes a bottle neck.

Even if your system could handle 1000 outgoing requests at the same time, the
server you are downloading from, might not be able to do that.

It will be wise to set an upper limit to the number of concurrent requests.
In other words, we would like to throttle the request to a maximum number
at any given time.

The next script will do that.

```perl
use strict;
use warnings;
use 5.010;

use AnyEvent;
use AnyEvent::HTTP;

my @urls = qw(
    https://perlmaven.com/
    https://cn.perlmaven.com/
    https://br.perlmaven.com/
    https://tw.perlmaven.com/
    https://es.perlmaven.com/
    https://it.perlmaven.com/
    https://ko.perlmaven.com/
    https://he.perlmaven.com/
    https://te.perlmaven.com/
    https://ru.perlmaven.com/
    https://ro.perlmaven.com/
    https://fr.perlmaven.com/
    https://de.perlmaven.com/
    https://id.perlmaven.com/
);

my $cv = AnyEvent->condvar;

my $count = 0;
my $max = 3;

for (1 .. $max) {
   send_url();
}
$cv->recv;


sub send_url {
    return if $count >= $max;

    my $url = shift @urls;
    return if not $url;

    $count++;
    say "Start ($count) $url";
    $cv->begin;
    http_get $url, sub {
        my ($html) = @_;
        say "$url received, Size: ", length $html;
        $count--;
        $cv->end;
        send_url();
    };
    return 1;
}
```

Here we have a lot more URLs, to make it easier to demonstrate the script.

We use two global variables. `$max` that is effectively a constant, and `$count`,
that holds the number of concurrent requests at any given time. It starts with 0 as we have
not sent any request yet. Before launching the even-loop with the `$cv->recv` call, we
execute the `send_url()` function several times to fill the internal queue of AnyEvent.
As AnyEvent would just send out all the requests it has in its queue, we have to make sure there
are no more requests than what we decided to be the `$max` number.

The `send_url()` function is the heart of our system.
It will attempt to put another `http_get` request on the internal queue of AnyEvent,
but it will only do it
<ol>
  <li>if we have not reach the max concurrency number. So if  `$count >= $max` we don't want more requests.</li>
  <li>if cant send more requests if the list (in `@urls`) has been finished.</li>
</ol>


Before sending out the request, we increment both our own counter `$count++` and the internal
counter of AnyEvent: `$cv->begin`.
In the call-back we decrement both. (`$count--` and `$cv->end`.

Then we try to put another `http_get/hl> request on the internal queue.

The whole process will finish when both he external queue (`@urls`) and the internal queue
of AnyEvent are empty.

If you run the above script, the output will look something like this:

```
Start (1) https://perlmaven.com/
Start (2) https://cn.perlmaven.com/
Start (3) https://br.perlmaven.com/
https://cn.perlmaven.com/ received, Size: 13322
Start (3) https://tw.perlmaven.com/
https://br.perlmaven.com/ received, Size: 12664
Start (3) https://es.perlmaven.com/
https://tw.perlmaven.com/ received, Size: 11286
Start (3) https://it.perlmaven.com/
https://it.perlmaven.com/ received, Size: 11428
Start (3) https://ko.perlmaven.com/
https://es.perlmaven.com/ received, Size: 11076
Start (3) https://he.perlmaven.com/
https://perlmaven.com/ received, Size: 20166
Start (3) https://te.perlmaven.com/
https://ko.perlmaven.com/ received, Size: 12073
Start (3) https://ru.perlmaven.com/
https://he.perlmaven.com/ received, Size: 11483
Start (3) https://ro.perlmaven.com/
https://te.perlmaven.com/ received, Size: 11870
Start (3) https://fr.perlmaven.com/
https://ru.perlmaven.com/ received, Size: 12250
Start (3) https://de.perlmaven.com/
https://fr.perlmaven.com/ received, Size: 15820
Start (3) https://id.perlmaven.com/
https://de.perlmaven.com/ received, Size: 15422
https://ro.perlmaven.com/ received, Size: 14611
https://id.perlmaven.com/ received, Size: 11174
```

If you look over the data, you will see that, for example the request to https://perlmaven.com/ that
went out as the first request, came back only after 5 others have finished.


## Measurement

In order to see the impact of the asynchronous operation, you could run the above
script with different values in the `$max` variable. (Maybe you should also select
10-20 URLs on other sites, so it won't be only my server handling the load ...)

You can also compare the results (the elapsed time) with one of the
[linear solutions](/simple-way-to-fetch-many-web-pages).

I ran the above script with `$max = 2` and the total elapsed time was 9 sec.
Then I ran it with `$max = 6` and the total elapsed time went down to 4 sec.

This is of course very far from being a good measurement. Please try it with various other
sets of URLs and values of `$max`.

## Comments

Thanks, this was helpful in my script which gets the WAN ip address from my router.

#!/usr/bin/perl
open(FIL,"wget --quiet --output-document=- 'http://192.168.254.254/' |");
$flag=0;
while (<fil>) {
   last if ($flag); # exit loop with line after "WAN IP:" is found
   if (index($_,">WAN IP:") > 0) {
      $flag = 1;
   }
}
print $_;

<hr>

Thanks for the code sample. If this helps anyone, there's a bug in the Throttle version when $max=1, as the $cv->end will cause the script to finish before the next $cv->begin is run.

The fix is to swap 49 and 50 so it is:

send_url(); # This will run $cv->begin so $cv->recv doesn't break out of the script
$cv->end;

and then the script will finish processing all urls.

