---
title: "Profiling and 100 times speed improvement"
timestamp: 2015-10-15T20:30:01
tags:
  - YAML
  - YAML::XS
  - Devel::NYTProf
published: true
author: szabgab
archive: true
---


Some times ago I have noticed that the Perl Maven site got slower. I thought it might mean I have outgrown the server.
Or maybe the the new calls to the MongoDB backend are causing the problem. I even checked what would it cost
to upgrade the [Linode](/linode) I have, but as I did not know what is the real source of the problem,
I was not sure that would help.


## Prepare for profiling

The proper thing to do in this case is to try to find out what is the source of the long processing.
In order to do that I wrote a small script that would load a single page.
My site is using [Dancer](/dancer) and it has an `app.psgi` file that could be used to launch Dancer
via any [PSGI](/psgi) compliant server.

I wrote a small program, similar to how a test-script would look like that loads a single page. (Just the HTML part.)

{% include file="examples/psgi_profiling.pl" %}

It loads the `app.psgi` file using `do`. As per the requirement of any such file, it returns a reference
to a function that represents the application. Then we use [Plack::Test](https://metacpan.org/pod/Plack::Test)
to provide an environment for the application and finally we use the `GET` function of
[HTTP::Request::Common](https://metacpan.org/pod/HTTP::Request::Common) to send in a request.

## Run the profiler

Once the above program was ready I ran the [Devel::NYTProf](https://metacpan.org/pod/Devel::NYTProf) profiler with
the following command:

```
perl -d:NYTProf  psgi_profiling.pl
```

This created a file called `nytprof.out`

Then I ran

```
nytprofhtml
```

which generated a beautiful HTML report.

That report clearly showed that most of the time was spent executing various functions of
[YAML](https://metacpan.org/pod/YAML).

## Replace YAML by YAML::XS

I don't have a benchmark for YAML vs YAML::XS, but it seems to be obvious that
the latter will be much faster. Just as
[JSON::XS is much faster than JSON](/comparing-the-speed-of-json-decoders)

So I decided to give it a try and replaced YAML by [YAML::XS](https://metacpan.org/pod/YAML::XS)
in the whole code.

Though I thought they are fully compatible it turned out that there are several
[constructs that YAML allows and YAML::XS rejects](/yaml-vs-yaml-xs-inconsistencies). Luckily the tests I had complained.
Then I spent about 2 hours trying to figure out the specific issues. The fix was easy, just locating
the files was difficult. Maybe that too could be explained by the fact that I did this at 2 am
after a full day of work.

Once I finished, I ran the profiler again and was happy to see the YAML calls are almost totally gone.

In the morning I've deployed the new version.

This is what the [Munin graphs](http://munin-monitoring.org/) show half a day later:

## Request processing time

It went down from an average of 2-3 to almost nothing.
The graph shows the last 24 hours. The green line shows the average request processing time in the preceding 5 minutes.
It dropped immediately once I deployed the new version. The blue line shows the average of the past 24 hours. It will
catch up with the green line in 24 hours.

<img src="/img/perl_maven_processing_time_2015_10_15.png" alt="Perl Maven site request processing time" width="497" height="292" />

## CPU load

At the same time the CPU load also went down.

<img src="/img/perl_maven_cpu_usage_2015_10_15.png" alt="Perl Maven site CPU load" width="497" height="376" />

So based on this I won't need to upgrade the server any time soon, but probably more importantly,
you the reader will get much better response time from the server.

