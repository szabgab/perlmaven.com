# TODO

When you don't want to see the failing tests any more.

What if a bug was reported. You wrote a test to reproduce it, but due to other priorities you don't have time to fix the code.You don't want to throw away the test case, but also you should not add a failing test. That would make the CI fail. People would have to learn that this failure is ok. However if at this time some other tests start to fail you'd have a good chance of not noticing it.

The CI should never keep failing. If it fails it should be fixed immediately or it will quickly lose its value.

What can we do?

We can mark the test to be a `TODO`-test which is expected to fail. (Pytest calls it xfail.)

{% embed include file="src/examples/test-more/t/34.t" %}

Running it with prove it will fail the whole test.

```
$ prove -l t/34.t
```

{% embed include file="src/examples/test-more/t/34.t.prove.out" %}


