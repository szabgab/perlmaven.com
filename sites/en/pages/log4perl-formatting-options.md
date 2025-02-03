---
title: "Log::Log4perl layouts and formatting options"
timestamp: 2020-11-06T17:30:01
tags:
  - Log::Log4perl
  - Log::Log4perl::Layout
published: true
author: szabgab
archive: true
description: "Log4Perl is a roboust logging system for Perl, but you can get started with it quite easily without the need of configuration files."
show_related: true
---


[Log::Log4perl](https://metacpan.org/pod/Log::Log4perl) is a roboust logging system for Perl, but you can get started with it quite easily without the need of configuration files.


## Install

Remember, before you use this module you need to install it. e.g. using [cpanm](/cpanm):

```
cpanm Log::Log4perl
```


## Log::Log4perl example

This code:

{% include file="examples/log4perl.pl" %}

Will show this log message:

```
2020-11-06 17:41:49 - INFO - log4perl.pl-12-main:: - This is info
```

You can learn a lot more about [Layout patterns](https://metacpan.org/pod/Log::Log4perl::Layout::PatternLayout)
and the [date-formatting](https://metacpan.org/pod/Log::Log4perl::DateFormat) options.

