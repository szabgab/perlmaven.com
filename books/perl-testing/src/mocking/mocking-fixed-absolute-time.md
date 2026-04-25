# Mocking fixed absolute time


The [Test::MockTime](https://metacpan.org/pod/Test::MockTime) module has a number of ways to change the time:

* We can `set_absolute_time` to any time, but after the setting the clock will move forward at its regular pace.
* We can `set_fixed_time` to any time and the clock will not move forward.

These are useful when testing the behaviour of some code at a specific given date or time.

* We can `set_relative_time` for things where the elapsed time is important. e.g. checking a timeout mechanism.

{% embed include file="src/examples/mock-time/t/daily.t" %}

