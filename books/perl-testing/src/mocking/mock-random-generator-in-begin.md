# Manual mock random generator in BEGIN block

Through the `CORE` namespace we can replace the `rand` function to our implementation.

In this implementation we prepare 2 values to be returned when the `rand` function is called **anywhere** in the process.
That means both in the `dice` function and elsewhere. So our manual mocking has a global impact. It is usable, but maybe not ideal.

We need to do it in the `BEGIN` block **before** we `use` the `MyRandomApp` so it will take effect there.

{% embed include file="src/examples/mock-random/t/test-begin.t" %}

```
prove -lv t/test-begin.t
```

