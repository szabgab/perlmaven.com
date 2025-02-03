---
title: "Forking, Process ID, Parent Process ID, init"
timestamp: 2021-03-22T07:30:01
tags:
  - fork
  - $$
  - getppid
published: true
author: szabgab
archive: true
---


The init-system for Linux went through several iterations.
The article [Initializing and Managing Services in Linux: Past, Present and Future](https://www.linuxjournal.com/content/initializing-and-managing-services-linux-past-present-and-future) explains it quite well.

In this example we'll see how can we see the process ID and parent process ID of a forked process in Perl, and what happens
if the parent process exits before the forked process.


## The code we use

{% include file="examples/orphaned.pl" %}

Run the following commands in a Linux terminal:

```
echo $$
perl orphaned.pl
```

```
5209

In Main: PID: 5378 PPID: 5209
5379
In Child: PID: 5379 PPID: 5378
In Parent: PID: 5378 PPID: 5209
In Child: PID: 5379 PPID: 1
```

## echo $$

The first command is still a shell command. In the shell the `$$` variable contains the process ID
of the current shell. It was 5209 when I ran this.

## Perl PID and PPID

In Perl too the variable `$$` contains the process ID of the current process.
In addition the `getppid()` function returns the process ID of the parent process.
If you run a script from a Linux terminal then this will be the shell process
running in that terminal.

So in the first output line of our Perl script we see that the current process ID is 5378 (this is the perl process)
and the PID of the parent process (sometimes called PPID) is 5209. That is the PID of the shell where we ran
our program.

## Forking script

Using the [fork](/search/fork) system call Perl can duplicate a process and from that point there
will be two almost identical copies of the original process. The difference is that the new process that was
spawned will get a new PID. In this copy of the process the `fork` function will return 0 so in our code
the internal `$pid` variable will be 0. This process is usually called the child-process.

The original process will retain its PID and here `fork` will return the PID of the newly created child-process.
In our example this is 5379.

The calls to `sleep` are there to ensure the order of the printing and to make sure that the first time we print from the child process the parent is still around and when the child prints again the parent is already gone.

The first time the child process prints `In Child: PID: 5379 PPID: 5378` it shows its own PID 5379 which is the same number the parent received from `fork` and the process ID of its parent. 5378 which is the PID of the main process.
Then it goes to sleep and let's the parent process print `In Parent: PID: 5378 PPID: 5209` and then exits.

Finally, when the child process prints again `In Child: PID: 5379 PPID: 1` it original parent is gone so now
it prints 1 as the PID of the parent process. That it, the `init` process became the parent of this orphaned process.





