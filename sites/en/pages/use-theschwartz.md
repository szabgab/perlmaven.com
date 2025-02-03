---
title: "How To Use TheSchwartz Perl Module"
timestamp: 2018-03-28T20:00:00
description: "How to use TheSchwartz Perl module"
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


<a>TheSchwartz</a> Perl module is a very useful, powerful and sometimes funny queueing system.
It can be used for triggering all sort of events like sending email, running print jobs, and generating reports just to name a few.
Recently I used it in a project to send SMS messages via the Twilio SMS service in conjunction with its respective
[Twilio Perl module](http://search.cpan.org/~scottw/WWW-Twilio-API-0.18/lib/WWW/Twilio/API.pm). Typically, jobs such as these are triggered
by a user submitting a web request, which then inserts a schwartz job record into the database for processing.
But one of the best things about this module is actually using it, by typing "use TheSchwartz". A humourous nod to Spaceballs that's sheer genious.

TheSchwartz module contains several core functionalities to enable synchronous job processing.
The "job" function of the module consists of creating a database record that stores a job's function type and various argument values for future processing.
The "worker" function scans the jobs records table and executes a job record based on its function type and timing definitions.
Once a job is processed, the module marks it as completed or failed. Failure error messages are stored in the database for troubleshooting purposes. Once
a job has had its turn being processed, the system grabs the next available job and continues the processes.


## Advantages
There are many advantages to using this type of system over scheduling cron jobs. For instance, TheSchwartz has a mechanism for setting up
failure procedures. If the job fails to run it can automatically try again for a given number of cycles until it completes the job succesfully or the number
of pre-defined cycles run out. You can also dynamically pass in values to the job that the subsequent worker can then use to run the job in different ways.
Another interesting use case is to enable a user with limited priviledges to schedule a job that a higher priviledged user can pick up and execute in ways a
less priviledged user could not. A third advantage, and possibly its most useful, is web site efficiency. By scheduling processes to
run in the background, a user doesn't have to sit and wait for the subprocess to run. The possiblilties are really endless and very flexible.

## Overview
This will be a two part tutorial.
In part one of the tutorial we will discuss how to use TheSchwartz module to create a job, assign it values and then insert it into the database for later processing.
In part two of the discussion we will talk about coding the worker process that actually takes the job from its queue in the database and processes it.
We will then setup our completed program as a daemon service so it can startup automatically and run continuously.
Throughout this discussion and the examples, I will be using PostgreSQL database references and syntax.

## Install The Modules
There are several ways to [install the required perl modules](/how-to-install-a-perl-module-from-cpan) depending
on your preference. In this article we will use [cpanm](https://metacpan.org/pod/App::cpanminus).

To install the required modules using cpanm type the following (output edited for brevity):
```shell
[steve@blackbox:/home/steve]% sudo cpanm --install TheSchwartz
...
Building and testing TheSchwartz-1.12 ... OK
Successfully installed TheSchwartz-1.12
15 distributions installed
```

This process will also install all dependencies for TheSchwartz as well as its sub modules
[TheSchwartz::Worker](https://metacpan.org/pod/TheSchwartz::Worker) and
[TheSchwartz::Job](https://metacpan.org/pod/TheSchwartz::Worker), which
we will discuss later. To make interfacing with TheSchwartz module a bit easier we will be using
[TheSchwartz::Simple](https://metacpan.org/pod/TheSchwartz::Simple) modules in this tutorial.

So let's install that too by typing:
```shell
[steve@blackbox:/home/steve]% sudo cpanm --install TheSchwartz::Simple
--> Working on TheSchwartz::Simple
Fetching http://www.cpan.org/authors/id/M/MI/MIYAGAWA/TheSchwartz-Simple-0.05.tar.gz ... OK
Configuring TheSchwartz-Simple-0.05 ... OK
Building and testing TheSchwartz-Simple-0.05 ... OK
Successfully installed TheSchwartz-Simple-0.05
1 distribution installed
```

## Database Layout
Five database tables need to be setup manually for TheSchwartz to function. These
[ pre-defined sql statements](https://raw.githubusercontent.com/saymedia/TheSchwartz/master/doc/schema.sql) should be run first.
The PostgreSQL version can be found [here](https://github.com/saymedia/TheSchwartz/blob/master/doc/schema-postgres.sql). You can install
the required tables within an existing database you may already have available or you can make it its own database. For our purposes let's make it
a seperate database called schwartz. To install the tables, save the sql statements to a file called schwartz.sql and run these commands:

```shell
createdb schwartz
psql -U pgsql schwartz -f schwartz.sql
```

These sql statements create the job, funcmap, note, error and exitstatus tables.
The job table holds the [inserted job records](https://metacpan.org/pod/TheSchwartz#client-insert-job)
to be processed with its argument values. The funcmap table defines each type of job and
is linked to each job record. The error table holds any errors for a job that may occur during processing.
The exitstatus table temporarily keeps a record of a job's
[exit status](https://metacpan.org/pod/TheSchwartz::Job#job-exit_status) once the job has
finished processing. I have yet to figure out the purpose of the note table. Let me know if anyone else out there knows its use.

Here is what these new tables may look like with some sample data:
```shell
test_db=# select * from funcmap;
+--------+--------------------------------+
| funcid |            funcname            |
+--------+--------------------------------+
|      1 | Worker::Bee                    |

test_db=# select * from job;
+--------+--------+--------------------+---------+-------------+------------+---------------+----------+----------+
| jobid  | funcid |        arg         | uniqkey | insert_time | run_after  | grabbed_until | priority | coalesce |
+--------+--------+--------------------+---------+-------------+------------+---------------+----------+----------+
| 172928 |      1 | \x050a03000000030a |         |  1456700341 | 1456702200 |             0 |          |          |
+--------+--------+--------------------+---------+-------------+------------+---------------+----------+----------+

test_db=# select * from error;
+------------+--------+----------------------------------------------------------------------------------+--------+
| error_time | jobid  |                                message                                           | funcid |
+------------+--------+----------------------------------------------------------------------------------+--------+
| 1456311601 | 172928 | An error occurred here. /usr/local/bin/worker_bee.pm line 171.                   |     1  |
```

## Instantiating the Objects
We'll use [TheSchwartz::Simple](https://metacpan.org/pod/TheSchwartz::Simple) to establish our
schwartz object. As the name implies its a bit more simple to use. By using the TheSchwartz::Simple we can establish a schwartz object by using a
pre-defined DBI object that's probably already being passed around in your code. You can also do this by using the standard TheSchwartz module but
it's a bit more messy.

Here's how we create our client object:
```shell
my $client = TheSchwartz::Simple->new([ $dbh ]);
```

The second aspect of using TheSchwartz is creating a job to insert into our database for processing. To do this we will use the
[TheSchwartz::Simple::Job](https://metacpan.org/pod/TheSchwartz::Simple) module, which, as you may have
guessed, is also simple and also comes with TheSchwartz::Simple module.

To create the job object, we use the following code:
```shell
my $job    = TheSchwartz::Simple::Job->new;
```

Now we need to define our job. When we do that, we will be giving the job specific argument values that can be used by the worker during job processing.

```shell
$job->funcname("Worker::SendEmail");
$job->arg({
    from    => "darth.vader@cloudcity.com",
    to      => "luke.skywalker@cloudcity.com",
    subject => "Luke",
    body    => "I, am your father. -Dad",
});
```

We are doing two things here. First the <i>funcname</i> specifies the value to be used to identify the type of job it is in the funcmap table of the database.
The first time a job is inserted into the database with this assigned funcname, a new row will be added to the funcmap table with that value in the funcname
column. The funcid from that row in the funcmap table will be assigned to the job record.

## Creating Our First Job
We have discussed the basics for creating a job to put into our database. Let's put it all together into a more structured program.

{% include file="examples/use-theschwartz/send_email.pl" %}

The first thing we want to make sure of is that the $client and $job objects have been instantiated successfully. If either fail to be created
the code does not proceed and tells us about the failure. After we setup the $job object values as discussed previously, we also assigned it a run_after value.
The run_after value sets the time we want to run our job. Here we specify now + 10 seconds, which means that ten seconds from now the job becomes available for
processing. The last thing we do is insert the job into the database for processing and check to make sure that it gets inserted successfully.

## Run The Code
Let's run our new code:
```shell
[steve@blackbox:/home/steve]% ./send_email.pl
Record added to jobs table successfully.
```

Ok, let's see what just happened in the database.

```shell
test_db=# select * from funcmap;
+--------+--------------------------------+
| funcid |            funcname            |
+--------+--------------------------------+
|      1 | Worker::SendEmail              |

test_db=# select * from job;
 jobid | funcid |                                                                                                                                arg                                                                                                                                 | uniqkey | insert_time | run_after  | grabbed_until | priority | coalesce
-------+--------+--------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------+---------+-------------+------------+---------------+----------+----------
     1 |      1 | \x050a03000000040a17492c20616d20796f7572206661746865722e202d44616400000004626f64790a1964617274682e766164657240636c6f7564636974792e636f6d0000000466726f6d0a1c6c756b652e736b7977616c6b657240636c6f7564636974792e636f6d00000002746f0a044c756b65000000077375626a656374 |         |  1458448992 | 1458449002 |             0 |          |
```

First we notice a new func type has been added to the funcmap table. This will be linked to our new job.
Noticeably, the job record values are a little daunting to look at. Let's make it more human readable with another more complex but more helpful query.

```shell
test_db=# SELECT
test_db-# j.jobid, fm.funcname, encode(j.arg,'escape') as "args", to_timestamp(j.insert_time) as insert_time, to_timestamp(j.run_after) as run_after
test_db-# FROM
test_db-# job j
test_db-# INNER JOIN
test_db-# funcmap fm ON (fm.funcid = j.funcid)
test_db-# ORDER BY insert_time DESC;
 jobid |    funcname       |                               args                                |      insert_time       |       run_after
-------+-------------------+-------------------------------------------------------------------+------------------------+------------------------
     1 | Worker::SendEmail | \x05                                                             +| 2016-03-20 00:43:12-04 | 2016-03-20 00:43:22-04
       |                   | \x03\000\000\000\x04                                             +|                        |
       |                   | \x17I, am your father. -Dad\000\000\000\x04body                  +|                        |
       |                   | \x19darth.vader@cloudcity.com\000\000\000\x04from                +|                        |
       |                   | \x1Cluke.skywalker@cloudcity.com\000\000\000\x02to               +|                        |
       |                   | \x04Luke\000\000\000\x07subject                                   |                        |
(1 row)
```

Here we get the actual funcname instead of its id. And the args value has been decoded by escaping the data into a more readable text format.
You'll also notice the difference between the insert_time and run_after time is 10 seconds. Since we specified our run_after time to be now + 10 seconds,
that is what gets reflected here.

Now our job is ready and waiting for the worker process to pick it up for processing.

## Conclusion
This concludes part one of the tutorial. So far we have covered how to create a basic job using TheSchwartz::Simple. Next, we will work on coding the
worker process that actually processes our job. And then finally, we will set it all up to run automatically as a daemon system service.

Continue reading [How to Use TheSchwartz Perl Module (Part 2)](/use-theschwartz-2).


For further reading here is another short article on TheSchwartz by Gavin Carr:
[Notes on TheSchwartz](http://www.openfusion.net/web/theschwartz)


## Comments

When will the followup article be posted? I just started looking into using TheSchwartz and your article is great!

Originally this article was a paid guest-post that was accessible to the paying subscribers. In the end I could not make the whole process work financially well for both the authors and myself so there were only a few paid articles. Nevertheless I am sending a note to Steve asking him.

Thanks for the update, fingers crossed!

<hr>

Randal L. Schwartz:
It is someone odd that I have not found a use for this module in some client code. :)

<hr>

You used TheSchwartz::Simple to make it easier to access TheSchwarz.
What do you think about TheSchwartz::Moosified?


