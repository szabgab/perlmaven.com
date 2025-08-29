---
title: "Rex"
timestamp: 2021-02-17T08:30:01
tags:
  - Rex
published: true
author: szabgab
archive: true
show_related: true
---


[Rex](https://www.rexify.org/) is an automation framework written in Perl. Here are a few commands I learned recently.


Give 3 servers s1.perlmaven.com, s2.perlmaven.com, and s3.perlmaven.com

```
rex -H s1.perlmaven.com -e 'say for run q(uptime)'
rex -H 's1.perlmaven.com s2.perlmaven.com s3.perlmaven.com' -e 'say for run q(uptime)'
rex -H 's[1,2,3].perlmaven.com' -e 'say for run q(uptime)'
rex -H 's[1..3].perlmaven.com' -e 'say for run q(uptime)'
rex -H 's[1..3].perlmaven.com' -e 'my $out = run q(uptime);  say scalar reverse $out'
rex -H 's[1..3].perlamven.com' -e 'say for run q(df -h)'
```

Given just IP addresses

```
rex -u root -H '104.248.57.39 104.248.53.65' -e 'say for run q(hostname)'
```


I could also edit **vim ~/.ssh/config** and add the following:

```
Host d1
    Hostname 104.248.57.39
Host d2
    Hostname 104.248.53.65

Host d*
    User root
```

Then I can use:

```
rex -H 'd[1..2]' -e 'say for run q(hostname)'
```

