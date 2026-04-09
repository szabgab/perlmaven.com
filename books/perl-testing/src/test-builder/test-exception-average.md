# Test::Exception average

We have a function to calculate the average of the given numbers.

If we are not careful, the user might call it with an empty list of values.
In that case we would try to divide by 0. That would result in an "Illegal division by zero" exception.

That can be confusing. It would be much better to tell the user parameters were missing.

{% embed include file="src/examples/average/lib/MyMath.pm" %}
{% embed include file="src/examples/average/average.pl" %}
{% embed include file="src/examples/average/t/average.t" %}

