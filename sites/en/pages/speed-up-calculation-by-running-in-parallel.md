---
title: "Speed up calculation by running in parallel"
timestamp: 2016-07-12T08:30:01
tags:
  - Parallel::ForkManager
  - fork
published: true
author: szabgab
archive: true
---


In this example we have a bunch of numbers. We need to make some heavy calculation on each number (using our `calc` function),
and then collect the results in a hash where the keys are the original numbers and the values are the results.


For the sake of our example the "heavy computation" is generating and summing up lots of random numbers.

## The linear solution

This is quite simple to do in linear code. We just need to iterate over the elements of the original array that holds the
input numbers and call the `calc` function on each one of them. When the function is done it returns the result that we
can then assign to the appropriate element in the hash.

{% include file="examples/calc_no_fork.pl" %}

(If it is unclear what is in the `@numbers` array and how it is generated then use the `Dumper` function
to print the content of `@numbers` right after it was created and read about
[map in Perl](/transforming-a-perl-array-using-map).

We can run this code using the `time` program of the Unix/Linux shell:

```
$ time perl calc_no_fork.pl
```

The result on my computer was:

```
real    0m21.032s
```

It took 21 seconds to do all the calculations.

While the program was running I've also used the `htop` program in another console and saw that none of the 4 cores of
my computer is fully used.

<img src="/img/calc_no_fork.png" title="CPU load when running linear">

I think the reason that none of them is fully used is that the operating system moves the process around form CPU to CPU, but I am not 100% sure in this.

## Using fork

In order to allow the computer to better utilize all its resources we could use either `threads` or [fork](/fork).
As `threads` are [not a recommended technique in Perl](https://metacpan.org/pod/threads#WARNING) we opt to use `fork` as described in the article on
[Using fork to spread load to multiple cores](https://perlmaven.com/fork). The problem, as it is also mentioned at the end of
that article is that forked processes don't have shared memory, so the forked process cannot simple write back to the common `%results`
hash. That's where the module [Parallel::ForkManager](https://metacpan.org/pod/Parallel::ForkManager) comes into play.

It is a wrapper around the regular `fork` function of Perl that provides us with various nice extra services. Including the
possibility to return data from the child processes to the parent process that launched them.

{% include file="examples/calc_fork_manager.pl" %}

The code starts with the creation of the Parallel::ForkManager object and setting the maximum number of parallel child processes.

```
my $pm = Parallel::ForkManager->new($forks);
```

Then we create an anonymous function (a `sub` without a name) and pass it to the `run_on_finish` method of Parallel::ForkManager.
This function will be called once for each child process immediately as the child process terminates. It receives a number of parameters, but the
one that is interesting to us now is the 6th, the last parameter which we assigned to the `$data_structure_reference` variable.

This variable will hold everything we sent back from the child process. In our case that will be a hash reference with two keys. "input" will
contain the value from the original `@numbers` array the specific child process is dealing with. The "result" will contain the value
returned by the `calc()` function.

```
$pm->run_on_finish( sub {
    my ($pid, $exit_code, $ident, $exit_signal, $core_dump, $data_structure_reference) = @_;
    my $q = $data_structure_reference->{input};
    $results{$q} = $data_structure_reference->{result};
});
```

Then comes the main part of the code.

We have a simple `foreach` loop iterating over the `@numbers` array.
For each iteration we call `my $pid = $pm->start and next;` This will try to create
a new fork. 
If it is successful then at this point two processes will continue to run almost exactly the same way:
the value returned by the `start` method is assigned to `$pid`.
There is however a small difference in the two processes.

In the <b>parent process</b>, this value is going to be the process ID of the child process, a non-zero number,
and therefore the right-hand side of the `and` boolean operator
will be evaluated and the main process will go to the `next` iteration of the `foreach` loop.

In the <b>child process</b> the value returned by `start` will be 0. Which is false. Which means the right-hand side
of the `and` operator will not be executed. In the child process the next evaluated statement will be the
`calc($q);`. While the child process is calculating using one of the CPUs of the computer,
the main process can run using the other CPU and it can create more child-processes.

The Parallel::Forkmanager will also count how many child processes have been forked and if we reach the value passed to the `new`
constructor then the `start` command will wait till one of the earlier child-processes finishes and will only fork a new
child-process after that.

In the meantime all the child processes are running on one of the CPUs of the computer. When one of them finishes the `calc` function
it will call the `finish` method of Parallel::Forkmanager and it will pass to it two values. The first one is the exit code it
wishes to have. 0 means success. The second one is a reference to a data structure it wishes to send back to the main process.
This is the data structure we have used in the anonymous subroutine in `$data_structure_reference`.

```
foreach my $q (@numbers) {
    my $pid = $pm->start and next;
    my $res = calc($q);
    $pm->finish(0, { result => $res, input => $q });
}
$pm->wait_all_children;
```

The call to `wait_all_children` makes sure that the parent process will indeed wait till all the processes it created have finished
and will only continue running once that happened and once it had a chance to run the respective `run_on_finish` function.


We can run this script as

```
time perl ~/work/perlmaven.com/examples/calc_fork_manager.pl 8
```

The result is about twice as fast as the linear version:

```
real    0m11.138s
```

At the same time `htop` shows that all the CPUs are saturated.

<img src="/img/calc_fork_manager.png" title="CPU load when running with Parallel::ForkManager">


In some other measurements I've seen a 3-time speedup, but I think you can't expect anything better with a 4-core machine.
After all there are many other tasks running in the system, so we don't really have 4 times more free CPU power than
earlier, and the whole forking and managing the communication has some overhead.


## Combined example

Just in case you'd like to tweak the calc() function and would like to further experiment with this code,
I've included a version of the two scripts combined together. If you run it without any parameter
it will run the linear version. If you run it with any positive number, it will use that many parallel child processes.

{% include file="examples/calc_fork_manager_full.pl" %}

BTW, the "DATA_LOOP" in this example is not really needed, it only tries to make the code a bit more readable.

## Comments

Dear Gabor, can this also work on Windows???

Obviously not, but it can be written and debugged on it by using zero as the max number of child-processes passed to "new()".

What is the $exit_signal on the "run_on_finish" arguments list, what does it signify, what sets it and what is it used for?

The only reference to it on the CPAN doc is "(0-127: signal name)" which is rather cryptic...

----

I don't know.

<hr>

Hi Gabor,

Thanks for the great article. Very helpful.
I don't understand, however, the difference between these:
---
for my $q (@numbers) {
$pm->start and next;
...
}
---

DATA_LOOP:
for my $q (@numbers) {
$pm->start and next DATA_LOOP;
..
}
To me, it looks like when you add the LABEL you are calling the entire 'for' loop again for each child, rather than creating one child per 'for' iteration...
I've seen this done elsewhere too...but I cannot find any explanation.
Can you please explain when and why to add the LABEL to the forking construct?
Thanks,
Steve.

---

Never mind...I found the answer :)
A LABEL is a way to identify which loop so you can jump to the next iteration in a 'higher' loop than the one you are in.
Useful with nested loops.

---
Correct

<hr>

I tested the program using fork. The results vary with the change of N. I understand that the error cannot be avoid. However, some errors look bigger. Is it possible to control the error? Below is the test results:
[lwang@bustard download]$ time test.pl 8
Forking up to 8 at a time
$VAR1 = {
'2000000' => '2009997.75109997',
'14000000' => '14069999.767691',
'10000000' => '10049994.6817341',
'8000000' => '8040000.10614982',
'18000000' => '18089998.8101834',
'16000000' => '16079994.0340922',
'4000000' => '4019995.67857078',
'20000000' => '20100008.2442531',
'6000000' => '6029996.56460236',
'12000000' => '12059994.2682348'
};

real 0m3.141s
user 0m15.190s
sys 0m0.047s
[lwang@bustard download]$ time test.pl 4
Forking up to 4 at a time
$VAR1 = {
'2000000' => '2009996.17732622',
'10000000' => '10049989.9027839',
'14000000' => '14069992.8959136',
'8000000' => '8039992.48831927',
'18000000' => '18089995.5504226',
'16000000' => '16079990.5352963',
'4000000' => '4019991.95067143',
'20000000' => '20099996.6519283',
'6000000' => '6029997.00456926',
'12000000' => '12059991.4371894'
};

real 0m5.145s
user 0m14.759s
sys 0m0.041s
