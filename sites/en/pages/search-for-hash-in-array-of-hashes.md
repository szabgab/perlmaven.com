---
title: "Search for hash in an array of hashes"
timestamp: 2017-11-19T09:30:01
tags:
  - grep
  - first
  - List::Util
  - map
published: true
author: szabgab
archive: true
---


Given an array of hashes, how can we locate a given hash based on one of the keys/value
pairs?


Let's assume we have a large array with many entries like these:

{% include file="examples/people.pl" %}

We would like to be able to find the hash that has a specific ID. For example where ID is 4174.

There are several solutions for this. The first one is better if we only need to find one or 
very few of these hashes. The second one is an improvement on the first one.

The third one is probably better if we'll have to find many entries
during the life of our process.

The third solution will be a lot faster if there are many entries  and if we will need to
find many entries, but it might take up a lot more memory.


## Finding a single entry using 'grep'

In this case we are going to use the [grep](/filtering-values-with-perl-grep) command.

{% include file="examples/find_one_person.pl" %}

The `do` statement is only used to load the data from the external file.

The interesting part is the `grep` function that filters the array base on the
condition in the `{}` where `$_` iterates over the elements of the array.
Meaning on each iteration one of the hashes will be in it.

The solution is simple, the drawback is that every time we would like to find an entry,
the `grep` call will go over all the elements. If there are many hashes in the array
reference, this can take a long time.

## Finding a single entry using 'first'

the [List::Util](https://metacpan.org/pod/List::Util) provides a function
called `first` that works exaclty as `grep` does, but it will stop iterating
over the array once the first match was found.

{% include file="examples/find_first_person.pl" %}

The speed improvement will be measurable only if there are many elements in the array,
and if the element we are looking for is early in the array.
Though I have not measure at what value of "many" and "early" this can be measured.


## Find several entries

For the the third solution we create a lookup-hash where the keys are the ID values
and the values are the small hashes. Once we have this the look-up is trivially fast
as it is just a hash lookup. We use the [map](/transforming-a-perl-array-using-map) function for this that will transform each hash ref (found in `$_`) to
a key-value pair where `$_->{id}` is the key.

{% include file="examples/find_many_people.pl" %}

In this case we have an up-front cost of building the hash which takes some time and uses
some memory, but once we have that our look-up is much faster.
This will be better if we need to lookup several entries in one run of the code.


## Is the extra memory usage substantial?

It looks like as if we doubled the memory we needed as we have created a new hash with every
element of the original array. This is not really the case however. The new big hash holds
references the hashes in the original array and the actual data of these small hashes
is not copied.

As an exercise, you could use [Devel::Size](href://metacpan.org/pod/Devel::Size)
to measure the [memory usage](/how-much-memory-do-perl-variables-use)
of the Perl variables and to measure the [memory usage of the Perl script](/how-much-memory-does-the-perl-application-use).

I am quite sure the growth is negligible.


## Comments

If we need to frequently search an array of hashes for an id, we should transform it into a hash keyed by the id.

<hr>

Github was probably not the right place to ask a question.
hello, I'm not very good at this. I can get the keys and values from a regular hash and write them as a .csv file to disk.
I can get the values from individual keys in an array of hashes, which your excellent web site showed how to make.
$L_vars[0]={
image_file=>"my_images",
start_frame=>30,
end_frame=>50
}
but I'm having problems getting the keys, values from that as can't find the syntax to address the hash.
help appreciated.

