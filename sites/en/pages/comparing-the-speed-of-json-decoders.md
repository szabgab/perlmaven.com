---
title: "Comparing the speed of JSON decoders"
timestamp: 2015-03-04T07:30:01
tags:
  - JSON
  - JSON::XS
  - Cpanel::JSON::XS
  - Benchmark
types:
  - screencast
published: true
author: szabgab
---


Recently I worked on a project at a client where we had to read a JSON file and insert data from it into a database.
Without thinking much I started to use the [JSON](https://metacpan.org/pod/JSON) module.

We encountered some speed issues - our script ran more than 30 minutes - so I set out to improve the speed.

I knew it will be difficult, somehow I still don't like checking the speed of SQL statements.


{% youtube id="xGJkTOBvmY4" file="comparing-the-speed-of-json-decoders" %}

In other cases I might have started by profiling the script, but our script had two very distinct parts, reading
the JSON file and then inserting data to the database, so even before involving some heavy weight profiling,
I added a print statement just after the JSON was read and ran the script.

When after a few minutes I still did not see the printing I knew we have a problem reading the JSON file.
It was a big file and I started to suspect that we might have ran out of memory and started swapping,
or that parsing JSON was so slow.

But I recalled there is a [JSON::XS](https://metacpan.org/pod/JSON::XS), it must be faster.

I installed this module, updated the script and then ran it again.
After 30 seconds it was done.


## Benchmarking JSON and JSON::XS

Let's compare the speed of these two modules

{% include file="examples/benchmark_json.pl" %}

The `create_json` function will create a JSON file using the `encode_json` function of the JSON module.

The `cmpthese` function that comes from the [Benchmark](https://metacpan.org/pod/Benchmark) module will run both
anonymous functions 10000 times. (The number it received as the first parameter.) Then it prints how many times the function could be
called if it ran for a second, and a comparison table showing the relative speed of the methods.

To my great surprise they were the same:

```
$ time perl benchmark_json.pl 
            Rate JSON::XS     JSON
JSON::XS 13889/s       --       0%
JSON     13889/s       0%       --

real    0m1.517s
user    0m1.501s
sys 0m0.016s
```

## Reading the docs, fixing the benchmark

I know there are some pure-perl modules on CPAN that will use their XS counter-part if it is loaded in the memory.
They might even load it on our behalf if it is installed. (eg. Text::CSV will load Text::CSV_XS if the latter is available.)
I looked at the documentation of the [JSON](https://metacpan.org/pod/JSON) module and it turns out
it is only an empty shell that uses either the pure perl implementation in [JSON::PP](https://metacpan.org/pod/JSON::PP),
or, if it is available then the XS version [JSON::XS](https://metacpan.org/pod/JSON::XS).

So in the above benchmark I effectively compared the JSON::XS module with itself. Very useful.

I had to change the code in 3 places adding ::PP after JSON. (OK, the name of the benchmark could have stayed 'JSON',
but it looks nicer this way.

```perl
use JSON::PP ();

cmpthese(10000, {
    'JSON::PP' => sub { JSON::PP::decode_json($json) },
    'JSON::XS' => sub { JSON::XS::decode_json($json) },
});
```

The result of running the script is now:

```
$ time perl benchmark_json.pl 
            Rate JSON::PP JSON::XS
JSON::PP   222/s       --     -98%
JSON::XS 12987/s    5742%       --

real    0m45.843s
user    0m45.747s
sys 0m0.086s
```

Wow, the elapsed time measured by the external `time` command went from 1 second to 45 seconds and the
table printed by `cmpthese` is very clear. the XS version is 57.42 times faster than the PP version.
That explains the extreme speed-up we got in our script reading the JSON file.


## Cpanel::JSON::XS

In another conversation I have heard the module [Cpanel::JSON::XS](https://metacpan.org/pod/Cpanel::JSON::XS)
mentioned. It felt really strange, why is there a generic module named after a company and I did not even take a look back then.
Now I looked at it and even installed. As it turns out this is just a fork of the JSON::XS module with some fixes and 
a public version control system. So it is actually more open than the original version.

I installed the module and ran a benchmark with that too:

The interesting part looks like this:

```perl
use JSON::XS ();
use Cpanel::JSON::XS ();
use Benchmark qw(cmpthese);

my $json = create_json(1000);

cmpthese(10000, {
    'JSON::XS'  => sub { JSON::XS::decode_json($json) },
    'Cpanel'    => sub { Cpanel::JSON::XS::decode_json($json) },
});
```

And the result? They have the same speed. Maybe 1% difference that can be just a side-effect of the benchmarking.
So it is probably better to use the Cpanel::JSON::XS.

## JSON::MaybeXS

I am not sure why is this need to be in a separate module (and not part of the JSON module),
but [JSON::MaybeXS](https://metacpan.org/pod/JSON::MaybeXS) is also a "shell" loading
either Cpanel::JSON::XS, or JSON::XS, or JSON::PP in that order.

So if you want to make sure, your JSON decoding is fast and correct, use Cpanel::JSON::XS.

If you want to give people more choices  then use JSON::MaybeXS.
That way the users or system administrators of your code can install Cpanel::JSON::XS if they need
speed and have a C compiler, or can keep using JSON::PP if they don't have a C compiler or just don't need the extra speed.

