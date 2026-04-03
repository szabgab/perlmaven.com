# Fake test coverage

In this example we have a very simple module with two simple functions.

{% embed include file="src/examples/mutation/lib/MyMath.pm" %}

We have two tests. The `multiply` test check one case for which the `multiply` function happens to return the correct value. In the case of the `add` function we call the function, but for some reason we don't compare the resuls.

{% embed include file="src/examples/mutation/t/test.t" %}

We can generate the test coverage report using Devel::Cover and it will
report 100% test coverage.

```
$ perl Makefile.PL
$ cover -test

------------------ ------ ------ ------ ------ ------ ------ ------
File                 stmt   bran   cond    sub    pod   time  total
------------------ ------ ------ ------ ------ ------ ------ ------
blib/lib/MyMath.pm  100.0    n/a    n/a  100.0    0.0  100.0   85.7
Total               100.0    n/a    n/a  100.0    0.0  100.0   85.7
------------------ ------ ------ ------ ------ ------ ------ ------
```

{% embed include file="src/examples/mutation/Makefile.PL" %}



