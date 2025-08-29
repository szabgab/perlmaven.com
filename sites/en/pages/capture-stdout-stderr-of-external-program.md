---
title: "Capture STDOUT and STDERR of external program using Capture::Tiny"
timestamp: 2021-12-27T08:30:01
tags:
  - capture
  - STDOUT
  - STDERR
  - exit
  - Capture::Tiny
published: true
author: szabgab
archive: true
show_related: true
---


In Perl there are many ways to run external programs. Some of the ways will allow you to capture the output of the external program
and some will even make it easy and fun. We are now looking at [Capture::Tiny](https://metacpan.org/pod/Capture::Tiny).


## The external "application"

Our solution will work for any command line application regardless the language it was written in, we are using an example written in Perl
so you can easily see what it does and you can easily modify to se how our capturing solutions behave in different situations.

{% include file="examples/some_app.pl" %}


## capture STDOUT and STDERR separately

We use the **capture** function of Capture::Tiny that will wait till the end of the external process and then return whatever was printed
to STDOUT and STDERR separately as two strings. (The FindBin and File::Spec code is only there so we can easily locate the external program
that can be found next to our capturing script.)

{% include file="examples/capture_stdout_stderr_separately.pl" %}

In our case the output will look like this:

```
$ perl examples/capture_stdout_stderr_separately.pl

---- STDERR: --------------
First message to stderr
Second message to stderr

---- STDOUT: --------------
First message to stdout
Second message to stdout

---- EXIT CODE: -----------
3
---------------------------
```

## capture STDOUT and STDERR merged

In this example we capture the standard output and standard error as one stream. There is no guarantee that they will appear in this output as
they would on your console as usually STDOUT is buffered and STDERR is not.

{% include file="examples/capture_stdout_stderr_merged.pl" %}


```
$ perl examples/capture_stdout_stderr_merged.pl

---- STDOUT and STDERR: ---
First message to stderr
Second message to stderr
First message to stdout
Second message to stdout

---- EXIT CODE: -----------
3
---------------------------
```


## qx

As an alternative [qx](/qx) (the same as backtick) too can capture the STDOUT of your external application.

