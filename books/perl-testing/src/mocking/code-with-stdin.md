# Code with STDIN

This function gets some value from the Standard Input and then returns a value based on that. We need to fake data on the STDIN.


{% embed include file="src/examples/mock-stdin/lib/MyEcho.pm" %}

{% embed include file="src/examples/mock-stdin/bin/echo.pl" %}

```
perl -Ilib bin/echo.pl
```


