---
title: "Partially hide data fields"
timestamp: 2020-04-21T07:30:01
tags:
  - regex
published: true
author: szabgab
archive: true
---


On a web site, but maybe even an API, there might be cases when you would like to display only part of a value.
For example you might want to display the last 4 digits of a credit card number.
Or the first 4 letters of an e-mail address.

Sometimes you might want to display only part of the field. Sometimes you might want to replace the rest of the filed by some
"hiding character".


## Examples

input: "abcdefghijklmnopqrs"

Show only the last 4 characters: "pqrs".

Show the last 4 characters and replace (mask) the rest with stars: "***************pqrs".

Show the last 4 characters and mask the rest, but without indicating the length of the original string.
So no matter what was the original length we'll show 4 stars and the last 4 characters: "****pqrs".

Show only the first 4 characters: "abcd".

The examples can go on.

Now go ahead an for each idea above write a regex that will accomplish the task.

If you feel that regexes might not be the right answer write functions (one for each masking-type) that will
accept a string and returned the "masked" string.

## The real task

So how is the above related to a real-world problem?
You might retrieve some data from a database. Each row of data will be in a hash, where the keys
are the names of the columns in the database and the values are, well, the values. Some of the fields
need to be masked, but even those some need to be masked in one way, others need to be masked in some other way.

Write some generic solution for these.

## Solution for the individual masking

First a few examples of regexes solving the masking/hiding problem for individual strings:

{% include file="examples/mask.pl" %}

The third example is probably the simplest:  `$out3 =~ s/^(.{4})(.*)$/$1****/;`.
We capture the first 4 characters using `(.{4})` then
we capture the rest of the string using `(.*)`. We then replace the first 4 characters
by themselves (ok, so nothing changes there) and the rest of the characters by exactly 4 stars.
The same could have been done with `$out3 = substr($in, 0, 4) . '****';`.


The second example is slightly more difficult on: `$out2 =~ s/^(.*)(.{4})$/****$2/;`.
Here we capture everything `(.*)`, but then we want to capture 4 characters at the end of the string
`(.{4})` that will limit the first part to "everything besides the last 4 characters".
An alternative would be `'****' . substr($in, -4);`

The 4th example is a lot more interesting. Here we need to replace each character, except the last 4.
I have some feeling that we might be able to solve this without the `/e` modifier, but could not
come up with the solution so here is the one I managed to write: `$out4 =~ s/^(.{4})(.*)$/$1 . "*" x length($2)/e;`
`/e` means that instead of using the replacement part as an interpolated string we use it as a piece of Perl code
and evaluate it. (With [eval](/string-eval)) The capturing part is the same as before, but
in the replacement part we have Perl code.
An alternative would be: `say substr($in, 0, 4) . "*" x (length($in) - 4);`.

Frankly, after writing all the non-regex examples, I am not sure why would we want to use regexes here.

Running the above script will yield the following output:

{% include file="examples/mask.out" %}

## Generic solution for field masking/hiding/replacement


We assume that the user has a hash with the data retrieved from the database.
We prepare a dispatch table, a hash, in which the keys are names of the fields that need to be masked
and the values are references to functions that can do the masking for an individual string.

Then we have a function called "mask_fields" that gets a reference to the data and a reference to the
dispatch table and applies the appropriate function to each on of the fields.

{% include file="examples/mask_fields.pl" %}

This line: `$data->{$key} = $masks->{$key}->($data->{$key});` is probabbly the key to this solution.
On the left hand side of the assignment we "simply" de-reference a reference to a hash.
On the right hand side we first de-reference a reference to a hash `$masks->{$key}`,
and then using the `->()` syntax we de-refernce and call a reference to a function.

Running the above script will yield the following output:

{% include file="examples/mask_fields.out" %}

One idea here was to store the tranformation regexes or transformation functions in the database,
but I would strongly recommend agains that. That creates an unnecessary attach vector because if someone
manages to insert malicious data in the database, and that data is then executed as code,
then effectively we allow the person to execute arbitrary code on our server.

Besides, code in files and on the disk can be tested, debugged, and version controlled(!) much easily than
data in a database.





