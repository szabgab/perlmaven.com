---
title: "Using a queue in Perl"
timestamp: 2013-05-19T20:30:01
tags:
  - push
  - shift
  - queue
  - array
  - last
  - FIFO
published: true
books:
  - beginner
author: szabgab
---


There are various applications where processing a queue is useful.

For example you need to process a deep directory structure where each
directory can contain subdirectories.

Maybe you manage a build systems where each unit has a list
of prerequisites and you need to traverse the whole dependency tree.

If I want to give a less painful example, you write an interactive application
that will handle people who need treatment at the dentist.

In either of these cases a queue can work really nicely.


## What is a queue?

A queue is basically a list of items. When new items arrive they are added to the end of the list.
When the queue "goes forward", the first item in the list is removed and all the other items "move forward".

There are various standard data structures described in computer sciences. The abstract description
of a queue is [FIFO - First In First Out](http://en.wikipedia.org/wiki/FIFO).
The first who arrived in to the queue will be the first to leave it.

In Perl, a regular array using the `push` and `shift` functions can be used to implement a queue.
If you need a reminder about those functions check out the [article about push and shift](/manipulating-perl-arrays).

Let's see an example:

{% include file="examples/queue.pl" %}

Here we use the `@people` array to hold the queue. It starts out with two elements.
Then the whole queue processing is inside the [while loop](/while-loop).
That loop will run as long as there are names in the queue.

In case you wonder, in the condition of the `while ()` loop,
the array finds itself in [scalar context](/scalar-and-list-context-in-perl)
in which case the array returns its size, the number of elements it holds.
If the array is empty this will be 0 which is [false](/boolean-values-in-perl).
If there are elements in the array the size is a positive integer which is considered
[true](/boolean-values-in-perl) in Perl.

As the first thing inside the loop, we fetch the first element from the queue using the
`shift` function. This is the next person to be treated by the dentist.
The next thing we should call is `treat($next_person);` but for now we just print the name.

Once the treatment is over we can check if there are more people waiting to be added to the queue.
We implemented this in another `while` loop. We wait for the user to type in names one-by-one.
We remove the trailing newline, and then check if the input was empty or not. If it was empty,
meaning the user pressed ENTER without typing in any name, we call `last`.
That will terminate the internal while loop and reach the `print "\n";` line.
Then Perl will go back to the beginning of the main `while-loop` treating the next person.
If the user typed in a name, that name will be **pushed** to the end of the `@people` array.
To the end of the queue. Then, still in the internal loop, we wait for another name to be typed in.

As long as there are more people arriving than we can treat, the queue will grow. If for a while
no new people arrive, the process will slowly deal with all the people in the queue.
At one point the array will become empty and the main while-loop will finish.

## Abstract implementation

The following code is a more abstract version of the same code using
[functions](/subroutines-and-functions-in-perl)
that we have not implemented here.

{% include file="examples/queue_abstract.pl" %}

## Parallel or Asynchronous processing

The above implementation can work in simple cases, but it has a major problem.
Both the `accept_new_to_queue()` and the `handle_item()` are blocking.
That is, while you are handling an item, no other items can be added to the queue
and while waiting for someone to be added to the queue, no item can be handled.

This can be acceptable when processing a directory tree or a list of dependencies,
but people would be upset at the dentist if they could not even enter the waiting room
while one of the patients is receiving treatment.

For this you need some way of parallel or asynchronous processing so the
`accept_new_to_queue()` and the `handle_item` can be run **"virtually at the same time"**.
I wrote virtually as they don't necessarily need to run in parallel. We just need to perceive it as if they did.

If you have multiple CPUs or at least multiple cores, which is the case in all modern computer,
you could theoretically run parts of the code really at the same time. The two major solutions
for this is **threading** and **forking**. While in many languages threading
is the preferred way, in Perl most people will use forking.
If you go that way, you should probably take a look at the 
[Parallel::ForkManager](https://metacpan.org/pod/Parallel::ForkManager)
module on CPAN.

For asynchronous or even-driven Perl programming, you might want to take a look
at [POE](https://metacpan.org/pod/POE).

We will see examples for both cases in other articles.


