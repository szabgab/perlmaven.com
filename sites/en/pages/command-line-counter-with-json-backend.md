---
title: "Command line counter with JSON backend"
timestamp: 2015-11-01T06:30:01
tags:
  - Path::Tiny
  - Cpanel::JSON::XS
published: true
books:
  - counter
author: szabgab
archive: true
---


As part of the [big counter example](https://code-maven.com/counter) project, this example runs on the command line and uses a JSON file as back-end 'database'.
It helps simplify the back-end part we saw in the [multiple command line counter with TSV file](/multiple-command-line-counters) case.


## Front-end

The front end is the command line. We just run the script as `perl json_counter.pl foo` providing the name of the counter on the command line.

## Back-end

In this example the "database" will be a file with [JSON](/json) format in it. The nice thing about the JSON format is that
a Perl hash can be easily converted to a JSON string, and the JSON string can be easily converted back to a Perl hash.

This eliminates the need to think about a format that suits our data structure. Of course in our simple case of a simple hash this might be
less interesting, but in the general case, it is hard to map a complex, multi-dimensional data structure to a string. JSON is a great solution there.

## Code

In this solution we also use [Path::Tiny](https://metacpan.org/pod/Path::Tiny) to make it easier to read from the file and to write back to it
without calling `open` and `close` ourselves and we use [Cpanel::JSON::XS](https://metacpan.org/pod/Cpanel::JSON::XS) to
convert the Perl hash to JSON string and back again.

{% include file="examples/json_counter.pl" %}

First we load the modules and explicitly import the necessary functions. If for nothing else, importing the functions explicitly
is useful for the next person who won't have to guess where do these functions come from.

```perl
use Cpanel::JSON::XS qw(encode_json decode_json);
use Path::Tiny qw(path);
```

Then we get the name of the counter from the command line and show a usage message if the user has not supplied the value. Just as we did
in the [case with the TSV file](/multiple-command-line-counters).

While the script is running we will keep the counters in a hash, or more specifically in a reference to a hash. We use a reference instead of a simple
hash because the function that converts form Perl to JSON expects a reference, and the function converting JSON to Perl returns a reference.
So we declare the `my $counter;` scalar variable that will later [autovivify](/autovivification) into a reference to a hash.

Before looking at the next two sections, let's jump to the end of the script to see how do we increment the proper counter and how do
we save the hash reference as a JSON string.

This code will increment the counter stored in the `$name` variable.

Even if this is the fist time we run the script and the variable `$counter` still only contains an `undef`,
when we access it as if it was a reference to a hash it will automatically turn itself into a hash reference.
(This is called [autovivification](/autovivification).)

```perl
$counter->{$name}++;
print "$name: $counter->{$name}\n";
```

Then the function `encode_json` will convert our hash reference into a JSON string and the `spew` method of the `Path::Tiny</a> object
will save he given string to the file in the `$file` variable.

```perl
path($file)->spew(encode_json $counter);
```

We don't need to think about conversion at all, the `encode_json` function handles it for us.

Now that we know how the 'counters.json' file is generated after we have incremented the counter we can go back to the code in the middle of the script
and see how do we load the content of the file.

Using the `-e` operator we check if the file exists, if it does, we read in the content of the file using the `slurp` method of the Path::Tiny
object. This will read in (or [slurp](/slurp) the whole content of the file). Then we use the `decode_json` function to convert this
JSON string into a Perl data structure. (Specifically a reference to a Perl hash.) This is what we assign the `$counter` variable.

```perl
if (-e $file) {
    $counter = decode_json path($file)->slurp;
}
```

## List all the counters

In this example I've added an extra functionality. If the user passes `--list` on the command line, then instead
of using that as the name of yet another counter, we are going to list all the counters with their current count value.

For this we had to dereference the `$counter` reference of a hash using `%$counter`. Then we could call
`keys` on this new hash. We then call `sort` on the list of keys, so we won't see the keys in a random order.
Then we just print the key-value pairs to the console. Once we are done, we call `exit` to make sure we won't
use the word '--list' as the name of another counter.


```perl
if ($name eq '--list') {
    foreach my $key (sort keys %$counter) {
        print "$key: $counter->{$key}\n";
    }
    exit;
}
```


## keys on reference is experimental

Actually starting from perl 5.20, we don't even need to dereference the hash reference before using the `keys` function.
We could just write:

```perl
    sort keys $counter
```

and it would work. It will give a warning `keys on reference is experimental` and at this point I'd recommend using
only if you have plenty of unit-tests around the code and if you are ready to change it if this feature is changed
in later versions of Perl.

