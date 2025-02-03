---
title: "Create Daemon (service) from a Perl script using Daemon::Control"
timestamp: 2021-02-15T12:30:01
tags:
  - Daemon::Control
published: true
author: szabgab
archive: true
description: "It is quite easy to turn a perl script into a daemon on Linux that you can manage with systemctl."
show_related: true
---


It is quite easy to turn a perl script into a daemon on Linux that you can manage with systemctl.



## Original script

{% include file="examples/daemon/original.pl" %}

This is a very simple script that has an infinite loop writing to a log file every second.
If you press Ctr-C then the script will capture that signal (the INT signal), set the <b>$continue</b> flag to 0
and the loop will stop and then the program as well. This is a graceful termination of the process.

How can we convert this something that we can run as a service?

## HUP and TERM instead of INT

Instead of expecting an INT signal which is sent when your press Ctrl-C while starting at a ru8nning process
we are expecting two other signals. the <b>TERM</b> signal will be received when we try to "<b>stop</b>" the service and when we try to "<b>restart</b>" it.

The <b>HUP</b> is received when we try to "<b>reload</b>" the service. Most service would re-read their configuration file when they are reloaded.
We'll do that too.



The application:

{% include file="examples/daemon/local.pl" %}

The code to create the dameon is the following, using [Daemon::Control](https://metacpan.org/pod/Daemon::Control)

{% include file="examples/daemon/daemon.pl" %}

This version is assumed to be located in the same directory as the script itself.

```
$ perl daemon.pl
Syntax: daemon.pl [start|stop|restart|reload|status|foreground|show_warnings|get_init_file|help]
```

Starting the process:

```
$ perl daemon.pl start
```

You can chenge the content of "config.txt" while the service is running and then execute

```
$ perl daemon.pl reload
```

It will re-read the configuration file and continue running.

```

{% include file="examples/daemon/local_process.log" %}

Stopping the process:

```
$ perl daemon.pl stop
```


## System-wide version




