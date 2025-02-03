---
title: "Protecting from crash"
timestamp: 2015-05-29T21:05:01
tags:
  - SCO
  - eval
types:
  - screencast
published: true
books:
  - search_cpan_org
author: szabgab
---


I am not sure exactly what have I done, but suddenly, when I tried to access the development web server,
it crashed with the following error:

```
Error open (<:raw:encoding(UTF-8)) on '/Users/gabor/work/MetaCPAN-SCO/totals.json': No such file or directory at lib/MetaCPAN/SCO.pm line 59.
```


{% youtube id="YGtaate3ois" file="protecting-from-crash" %}

Right, so apparently I have removed the `totals.json` form the root of the application and when I tried to load the main
page it could not find the file and died when the object returned by `path` tried open in for reading.
We should either make lots of checks: Does the file exist? Can it be opened? Is the content JSON? Can it be converted to Perl data structure?
Or, we should wrap the whole thing in an eval-block and check if we have received an exception
from either the `open` or from the `from_json`.

Actually, at least for now, it is enough if we wrap the call in an eval-block. After all, there is not much we
can do if this fails. Maybe we should see it in a log file, but I am not sure that the web application should do
that. If this failure is caused by an unlucky timing when the file was updated by the cron-job, then it will be fixed within a second,
and if it is a permanent issue then we probably don't want our log-file to be filled with this error message.

So we only write:

```perl
 eval {
     $vars->{totals} = from_json path("$root/totals.json")->slurp_utf8;
 };
```

[commit](https://github.com/szabgab/MetaCPAN-SCO/commit/9e94ab0c84d229f6fd1a7db1d55c03480b2fb723)


