---
title: "Process status in SQLite"
timestamp: 2017-08-17T10:00:01
tags:
  - DBD::SQLite
  - selectrow_array
  - last_insert_id
  - PRIMARY KEY
published: true
author: szabgab
archive: true
---


In our home made Continuous Integration system we wanted to make sure there is only one process is running at a time and we also wanted
to be able to show the status of the currently running process. First, when we only wanted to have the 1 process at a time limitation
we used a file locking mechanism, but adding the status seemed to be difficult. Switching to SQLite make the solution rather
easy and also gives us many more opportunities.

In this example you'll see the implementation.


## The algorithm

In our SQLite database we have a single table. In that table we have a single row for the process that is currently running,
but we also leave that row in once the process has finished. This allows us to look at the history of the processes and their
results.

When the process starts to run it checks the database if there is already a row indicating a running process.
If there is no running process it inserts a new row, marks it as "running" and then starts doing the actual work.
When it finishes its work it updates the record changing the `status` field from 'running' to either 'success' or 'failure'.

If the newly started process sees that there is already an entry in the database with `status` 'running' then it quits.
Actually before it quits, it checks when did the other process start and if it has been running for "too long" it reports the issue.

## The code

{% include file="examples/process_status_with_sqlite.pl" %}

## Explanation

There is some extra code in this script to make it easy for you to try it.
As there is no "real processing" here, we are using a simple call to `sleep` to make the script spend some time.
On the command line you can supply a number indicating the length of this `sleep`, and a string that will become
the final status of the current process.
If not supplied the default `sleep` time will be a random number between 0-60 and the default end-status will
be either 'success' or 'failure' selected randomly.

The `$TIMEOUT` variable holds the number of seconds we think should be enough for any normal processing to be finished.
This is the expected maximum elapsed time after which the new process will report about an old process that it might be stuck.

Before we connect to the database we check if the database file exists or not. If not we set the `$new_db` to `true`
so once we "connected" to the database we know we still need to create the table.

The nice thing about SQLite is that we don't need any administration to set up a new database and to create tables in it.
We just need to "connect" to a file and issue a `CREATE TABLE` SQL command.

### Check existing process

Then we use the `selectrow_array` method of the Database Handle to fetch the row with the `status` 'running'.
If the call returned values including the `$timestamp` then we know there was such a row which means there is 
a process running. We "report" this by printing to the screen and then we check how long has this process been running.
If this was longer than our expected maximum number which was placed in the `$TIMEOUT` variable then we should really
report the problem. In the real program we have some code to [send e-mail](/sending-html-email-using-email-stuffer),
but in this sample I just put in a line to print some warning.

Eventually, if there was a process already running we call `exit`.

If we were more daring we could add code to kill the other process, update the `status` in database row to 'failed' and
go on to the real processing, but at this point we wanted to be a bit more conservative.

### Inserting information about the process

Then we have an `INSERT` statement. We save the `$start_time`, and the Process ID of the current process
(it can be found in `$$`, and we set the `status` to 'running'.

Because we are using numeric `PRIMARY KEY` SQLIte will insert a number there which is one higher than the previously inserted value.
SQLite also provides a method called `last_insert_id` that can be used to retrieve the `id` field of the currently inserted row.
This gives use the unique ID of this row. (Actually we could have used the process ID for this as it is unique as well.

## Update the database when the process is finished

Then, instead of doing some real work we just call `sleep` to fake it for the purpose of our example.

After the work (aka. sleep) is over we update the database. We set the status to whatever the work returned (that we fake by allowing
the user of this script to supply on the command line). We save the elapsed time. We do that only because later in our reporting
we would like to show this information. Finally we set the `pid` field that was holding the process ID to `undef` that
will be inserted into the database as `NULL`. After all once the process is finished this process id might be reused by
some other process so I think keeping it in the database would just create confusion.

### Dumping the database

Finally, at the end of the script, there is a line to dump the whole content of the database. I've added it just to make
it easy to see what is the content of the table after the process has finished.

## Improvement

I am sure there are many thing to be improved in this script, but it is already a working solution. Someone might complain that
this is not fool-proof an that if we launch two processes at the same time it might happen that both will fetch the 'running' line
before either of them could have a chance inserting its own and if there is no 3rd process running then both will think it their turn.
This is true, but we launch the process from a cron-job once every minute and so we don't consider this an issue.

## Comments

To fix the race condition you mention, you could have the primary key of the running process be 0, and try to do an insert with that id. If it works, you're the runner, if not, there's a process already running. When the process finishes it would do a

INSERT INTO processes (timestamp, status, pid)
    SELECT timestamp, 'endstatus', ...
    FROM processes WHERE id=0;
DELETE FROM processes WHERE id=0;

