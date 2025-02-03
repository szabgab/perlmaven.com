---
title: "Caching data using the Cache module"
timestamp: 2015-06-21T11:00:01
tags:
  - Cache
  - Cache::File
  - Storable
  - Data::Dumper::Sortkeys
published: true
author: szabgab
---


There are all kinds of applications where caching can be useful.

For example if we need the IP address of perlmaven.com and [check if the machine is alive using ping](/how-to-check-if-a-server-is-live-using-ping).
There is no point in trying to [translate the hostname to and IP address](/dns-name-resolving-with-perl) every second. After all, this mapping rarely changes.
We could translate the name once, save the IP address locally and use that value in subsequent calls. That's caching.

This saves a lot of time, but we must not forget that the IP can change once in a while. So we will want to refresh the IP address stored in the cache once in a while.
In other words, we will want to set an expiration date for this item in the cache.


Of course if we set the expiration time to "10 minutes from now" and after 7 minutes the IP address of the real system changes then for 3 minutes we are going
to serve incorrect information. This is the trade-off. We save time and improve responsiveness of our application with the risk that we'll have incorrect information
for part of the time.

The art in caching is to find the balance.


## Examples

We are going to see a couple of simple examples using the [Cache](http://metacpan.org/pod/Cache) module.

We are going to use a filesystem-based cache.

## Caching a single value

In this example we have a function called `long_process` that imitates a long process by sleeping for 4 seconds.
Once the 4 seconds have passed it generates a random number. This is the function that represents the long and expensive task.

We would like to cache the result.

```perl
use strict;
use warnings;
use 5.010;

use Cache::File;

my $cache = Cache::File->new( cache_root => '/tmp/cache_demo' );

my $result = $cache->get( 'save' );
 
if (not defined $result) {
    $result = long_process();
    $cache->set( 'save', $result, '10 s' );
}
 
say $result;


sub long_process {
    sleep 4;
    return int rand 10;
}
```

First we create a instance of [Cache::File](https://metacpan.org/pod/Cache::File) which provide a filesystem-based
back-end for the Cache module. We need to pass the path to the directory where the data will be saved.

Then we attempt to get the data from the cache. The first time we run the script this will fail, and return `undef`,
as the cache is empty.  Let's skip it now.

The if-statement checks if we have the cached result. If not then we call the long and expensive process, and the call the
`set` method of the cache to store the result. `set` has 3 parameters. The first one is a unique key identifying
the data. We need this in order to be able to retrieve the data from the cache. The second parameter is the actual value we
would like to save. The third parameter is the expiration time of the data. It accepts many different units. Taken from
the source code of Cache.pm:

```
s second seconds sec
m minute minutes min
h hour hours
d day days
w week weeks
M month months
y year years
```

After the if-block we print the `$result`.

If we go back to the line where we called `get` we can now understand that the parameter here must be the same key we used to save
the value in the `set` call.

Let's see what happens when we run the script. We ran it using `date; time perl cache.pl`.
`date` was ran just so that we'll see the timestamp, and then we ran the script with `time`.
That executes the script and then prints the elapsed time in 3 parts. This will help us see what happens:

When we ran the script for the first time, `get` returned `undef` The `long_process`
was called. It waited 4 seconds (hence the real time is slightly more than 4 sec) and returned 5. That's what is
printed immediately after the date.

```
$ date; time perl cache.pl 
Tue May 13 15:14:35 IDT 2014
5

real    0m4.185s
user    0m0.070s
sys 0m0.015s
```

When we ran the script again, and again, `get` returned the previous value (5).
`long_process` was not called and thus the elapsed real time was less 0.1 sec.

```
$ date; time perl cache.pl 
Tue May 13 15:14:41 IDT 2014
5

real    0m0.082s
user    0m0.068s
sys 0m0.013s

$ date; time perl cache.pl 
Tue May 13 15:14:44 IDT 2014
5

real    0m0.085s
user    0m0.070s
sys 0m0.014s

$ date; time perl cache.pl 
Tue May 13 15:14:48 IDT 2014
5

real    0m0.081s
user    0m0.067s
sys 0m0.013s
```

When we ran the script a bit later - more that 10 sec after the first execution called the `set` method -
the value was expired by the cache and `get` returned `undef` again. This caused the
`long_process` to run again. After waiting 4 seconds it returned 7. The elapsed real time is again slightly
more than 4 seconds.

```
$ date; time perl cache.pl 
Tue May 13 15:14:51 IDT 2014
7

real    0m4.282s
user    0m0.072s
sys 0m0.016s
```

When we ran the script again shortly after the previous run finished, the cache returned the new value (7).

```
$ date; time perl cache.pl 
Tue May 13 15:15:01 IDT 2014
7

real    0m0.085s
user    0m0.069s
sys 0m0.015s
```


## Storing complex data

In the above code we save a single value with a fixed key.
What if the data we need to store is more complex? Maybe a hash?

The [Cache](https://metacpan.org/pod/Cache) was designed to only store strings so we will
need to <b>stringify</b>, or in other word <b>serialize</b> the data first. As we don't care about the
readability of the stored string and we don't need to access it from another programming language,
we can use the Perl-only [Storable](https://metacpan.org/pod/Storable) module for serialization.

We use the `freeze` function of Storable to create a binary string from the data structure we
would like to store. On retrieval, we call the `thaw` function of Storable that turns the binary string
back to a real Perl data structure. In the cache itself we store the binary string.

```perl
use strict;
use warnings;
use 5.010;

use Cache::File;
use Storable qw(freeze thaw);
use Data::Dumper qw(Dumper);
$Data::Dumper::Sortkeys = 1;

my $cache = Cache::File->new( cache_root => '/tmp/cache_demo' );

my $result = thaw $cache->get( 'save' );
 
if (not defined $result) {
    $result = long_process();
    $cache->set( 'save', freeze($result), '10 s' );
}
 
print Dumper $result;

sub long_process {
    sleep 4;
    return { a => int(rand 10), b => int(rand 10) };
}
```

There are a couple of changes from the first script besides calling `freeze` before storing the data,
and calling `thaw` in the retrieved data. The `long_process` now generates two random numbers and
returns a reference to a hash. 

Because I was lazy, we use [Data::Dumper](https://metacpan.org/pod/Data::Dumper) to display the data,
but in order to make it easier to compare the output between the runs we first
set `$Data::Dumper::Sortkeys` to [true](/boolean-values-in-perl). This tells Data::Dumper
to sort the keys.

The output for several runs is this:

```
$VAR1 = {
          'a' => 4,
          'b' => 8
        };
```

And after the cache expires it changed to this:

```
$VAR1 = {
          'a' => 7,
          'b' => 5
        };
```

It worked well.

## Reference passed to set at ..

When I started to write the example I did not notice that `set` can only handle strings
so I passed the hash reference. First I got a warning
`Unknown warnings category 'Cache' at .../Cache/Entry.pm line 107.` (using Cache 2.09).

I submitted a bug report and within 2 hours it was fixed. Now (Cache v2.10) the warning says:

`Reference passed to set at .../Cache.pm line 293.`


## Comments

Hallo,

If I want to send a hash in the cache, shall I send the hash as such or its reference ?

I mean, if I have :

my %myhash = ();
$myhash{1}{2}=3;
$myhash{4}{5}=6;

shall I do :

$cache->set( 'my_hash', freeze(%myhash));

or :

my $myreferencehash = %$myhash;
$cache->set( 'my_hash', freeze($myreferencehash));

Thank you!


