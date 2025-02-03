---
title: "Select random elements from a weighted list"
timestamp: 2015-02-11T12:00:01
tags:
  - rand
published: true
author: szabgab
archive: true
---


Given a list of items `my @items = qw(low mid high)` and a series of weights: `@weights = (10, 100, 1000)`
how can we pick one (or more) items with the probability corresponding to their weight?

That would mean that 10 out of 1110 should be the chance of "low" to be selected.


This script will do it for use:

{% include file="examples/weighted.pl" %}


How does this work. Basically we assume that we have an array containing 10+100+1000 elements:

10 elements of "low", then 100 elements of "mid" and finally 1000 elements of "high"

`("low") x 10, ("mid") x 100, ("high") x 1000`


The total number of elements is 1110 calculated using `my $total = sum @weights;`.

Then we select a whole number between 0 and $total (0 can be, but $total cannot be)
using `my $rand = int rand $total;`.

Then we need to find in which section does this number fall.

We go over the items, `$selected` contains the index of the current item,
and check if the random number in `$rand` is lower than then upper limit of this section.
the first section of the value "low" are the numbers 0..9. We put
`my $limit = $weights[$selected];` which is 10.
So if `$rand >= $limit` then we know the random number is not within the limit.
We then go to the next item `$selected++;` and increase the limit by the number
of elements in the next section: `$limit += $weights[$selected];`

Once we find the section where the random number falls, the `while` look will end.

The above code can be used if you want to select one value, or if you want to select many
values "with replacement". That is, after we selected one of the items,
we put it back in the pool. Meaning the weights don't change between call.


## Sampling without replacement

If the weights were all the same then the "without replacement" would be really clear. It would mean an item that was selected once
is removed from the selection pool and it cannot be selected again.

Having different weights makes this a bit less clear, but "without replacement" here means that once we selected one
item, the weight of that item is reduced by one. Just as if we had `$total` number of items and after we selected one
we are left with `$total-1` items.

This script would do that for us:

{% include file="examples/weighted_no_replacement.pl" %}

There are two changes from the previous script.

One is that we now have a `foreach` loop to generate more than one random values. That could have been used in the
previous example as well, if we wanted more than one items.

The other change, the one that makes the difference between with and without replacement, is the last line
`$weights[$selected]--;` where we adjust the weight.

## Math::Random::Discrete

As Nick Wellnhofer pointed out, an even better solution would be to use
[Math::Random::Discrete](https://metacpan.org/pod/Math::Random::Discrete) that uses
some magic algorithm (aka. [Walker's alias method](http://en.wikipedia.org/wiki/Alias_method))
to make the random value generation more efficient.

As I understand it has some initial longer processing and only then will it be more efficient, so I am not
sure it is the right solution for my current needs, but nevertheless, let's see the solution:

{% include file="examples/math_random_discrete.pl" %}


