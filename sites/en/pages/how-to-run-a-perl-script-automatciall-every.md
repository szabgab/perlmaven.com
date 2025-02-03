---
title: "How to run a Perl script automatically every N hours"
timestamp: 2014-04-15T23:00:01
tags:
  - cron
published: true
author: szabgab
---


Scheduling perl scripts to run at a certain time, or at a certain interval is usually done by some service of
the operating system. In Unix/Linux/Mac OSX this can be crontab, and we call the processes `cron-jobs`.

On Windows there is a service called scheduler that will do the work.


## Linux/Unix/Mac OSX

The crontab on Linux/Unix/Mac OSX can be configured by editing a text file with a special command.

Each line in the file is a scheduled job.
Empty lines and lines starting with `#` are disregarded:

The other lines contain 6 values. The first five represent the schedule in the following order:
minute, hour, day of month, month, day of week.

The 6th is the actual command.

* at any of the first five slots mean "every" so a * at the first slot means "every minute".

The following crontab will run every minute:

```
# m h  dom mon dow   command
* * * * * /home/gabor/perl5/perlbrew/perls/perl-5.18.2/bin/perl /home/gabor/bin/ts.pl >> /home/gabor/ts.out
```

## How to run a Perl script automatically every 12pm

The following crontab will run every day at 12 hour 0 minutes.

```
# m h  dom mon dow   command
0 12 * * * /home/gabor/perl5/perlbrew/perls/perl-5.18.2/bin/perl /home/gabor/bin/ts.pl >> /home/gabor/ts.out
```

Every user in a Unix/Linux system has her own crontab.  `crontab -l` will list the crontab file of the
current user. You can prepare a text file (e.g. crontab.txt) describing your cron-jobs with any editor and then load them
using `crontab path/to/crontab.txt`. I usually keep that text file under version-control.

Every hour +0, +20, and +40 minutes:

```
0,20,40 * * * * command
```

Every 2 minutes:

```
*/2 * * * * command
```

## MS Windows

MS Windows has a service called
[Windows Task Scheduler](https://docs.microsoft.com/en-us/windows/desktop/taskschd/task-scheduler-start-page). Use that.


## Comments

How to run the written Perl program for every 1 hour in Windows? I need to take back up of files for every one hour. Please help.

Look for the Windows Task Scheduler: https://learn.microsoft.com/en-us/windows/win32/taskschd/task-scheduler-start-page

<hr>

Hi Gabor,
Few doubts want to get off.
1) why can't we write 0 1 * * * command to run for every hour instead code line you provided.
2) When I tried to replicate same code and tried to run corntab.txt by source command . I got error saying that 0 command not found so is there any header file to include before these set of lines. can you please help me in this.

---

1) That's the same I wrote with different numbers
2) Then you might have done something else not what I wrote
