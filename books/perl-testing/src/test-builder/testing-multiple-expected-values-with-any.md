# Multiple expected values revised

We are going to use the `any` function of [List::MoreUtils](https://metacpan.org/pod/List::MoreUtils).

{% embed include file="src/examples/test-perl/t/dice_any.t" %}

Output:

{% embed include file="src/examples/test-perl/t/dice_any.out" %}


This shows that there is some problem but we still don't know what exactly is the problem.
Especially think if this is part of a larger test suite when one of the tests fail.
We would like to see the actual value and maybe even the expected values.



