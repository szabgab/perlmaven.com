# `done_testing`

I am not a fan of it, but in rare cases it is useful to know that **done_testing** can be used to signal all tests have been done.  This way we don't need to have a "plan".

{% embed include file="src/examples/test-more/t/done_testing.t" %}

What happens if we have lots of tests and we would like to avoid running the later ones during development?
What if we add (enable) the line with the `exit` or the line with the `last` call?

* If we had a `plan` declared then the harness will notice you did not run the expected number of tests.

* If we had `no_plan` then Test::More will be happy that there were 3 successful calls to `ok` and won't notice that we did not run 1000 other test cases.

* If we only have `use Test::More;` at the top and then call `done_testing` to indicate we have reached the end of all the tests, this will report failure if we enable the line with the `exit`, but it will still be happy if we enabled the line with `last.

In other words, if you want to make sure all the tests run, then you need to set the plan.

OTOH Pytest does not have it.

