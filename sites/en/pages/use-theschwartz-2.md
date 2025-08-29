---
title: "How To Use TheSchwartz Perl Module (Part 2)"
timestamp: 2020-01-01T00:00:00
description: "How to use TheSchwartz Perl module (Part 2)"
tags:
  - FreeBSD
  - PostgreSQL
  - cpan
  - cpanm
  - TheSchwartz
  - TheSchwartz::Worker
  - TheSchwartz::Simple
  - TheSchwartz::Simple::Job
published: true
books:
  - intermediate
author: dsdickinson
archive: true
---


Welcome to the second part of how to setup and use [TheSchwartz](https://metacpan.org/pod/TheSchwartz) Perl module.
In [part one](/use-theschwartz) of this tutorial, we covered how to setup the required database and write a script to insert a job for queueing.
In this continuation, we will finish things up by adding the worker scripts to process the jobs inserted into the database.
Finally we will create a service script to daemonize the runner that does the processing. This will give us a complete queueing system we can use and expand on for many different types of tasks.


## Overview
Once we are done with this lesson, we will have coded four seperate files for our queueing system.
<ol>
<li>Job insert script (send_email.pl)</li>
<li>Worker runner script (send_email_runner.pl)</li>
<li>Worker library (Worker/SendEmail.pm)</li>
<li>Daemon service script (send_email.service)</li>
</ol>

We have already coded the first file (send_email.pl) in part one of this lesson. In part two we will cover coding the above files 2, 3 and 4.

This is where everything will go on our system respectively from the list above:
```shell
/usr/local/bin/send_email.pl
/usr/local/bin/send_email_runner.pl
/usr/local/lib/Worker/SendEmail.pm
/etc/systemd/system/send_email.service
```

## Worker Runner Script
**/usr/local/bin/send_email_runner.pl**<br/>
This will be the script that constantly runs in the background to monitor our database for new jobs to process.
Later, we will daemonize this script to run as a service.

Here's what our worker runner script will look like:<br/>
{% include file="examples/use-theschwartz-2/send_email_runner.pl" %}

Note, the following lines at the top are important as it tells our script how to get to our library that houses the ever important work() function, which we will get to a bit later.
```perl
use lib "/usr/local/lib";
..
require Worker::SendEmail;
```
We assume you have the credentials squared away properly in the database with access to the schwartz database.
So as you can see we are connecting to the database so the script can query the available jobs that have been inserted into the database.
On the following line we are specifying which type of job we want to process. Here, we specify the "Worker::SendEmail" type of job from funcmap.funcname in the database.
```perl
$sclient->can_do("Worker::SendEmail");
```
So this script will only process those types of jobs.

Typically I like to also add logging to these processes to facilitate troubleshooting which is what is happening here.
```perl
my $log_file = "/var/tmp/send_email_runner.log";
open(LOG,">>$log_file") or die "Can not open $log_file!";
{ my $ofh = select LOG;
  $| = 1;
  select $ofh;
}
```
Next we create the infinite loop that will continue to check our database queue for jobs until the script is stopped.
```perl
$loopcount = 0;
$sleepint = 10;
if ($loopcount eq 0) {
    # main loop of program; goes forever, running jobs
    $sclient->work($sleepint);
} else {
    for (my $i = 0; $i <= $loopcount; $i++) {
        $sclient->work_once();
        sleep $sleepint;
    }
}
```
The sleepint value gives the work() function a seconds value to sleep before it looks at the queue again which you can adjust in case there are performance concerns.
Here we are specifing 10 seconds between checks. We've also added some flexibilty here for testing with the work_once() function.
If we set loopcount > 0 it will goto the else statement and then it will only get one job off the queue.

So how does it now what to do to when it hits the work() function? Well, that is another function we are going to code in a new and seperate library module we will be creating next.

## Worker Runner Script Library Module
**/usr/local/lib/Worker/SendEmail.pm**<br/>

This is where we will put our work() function. [TheSchwartz::Worker](https://metacpan.org/pod/TheSchwartz::Worker) page has some valuable information on using the
superclass as we will be doing in the below code.

Here's the full script:<br/>
{% include file="examples/use-theschwartz-2/lib/Worker/SendEmail.pm" %}

This is the work() function that the runner script will execute. At the top of the script you will notice four values we are setting for the worker:
```perl
sub grab_for { 120 };
sub max_retries { 30 };
sub retry_delay { 60 };
```
<i>grab_for</i> = Timeout value for the job. After this time expires and the job hasn't completed or failed it assumes it has crashed and becomes available for another worker.<br/>
<i>max_retries</i> = Number of times a worker should attempt to process any given job.<br/>
<i>retry_delay</i> = Number of seconds to wait to retry a failed job again.<br/><br/>
So in the above example, we will retry a failed job once a minute for half an hour, after which it will be permanently marked as failed and not attempted anymore.
Again, we have added logging which can be crucial for troubleshooting whats going on in these worker bees.
```perl
my $log_file = "/var/tmp/send_email_worker.log";
open(LOG,">>$log_file") or die "Can not open $log_file!";
{ my $ofh = select LOG;
  $| = 1;
  select $ofh;
}
```

As we enter the work(), you'll notice we are passing in the arguments data that the job holds from the database record.

```perl
   my $args = $job->arg;
```

Here's a database refresher of our data:

```shell
schwartz=# SELECT
j.jobid, fm.funcname, encode(j.arg,'escape') as "args", to_timestamp(j.insert_time) as insert_time, to_timestamp(j.run_after) as run_after
FROM
job j
INNER JOIN
funcmap fm ON (fm.funcid = j.funcid)
ORDER BY insert_time DESC;
 jobid |     funcname      |                        args                        |      insert_time       |       run_after
-------+-------------------+----------------------------------------------------+------------------------+------------------------
     9 | Worker::SendEmail | \x05    \x03\000\000\000\x04                      +| 2019-12-24 04:24:32-05 | 2019-12-24 04:24:42-05
       |                   | \x17I, am your father. -Dad\000\000\000\x04body   +|                        |
       |                   | \x1Cluke.skywalker@cloudcity.com\000\000\000\x02to+|                        |
       |                   | \x04Luke\000\000\000\x07subject                   +|                        |
       |                   | \x19darth.vader@cloudcity.com\000\000\000\x04from  |                        |
(1 row)
```

We are simplying grabbing those args values, setting them to some variables and checking that they are all there.
```perl
    my $from      = $args->{from} ||= 'noreply@someplace.com';
    my $to        = $args->{to};
    my $subject   = $args->{subject};
    my $body      = $args->{body};

    my @rqd_fields = qw(from to subject body);
    foreach my $rqd_field (@rqd_fields){
        if ( ! exists $args->{$rqd_field} || $args->{$rqd_field} eq ""){
            print LOG "Worker::SendEmail FAILED!  Missing required data!! (field: $rqd_field) \n";
            $job->permanent_failure( "Worker::SendEmail missing required field", 1 );
            return(1);
        }
    }
```

Finally, the script creates the email and sends it out via the sendmail command. I know there are much better ways of doing this using email perl modules
such as [Mail::Sendmail](https://metacpan.org/pod/Mail::Sendmail) but I wanted to keep things simple by not introducing any other modules.
```perl
    my $sendmail    = "/usr/sbin/sendmail -t";

    print LOG "sendmail: $sendmail\n";

    # Do not change the order of the headers.
    open(SENDMAIL, "|$sendmail") or die "Cannot open $sendmail: $!";
    print SENDMAIL "From: $from" . "\n";
    print SENDMAIL "To: $to" . "\n";
    print SENDMAIL "Subject: $subject " . "\n";
    print SENDMAIL "Content-type: text/plain" . "\n";
    print SENDMAIL $body;
    close (SENDMAIL);

    print LOG "All done!\n";

    $job->completed();
```

Once the email gets sent by the worker, the job is marked as completed in the 'exitstatus' table and the module automatically removes it from the 'job' table so it will not be run again.

```shell
schwartz=# select * from exitstatus;
 jobid | funcid | status | completion_time | delete_after
-------+--------+--------+-----------------+--------------
     9 |      4 |      0 |      1577179546 |   1577179547

schwartz=# select * from job;
 jobid | funcid | arg | uniqkey | insert_time | run_after | grabbed_until | priority | coalesce
-------+--------+-----+---------+-------------+-----------+---------------+----------+----------
(0 rows)
```

## Daemon Service
**/etc/systemd/system/send_email.service**<br/>
Now our final step will be to setup our worker runner to A) always run in the background and B) always startup when the system starts. To do this we will
need to create a new systemd service. This is fairly straight forward to accomplish.

Create the following file:<br/>
{% include file="examples/use-theschwartz-2/send_email.service" %}

Get the service up and running:
```shell
> sudo chmod 644 /etc/systemd/system/send_email.service
> sudo systemctl daemon-reload
> sudo systemctl start send_email.service
> sudo systemctl list-units -t service | grep send_email
  send_email.service                 loaded active running Service for send_email runner.
```

The output from the last command above means the service is up and running. And now we should have a fully functional queueuing system!
Each time the send_email.pl script runs it will add a job to the database queue and then the worker script will automatically grab it and process it accordingly.
Here is a flow chart to give a clearer picture of how the whole process works:

<div style="text-align:left"><a><img src="/img/use-theschwartz-2-chart.png" /></a></div>

## Conclusion
This concludes the tutorial for setting up a queueing system using TheSchwartz. It's a pretty good system that proves to be reliable. I have used it in
the past to run many different types of runners concurrently on the same system without fail. Enjoy and may TheSchwartz be with you!<br/><br/>

Related article: [How to Use TheSchwartz Perl Module (Part 1)](/use-theschwartz)

## Comments

Thank you for a detailed article. Especially nice the last part on how to put it up and running in Systemd￼. Much easier to understand than the module documentation at MetaCPAN.
This helped me to choose between TheSchwartz and Gearman. (Also the fact that Gearman uses a socket to communicate between client and worker, not the DB like TheSchwartz.)


