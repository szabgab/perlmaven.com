# Plain function


{% embed include file="src/examples/plain_area.pl" %}

* We have `use feature 'say';` to add the `say` function without enabling any other feature. Nothing is reported.
* We can turn on `use strict;` and `use warnings;`. The latter will generate a warning.
* Alternatively it is enough to write `use v5.44;` and it turn on all the feautes.
