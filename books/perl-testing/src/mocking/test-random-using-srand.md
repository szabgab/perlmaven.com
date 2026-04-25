# Test using `srand` (seed)

Using the [srand](https://perldoc.perl.org/functions/srand) function we can set the location of the [rand](https://perldoc.perl.org/functions/rand) pseudo-random generator.
That will fix the random numbers.

Using this tactic we will probably have to run the code once with a certain seed, observe the result and then fix it as the expected result for future runs with the same seed.

The nice thing about this is that it will generate an infinite number of random values with the need for you ro prepare them.

{% embed include file="src/examples/mock-random/t/test-with-seed.t" %}

```
prove -lv t/test-with-seed.t
```

