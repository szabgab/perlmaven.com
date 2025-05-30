---
title: "Multi dimensional hashes in Perl"
timestamp: 2013-11-14T23:30:01
tags:
  - hash
  - Data::Dumper
published: true
books:
  - beginner
author: szabgab
---


Every value in a hash in Perl can be a reference to another hash or to another array.
If used correctly the data structure can behave
as a two-dimensional or multi-dimensional hash.



Let's see the following example:

```perl
#!/usr/bin/perl
use strict;
use warnings;

use Data::Dumper qw(Dumper);

my %grades;
$grades{"Foo Bar"}{Mathematics}   = 97;
$grades{"Foo Bar"}{Literature}    = 67;
$grades{"Peti Bar"}{Literature}   = 88;
$grades{"Peti Bar"}{Mathematics}  = 82;
$grades{"Peti Bar"}{Art}          = 99;

print Dumper \%grades;
print "----------------\n";

foreach my $name (sort keys %grades) {
    foreach my $subject (keys %{ $grades{$name} }) {
        print "$name, $subject: $grades{$name}{$subject}\n";
    }
}
```

Running the above script will generate the following output:

```
$VAR1 = {
          'Peti Bar' => {
                          'Mathematics' => 82,
                          'Art' => 99,
                          'Literature' => 88
                        },
          'Foo Bar' => {
                         'Mathematics' => 97,
                         'Literature' => 67
                       }
        };
----------------
Foo Bar, Mathematics: 97
Foo Bar, Literature: 67
Peti Bar, Mathematics: 82
Peti Bar, Art: 99
Peti Bar, Literature: 88
```

First we printed out all the content of the hash, and then, under the separation line
we iterated over the data-structure ourselves to see how we can access the elements.
If you are not familiar with the Dumper function of Data::Dumper yet, the `$VAR1`
at the beginning is just a place-holder variable. We don't need to pay attention to it now.

What is important is that the input of the `Dumper` function is a reference to a
data structure and thus we put a back-slash `\` in front of `%grades`.

The order of the keys is random as hashes do not keep them in any specific order.


## Explanation

Let's see the details.

We create a hash called `%grades`. It is a simple, one dimensional hash
that can hold key-value pairs. There is nothing special in it.

The next line: `$grades{"Foo Bar"}{Mathematics}   = 97;`

This creates a key-value pair in the `%grades` hash where the key is
`Foo Bar` and the value is a reference to another, internal hash.
A hash that does not have a name. The only way to access that internal hash
is through the reference in the `%grades` hash.
In the internal hash the above line created a single key-value pair. The key is 
`Mathematics` and the value is `97`.

Unlike in Python, the creation of the internal hash is automatic and it
is generally referred to as [autovivification](/autovivification).


If we used Data::Dumper to print out the content of `%grades` right after
the first assignment we would see the following:

```
$VAR1 = {
          'Foo Bar' => {
                         'Mathematics' => 97
                       }
        };
```

In this output the outer pair of curly braces represent the `%grades` hash
while the inner pair of curly braces represents the other hash.

## Creating the third hash

Running the code further and printing out the content of the hash after 3 assignments:

```perl
#!/usr/bin/perl
use strict;
use warnings;

use Data::Dumper qw(Dumper);

my %grades;
$grades{"Foo Bar"}{Mathematics}   = 97;
$grades{"Foo Bar"}{Literature}    = 67;
$grades{"Peti Bar"}{Literature}   = 88;

print Dumper \%grades;
```

we get the following:

```
$VAR1 = {
          'Peti Bar' => {
                          'Literature' => 88
                        },
          'Foo Bar' => {
                         'Literature' => 67,
                         'Mathematics' => 97
                       }
        };
```

Here we can see the outer pair of curly braces and two internal pairs representing
a total of three separate hashes.

Here we can observe that the hash is not "balanced" or "symmetrical". Each hash has its
own keys and their respective values. The same keys can appear in both hashes, but
they don't have to.

## Traversing the hashes manually

While Data::Dumper can be useful for debugging purposes, we would not want to use it to
show the content of the data structure to users. So let's see how can we go over all the
keys and values of this 2-dimensional hash. 

`keys %grades` will return the keys of the `%grades` which are "Peti Bar" and
"Foo Bar" in random order. `sort keys %grades` will return them sorted.

So in each iteration of the outer `foreach` loop, `$name` will contain either
"Peti Bar" or "Foo Bar".

If we printed the respective values in `%grades` like this: 

```perl
foreach my $name (sort keys %grades) {
    print "$grades{$name}\n";
}
```

we would get output like this:

```
HASH(0x7f8e42003468)
HASH(0x7f8e42802c20)
```

These are the "user friendly" representations of the references to the "internal" hashes.

Wrapping each such reference within `%{ }` will de-reference them. This
expression represents the internal hash:

`%{ $grades{$name} }`

If we call the `keys` function passing this as an argument we will get back the
keys of the internal hash. When `$name` contains "Peti Bar" this will be
'Mathematics', 'Art', and 'Literature'.
For  "Foo Bar" this will be 'Mathematics', and 'Literature' only.

The `$subject` variable from the internal `foreach` loop will get these values
and we arrive to the familiar construct `$grades{$name}{$subject}` to fetch the
actual grades of these two students.

## Less than two dimensions

In this example we saw a 2-dimensional hash but Perl has no requirement and restrictions.
We could have another entry in the `%grades` hash that does not have a second
dimension like this:

`$grades{Joe} = 'absent';`

Here the Joe key does not have a second dimension. This would work almost flawlessly:

The output would look like this:

```
$VAR1 = {
          'Peti Bar' => {
                          'Literature' => 88,
                          'Mathematics' => 82,
                          'Art' => 99
                        },
          'Foo Bar' => {
                         'Mathematics' => 97,
                         'Literature' => 67
                       },
          'Joe' => 'absent'
        };
----------------
HASH(0x7fabf8803468)
Foo Bar, Mathematics: 97
Foo Bar, Literature: 67
absent
Can't use string ("absent") as a HASH ref while "strict refs" in use at files/hash.pl line 20.
```

Data::Dumper could show the data structure properly (Joe does not have curly braces as he
does not have an internal hash), but when we traversed the code we got
an exception. [use strict](/strict) has stopped us from using a string ('absent')
as a [symbolic reference](/symbolic-reference-in-perl). Which is a good thing.

## More than two dimensions

We could also have more than two dimensions. For example 'Foo Bar' might also have
learned 'Art' and she got grades for several sub-subjects:

```perl
$grades{"Foo Bar"}{Art}{drawing}   = 34;
$grades{"Foo Bar"}{Art}{theory}    = 47;
$grades{"Foo Bar"}{Art}{sculpture}  = 68;
```

For now we have removed the entry of Joe, so that won't disturb us.
The output looks like this:

```
VAR1 = {
          'Peti Bar' => {
                          'Mathematics' => 82,
                          'Art' => 99,
                          'Literature' => 88
                        },
          'Foo Bar' => {
                         'Art' => {
                                    'sculpture' => 68,
                                    'theory' => 47,
                                    'drawing' => 34
                                  },
                         'Mathematics' => 97,
                         'Literature' => 67
                       }
        };
----------------
Foo Bar, Art: HASH(0x7fbe9a027d40)
Foo Bar, Mathematics: 97
Foo Bar, Literature: 67
Peti Bar, Mathematics: 82
Peti Bar, Art: 99
Peti Bar, Literature: 88
```

Data::Dumper still works well and shows the extra internal hash as the value of Art.

Unfortunately our manual traversing does not work well again, but at least this time
it does not throw an exception. It "only" prints the reference to the internal data
structure of Art of "Foo Bar".

As we can see here, there are places where the data structure has 2 dimension
and places where it has 3 dimensions.

We can have even more mixed dimensions.

## Mixed dimensions

What if 'Foo Bar' might have another subject called 'Programming' where she has grades
for each exercise. Here the grades don't have names, they are numbered 0, 1, 2, 3 etc.
We could an internal hash to represent these and we would have 0, 1, 2, 3, etc. as keys
but probably it is better to hold them in an array:

```perl
$grades{"Foo Bar"}{Programming}[0]  = 90;
$grades{"Foo Bar"}{Programming}[1]  = 91;
$grades{"Foo Bar"}{Programming}[2]  = 92;
```

In the output Data::Dumper will represent the array using square brackets:

```
$VAR1 = {
          'Foo Bar' => {
                         'Literature' => 67,
                         'Programming' => [
                                            90,
                                            91,
                                            92
                                          ],
                         'Mathematics' => 97,
                         'Art' => {
                                    'sculpture' => 68,
                                    'theory' => 47,
                                    'drawing' => 34
                                  }
                       },
          'Peti Bar' => {
                          'Mathematics' => 82,
                          'Art' => 99,
                          'Literature' => 88
                        }
        };
----------------
Foo Bar, Literature: 67
Foo Bar, Programming: ARRAY(0x7fc409028508)
Foo Bar, Mathematics: 97
Foo Bar, Art: HASH(0x7fc409027d40)
Peti Bar, Mathematics: 82
Peti Bar, Art: 99
Peti Bar, Literature: 88
```

And our own traversing cannot handle this either, but this time, instead
of `HASH(0x7fc409027d40)` it prints `ARRAY(0x7fc409028508)`
as this is a reference to an array and not to a hash.

## Checking if a key exists

Given a multi-dimensional hash like `%grades` one can check the existance of a key using
the [exists](/beginner-perl-maven-exists-delete-hash) keyword:

```perl
if (exists $grades{"Foo Bar"}) {
    if (exists $grades{"Foo Bar"}{Programming}) {
        ...
    }
}
```

One should also be careful using the second-level construct without trying the first-level first
as that might trigger [unwanted autovivification](/autovivification).

```perl
if (exists $grades{"Foo Bar"}{Programming}) {
}
```

## Other examples

* [Hash of arrays](/hash-of-arrays)
* [Hash of hashes of arrays](/printing-hash-of-hash-of-arrays-by-the-array)

## Comments

AWESOME. THANK YOU very much. I am using PERL for the first time and all your articles are EXCELLENT and makes PERL seem easier than what I initially assumed.

<hr>

I don't see an example of using 'exists' which I'm having a problem with when I pass a 3d hash ref to a subroutine. In the command 'if ( exists%{$href{key1}{key2}{$key3}})' I get an error on 'perl -c pgm.pl' which says "%href" requires explicit package name". Any ideas how to fix this? Can you put in an example of using 'exists' on a 3d hash (hash of hash of hashes)?

I also get an error on this line: "$t=%{$href{$pkk1}{$pkk2}{$pkk3}}; # DEBUG". The error is the same as above "%href requires an explicit package name". And I use "use strict".

See quick program here: https://pastebin.com/4efDzd6Y

---
I've updated the article with "exists". In you case there are two thing, one is that you don't need the leading %{ but apparently you also don't have a hash called %href. Maybe you have declared $href and use it as a reference to a hash? Then write: $href->{key1}...

<hr>

I have a Hash below: How I to find the number of sales Jim made on Friday and the total of the sales he made on Friday. Assume each number is the total for an individual sale.

I'm try to use your help print @{ $sales{"Monday"}{Jim} }; but just print 115

my %sales ;

$sales{"Monday"}{Jim}[0] = 2;
$sales{"Monday"}{Mary}[0] = 1;
$sales{"Monday"}{Mary}[1] = 3;
$sales{"Monday"}{Mary}[2] = 7;

$sales{"Tuesday"}{Jim}[0] = 3;
$sales{"Tuesday"}{Jim}[1] = 8;
$sales{"Tuesday"}{Mary}[0] = 5;
$sales{"Tuesday"}{Mary}[1] = 5;

$sales{"Wednesday"}{Jim}[0] = 7;
$sales{"Wednesday"}{Jim}[1] = 0;
$sales{"Wednesday"}{Mary}[0] = 3;

$sales{"Thursday"}{Jim}[0] = 4;
$sales{"Thursday"}{Mary}[0] = 5;
$sales{"Thursday"}{Mary}[1] = 7;
$sales{"Thursday"}{Mary}[2] = 2;
$sales{"Thursday"}{Mary}[3] = 5;
$sales{"Thursday"}{Mary}[4] = 2;

$sales{"Friday"}{Jim}[0] = 1;
$sales{"Friday"}{Jim}[1] = 1;
$sales{"Friday"}{Jim}[2] = 5;
$sales{"Friday"}{Mary}[0] = 2;

----

my $sales_num = keys $sales{"Friday"}{"Jim"};
my $sum = 0;
foreach my $val (values $sales{"Friday"}{Jim}) {
$sum+=$val;
}

---

that code will only run in certain versions of Perl. Better do the full de-referencing:

for my $k (keys %{ $sales{"Friday"}{"Jim"} }) {
}

foreach my $val (values %{ $sales{"Friday"}{Jim} }) {
       $sum+=$val;
}


----
Good notice. My Perl knowledge is based just on your tutorial (I am less than a week with Perl and will need it for automated testing). So, it would be great to add some info about de-reference in the tutorial. Unfortunately, "Type keyword" input field on this site gives me nothing on this request, as well as on others. It looks like the dysfunctional feature. Anyway, Great tutorial which I would recommend to all my friends!

<hr>

I'm trying to understand how one might try and populate this type of hash/array dynamically using variable names/values. It seems as though that's where things get very tricky from my searches.

Any insight you could provide in that regard would be GREATLY appreciated!

---

Just to add to this: As an example, I have a situation where I'd like to have some of the keys based on a looping variable's value as well as the value being based on another variable's value. Hopefully I'm explaining that well.

In any case, I really appreciate these tutorials!

---
Show me what code do you have so far or give me some examples with real values.

<hr>

another incredible feature of Perl...i never stop being amazed!
using a 9 dimensional / layer hash of hashes which stores all structured data of my project at speed of light....like a database-table with 7 primary keys in a where clause......cant't believe how fast this works!!!! more than 1 million inserts/second into that hash-monster :-)

Takes tons of data ( Gigabytes ) and still faster than any SQL database <3 Perl

p.s.: just tested up to 27 dimensions....still working....even Dumper shows content correct....who the hell created this galactic tool???

<hr>

how to load %hash from json file directly as a nested hash?
---
See the various JSON modules and related articles:  https://perlmaven.com/json

<hr>

my %hash_of_hash_of_arrays = (
'test' => {
'A_width' => [
'8',
'16',
'24'
],
'B_width' => [
'8',
'16',
'26'
]
}
);

For the above i need the output as below..
-----------------------------------------------
module : test
A_width : 8
B_width : 8

module : test
A_width : 16
B_width : 16

module : test
A_width : 24
B_width : 26
------------------------------

Can you please help me with the above.

What have you tried so far? Show me the code!


<hr>

Yes this worked for me, to capture a variable-length list of users associated with each group ID (i.e., from the linux group list):
my %groupList;
my $group = "grp1";
my $user = "usr1";
my $user2 = "usr2";
$groupList{$group}{$user} = $user ;
$groupList{$group}{$user2} = $user2 ;
foreach my $grp (%groupList) {
foreach my $usr (keys %{ $groupList{$grp} }) {
print "$grp, $usr: $groupList{$grp}{$usr}\n";
}
}

There is probably a simpler way to do this, since I am capturing each user ID twice as an index and as a value. But it works for my purposes. I guess this could be extended to add info about each user, such as if general user vs privileged user (by modifying the field to the right of the equals-sign in the assignment).

---

You call it a list (groupList), but it is a hash. Why not use an array (the that starts with and @ character)

---

Thanks. Yes I should have named it groupHash rather than groupList. But there are multiple groups with multiple users associated with each. I only showed the first group instance. How would I show a different list of users for each group instance?

---
Maybe this will help you: https://perlmaven.com/hash-of-arrays

---
OK, here is the hash of arrays example that works:

my %groupList;
my $group = "grp1";
my $user = "usr1";
my $user2 = "usr2";

push @{ $groupList{$group} }, $user;
push @{ $groupList{$group} }, $user2;

$group = "grp2";
$user = "usr12";
$user2 = "usr22";
push @{ $groupList{$group} }, $user;
push @{ $groupList{$group} }, $user2;

print Dumper \%groupList;

exit;

----

On further analysis, the first example above (hash-of-a-hash) cleans the data by removing duplicates (the second instance of a username within a group will overwrite the first), while the second example (hash-of-arrays) will retain every username instance. Hashes are good at removing/consolidating duplicates.

<hr>

Tank you, very useful!


