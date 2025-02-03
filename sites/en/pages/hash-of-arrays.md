---
title: "Hash of Arrays in Perl"
timestamp: 2019-04-16T06:30:01
tags:
  - Dumper
published: true
author: szabgab
archive: true
---


Elements of hash can be anything, including references to array.

For example what if you have a bunch of people and each person has a list of scores.

Another interesting example would be a bunch of people each person belonging to 1 or more groups.

How would you store these in a file and how would you store them in memory?



## Hash of Arrays - for one directional data

In the first example we have a bunch of people and each person has a list of scores.
I call it one directional as usually the only thing interesting here is to look up the scores of one person.
There is not much interest in finding all the people with a given score. (Although it might be interesting to
find people in score ranges.)

Anyway, one can store this data in a file in many ways, for example like this:

{% include file="examples/data/name_score.txt" %}

On purpose it is not a real [CSV file](/csv). That would be too easy.

Each line has name followed by a colon and then a comma separated list of numbers. Each line can have
a different number of values.

We can write a script like this to read in the data.

{% include file="examples/names_and_scores.pl" %}

Reading the file line-by-line, first splitting into two, and then splitting the scores into as many pieces as there are
values in the given line.

`%scores_of` is a hash of arrays or more precisely it is a hash of array references.

The back-slash `\` in-front of the `@` character returns the reference to the array.

The call to `Dumper` show what do we have in the hash.
After that there is a small example showing how to go over the values of a single person.

The output of the above script will look like this:

{% include file="examples/names_and_scores.txt" %}

You might want to check out [how to dereference a reference to a hash or to an array in Perl](/dereference-hash-array)
and [array references](/array-references-in-perl).


## Hash of Arrays - two directional data

In the second example we have a bunch of people each person belonging to 1 or more groups.
This is slightly different from the previous one as in this case I can easily imagine two differnt ways to look at the
data:

* Getting all the groups a person belongs to
* Getting all the people who belong to a group

In a file this data can be stored in a similar way as had in the first example, but we'll have a strange feeling that we
duplicate a lot of data. For example we'll have this:

{% include file="examples/data/name_group.txt" %}

In the previous example we would not complain even if several people had the same score.
Here on the other hand we would probably protest the fact that we repeate group-names several times.

Unfortunately in a plain text file we don't have a lot of other options.

In a relational database (you know the one using SQL), this would be probabbly represented using 3 tables.
A table with all the names:

{% include file="examples/data/name_group/people.txt" %}

A table with all the groups (or subjects):

{% include file="examples/data/name_group/groups.txt" %}

Each one of the tables would have two columns. One for the actual value and one for a unique ID.

Then we would have a third table mapping between the two tables.

{% include file="examples/data/name_group/name_groups.txt" %}


Now if we wanted to list all the groups of a person we could look it up in the database.

However we are in the flat-file storage and our question was how to represent this in the memory of our Perl program.

One way would be to use an [in-memory SQL database](/sqlite-in-memory), but that's a different story.

If we would like to represent this with Perl data structures we can't do that without lots of repetition.
Normally, unless we have a lot of data, this should not be a problem. (If we have too much data we might run out
of memory because of the repetitions.)


{% include file="examples/names_and_groups.pl" %}

We create two hashes to allow for the lookup in both directions.

To fill the `%groups_of` hash we use the same code as we had earlier. That's the easier part as the
data in the data file was layed out that way.

To fill the `%members_of` needs another internal `for-loop` that goes over all the groups of the
current person and adds the person to the right group relying on [autovivification](/autovivification)
to create the references where necessary.

The output of this script looks like this:

{% include file="examples/names_and_groups.txt" %}

Of course you don't have to have both hashes, only the one that you will really use, I just wanted to show
both of them in a single example.



