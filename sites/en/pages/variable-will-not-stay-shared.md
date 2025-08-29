---
title: Variable "..." will not stay shared ...
timestamp: 2021-12-20T09:30:01
tags:
  - fork
  - $!
  - $$
published: true
author: szabgab
archive: true
show_related: true
---


When using **fork** to create child processes it is a good idea to encapsulate the behavior of both the child process
and the parent process in (separate) functions.


Perl allows you to define functions inside functions and those internal function will inherit the variables defined in the
external function. That can be good solution in some cases, but when forking one has to remember that the inherited
variables will be copied over to the child-process and will be separated from the original variable. Updating in one process
will **not** be reflected in the other process.

If someone creates such variable Perl will warn that the **variable will not stay shared**.

## Fork with inherited variables

In this example we see the **child_process** and the **parent_process** are defined inside the <b>main</b> function.
They both inherit the **$child_pid** and one might assume - incorrectly - that it is the same variable in both processes.

{% include file="examples/fork_inherited_variables.pl" %}

Running this code will warn that they are not the same:

```
$ perl examples/fork_inherited_variables.pl

Variable "$child_pid" will not stay shared at examples/fork_inherited_variables.pl line 19.
Variable "$child_pid" will not stay shared at examples/fork_inherited_variables.pl line 29.
This is the child process.
PID of the child  process itself: 48517
PID received in child:  0
This is the child process.
....................................
$finished is now 48517
This is in the parent process.
PID of the parent process that spawned the child: 48516
PID of child seen from parent: 48517
```


One way to see that they are really separate variables is to assign a value to the **$child_pid**
variable in one of the functions and add a **sleep** to the other function so the other function
will print the content of **$child_pid** after the assignment. You'll see that the assignment in
one function does not have any impact on the variable in the other function. They are not shared.


## Passing variables to functions

A better solution would be to define the functions outside the **main** function.
That alone won't work as now the **$child_pid** won't exist in the functions.
You'll have to pass it as a parameter to each one of the functions.
That will silence the warning of Perl and hopefully will make it clear that the variables were separated.

{% include file="examples/fork_passing_variables.pl" %}

The result is now clean:

```
$ perl examples/fork_passing_variables.pl
This is the child process.
PID of the child  process itself: 48600
PID received in child:  0
This is the child process.
....................................
$finished is now 48600
This is in the parent process.
PID of the parent process that spawned the child: 48599
PID of child seen from parent: 48600
....................................
```

## Sharing variables

When using **fork** none of the variables will remain shared. For that you need to use threading which does not work too well in Perl.

There are ways to exchanged data between parent and child processes, but the most common way is to pass every value to the child process
when it is created and then let the child send back data when it is done. **Parallel::ForkManager** implements this.
See the the example on [passing data back from forked process](/speed-up-calculation-by-running-in-parallel).

