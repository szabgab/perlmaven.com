---
title: "Perl Hash"
timestamp: 2013-08-03T23:12:06
description: "A Perl hash (associative array) can hold key-value pairs where the keys are strings, the values are scalars."
tags:
  - hash
  - keys
published: true
books:
  - beginner
author: szabgab
---

<!-- Please wait with the translation till this article is finished and this comment is removed -->


Hashes, or hash tables, that are called **associative arrays**, **hashmaps**, or <b>dictionaries</b>
in other languages are an integral and important part of Perl.
On this page we try to answer some common questions about hashes.


## Perl Hash table tutorial

A hash in Perl always starts with a percentage sign: `%`. When accessing an element of a hash
we replace the `%` by a  dollar sign `$` and put curly braces `{}` after the name.
Inside the curly braces we put the `key`.

A hash is an `unordered set of key-value pairs` where the keys are unique.

A `key` can be any string including numbers that are automatically converted to strings.
A `value` can be any scalar value: number, string, or a reference.

The key is a string, but when it is a "simple string" you can leave out the quote characters when used
on the left hand side of the fat-arrow, or in the curly braces.

```perl
use strict;
use warnings;
use 5.010;

my %person = (
   fname => 'Foo',
   lname => 'Bar',
);
say $person{'fname'};  # Foo
say $person{fname};    # Foo
my $key = 'fname';
say $person{$key};     # Foo
```


## Perl Hash of arrays

Each value in the following hash is an array, or more specifically it is a reference to an array.

```perl
use strict;
use warnings;
use 5.010;
use Data::Dumper qw(Dumper);

my %grades;
$grades{'Foo Bar'}[0] = 23;
$grades{'Foo Bar'}[1] = 42;
$grades{'Foo Bar'}[2] = 73;
$grades{'Peti Bar'}[0] = 10;
$grades{'Peti Bar'}[1] = 15;
print Dumper \%grades;

$grades{'Zorg'} = [10, 20, 30, 40];

print Dumper \%grades;
```

In the first 5 lines we access the elements of the internal arrays as if we had a two-dimensional data structure.
In the last assignment we assign an array reference `[10, 20, 30, 40]` to Zorg.

`Data::Dumper` can show the data structure in a reasonably readable way:

```
$VAR1 = {
          'Foo Bar' => [
                         23,
                         42,
                         73
                       ],
          'Peti Bar' => [
                          10,
                          15
                        ]
        };
$VAR1 = {
          'Foo Bar' => [
                         23,
                         42,
                         73
                       ],
          'Peti Bar' => [
                          10,
                          15
                        ],
          'Zorg' => [
                      10,
                      20,
                      30,
                      40
                    ]
        };
```


## Perl Hash of arrays of arrays

Like in the preceding example, each value in the following hash is a
reference to an array and each value in the array is a reference to
another array.

Here is an example of a list of invoices for each customer:

```perl
use strict;
use warnings;
use Data::Printer;

my $invoices = {
  customer_1 => [
      [ 1, 'Article_1', 300.00 ],
      [ 2, 'Article_2', 500.00 ],
  ],
  customer_2 => [
      [ 1, 'Article_2', 999.00 ],
      [ 2, 'Article_5', 399.99 ],
  ],
};

# Add another customer
push @{ $invoices->{customer_3} }, [ 1, 'Article_9', 899.00 ];
push @{ $invoices->{customer_3} }, [ 2, 'Article_10', 799.00 ];

p $invoices;
```

This time we use `Data::Printer` to show the data structure:

```perl
\ {
    customer_1   [
        [0] [
            [0] 1,
            [1] "Article_1",
            [2] 300
        ],
        [1] [
            [0] 2,
            [1] "Article_2",
            [2] 500
        ]
    ],
    customer_2   [
        [0] [
            [0] 1,
            [1] "Article_2",
            [2] 999
        ],
        [1] [
            [0] 2,
            [1] "Article_5",
            [2] 399.99
        ]
    ],
    customer_3   [
        [0] [
            [0] 1,
            [1] "Article_9",
            [2] 899
        ],
        [1] [
            [0] 2,
            [1] "Article_10",
            [2] 799
        ]
    ]
}
```

Note the different format used by this module.

## Perl Hash reference

```perl
use strict;
use warnings;
use 5.010;
use Data::Dumper qw(Dumper);

my %phones = (
   Foo => '1-234',
   Bar => '1-456',
);
my $hr = \%phones;

say $phones{Foo};  # 1-234
say $hr->{Foo};    # 1-234

print Dumper $hr;

foreach my $name (keys %$hr) {
   say "$name $hr->{$name}";
}

my $other_ref = {
   Qux => '1-567',
   Moo => '1-890',
};

say $other_ref->{Qux};   # 1-567
print Dumper $other_ref;
```

```
1-234
1-234
$VAR1 = {
          'Foo' => '1-234',
          'Bar' => '1-456'
        };
Foo 1-234
Bar 1-456
1-567
$VAR1 = {
          'Qux' => '1-567',
          'Moo' => '1-890'
        };
```


## Perl Hash key

Hashes are key-value pairs. Let's say we have a hash called `%phone_number_of`.
If you know a specific key, which is just a string, and it is found in the variable `$name`,
then you can get the value of this key in the above hash by writing `$phone_number_of{$name}`.

If you don't know what keys are in the hash you can fetch a list of keys using `@names = keys %phone_number_of`.

## Perl Hash exists

Given an expression that specifies an element of a hash, returns [true](/boolean-values-in-perl)
if the specified element in the hash has ever been initialized,
even if the corresponding value is [undefined](/undef-and-defined-in-perl).

A hash element can be true only if it's defined and defined only if it exists, but the reverse doesn't necessarily hold true.

```perl
use strict;
use warnings;

my %months = (
    0 => 'January',
    1 => 'February',
    2 => 'March',
    3 => 'April',
    4 => 'May',
    5 => 'June',
    6 => 'July',
    7 => 'August',
    8 => 'September',
    9 => 'October',
    10 => 'November',
    11 => 'December'
);

#Interpolation will not happen for hashes i.e %months will not be interpolated
if (exists $months{1}) {
    print "$months{1} exists in the hash %months\n";
}

my ($sec,$min,$hour,$mday,$mon,$year,$wday,$yday,$isdst) = localtime(time);
print "The current month is $months{$mon}" if exists $months{$mon};
```

## Perl Hash size

In this hash, keys contain multiple words (i.e 2 words), so you need to enclose it in quotes. If the key contains
only a single word, then quotes are optional. In fact, it is recommended to omit quotes for keys.

```perl
use strict;
use warnings;

#Program to find the size of a hash

my %india = (
    'National Bird'   => 'Peacock',
    'National Animal' => 'Tiger',
    'National Flower' => 'Lotus',
    'National Fruit'  => 'Mango',
    'National Tree'   => 'Banyan',
    'National Game'   => 'Hockey'
);

#The keys function in scalar context returns the number of keys in the hash.
my $size = keys %india;

print "The size of the hash is $size\n";
```

## Perl hash number of elements

See above at **Perl Hash size**

## Perl Hash map

## Perl Hash slice

A slice is always a list, so the hash slice notation uses an at sign to indicate that. The curly braces mean that you’re indexing into a hash; the at sign means
that you’re getting a whole list of elements, not just a single one (which is what the dollar sign would mean).

```perl
use strict;
use warnings;

use 5.010;

my %employee = (
    jack  => 980144,
    peter => 128756,
    john  => 903610    
);

#Assign a hash slice to @id1 array
my @id1 = ($employee{"jack"}, $employee{"peter"}, $employee{"john"});

#Print all employee ids from array @id1
say join ',', @id1;

#Assign a hash slice to @id2 array
my @id2 = @employee{ qw/jack peter john/ };

#Print all employee ids from array @id2
say join ',', @id2;

my %employee2 = (
    #Name, Employee Id, Department, Location
    jack  => [980144,'Marketing','London'],
    peter => [128756,'Research', 'Detroit'],
    john  => [903610, 'Development', 'Sydney']    
);

#Retrieve the location of all employees
my @location = ($employee2{"jack"}->[2], $employee2{"peter"}->[2], $employee2{"john"}->[2]);

#Print all employee's location
say join ',', @location;
```

Hash slices are a very useful feature of Perl that remove the need for some loops.
A hash slice is a way of referring to one or more elements of the hash in one statement,
to get a list of values, or to assign a list of values.

To get a single element from a hash `%hash`, with key `$key`, you can write `$value = $hash{ $key }`

To get a list of elements from the same hash, referred to by the keys in `@keys`, you can write `@values = @hash{ @keys }`

```perl
use strict;
use warnings;

#Program to demonstrate hash slice

my %day_names = (
   'sun'  => 'Sunday',
   'mon'  => 'Monday',
   'tue'  => 'Tuesday',
   'wed'  => 'Wednesday',
   'thu'  => 'Thursday',
   'fri'  => 'Friday',
   'sat'  => 'Saturday',
);

#Get a list of the full names of week days (ie not weekends)
my @weekdays = @day_names{ qw(mon tue wed thu fri) };

print "The store is open from 9AM to 5PM on " . join(", ", @weekdays) . "\n";

#Get a list of the full names of weekend days
my @weekends = @day_names{ 'sat', 'sun' };

print "The store closes at 12 noon on " . join(" and ", @weekends) . "\n";

#Lets say we want to change the hash now to make the values lower case and plural
#So that 'Sunday' becomes 'sundays'
#We can assign to a hash slice to achieve this

#Get the keys and the values from the hash - these will have the same respective order
my @keys = keys %day_names;
my @values = values %day_names;

#Now assign to a slice of the hash %day_names
#In this case the slice @keys identifies every key of %day_names
@day_names{ @keys } = map lc($_) . 's', @values;

print "In the winter the store may open late " . $day_names{sun} . "\n";
```

## Size of an array in a hash

Getting the size of an array within a hash is a matter of de-referencing it `@{ $data{$key} }`
and putting that in scalar context either explicitly: `scalar @{ $data{$key} }`,
or one of the many implicit ways: `$count = @{ $data{$key} }`, `if (@{ $data{$key} } < 10) { `

```perl
use strict;
use warnings;
use 5.010;

my %data = (
  Snowwhite => [ 'Doc', 'Grumpy', 'Happy', 'Sleepy', 'Bashful', 'Sneezy', 'Dopey' ],
  LOTR      => [ 'Frodo', 'Sam Gamgee', 'Pippin', 'Merry', 'Aragorn', 'Boromir', 'Legolas', 'Gimli', 'Gandalf'],
);
say scalar @{ $data{Snowwhite} };    # 7
my $dwarfs = @{ $data{Snowwhite} };
my $fellowship = @{ $data{LOTR} };
say $dwarfs;                         # 7 
say $fellowship;                     # 9
```

## Number of elements of an array in a hash

This is the same as the **size of an array in a hash**.

## Contributors

* [Shaji Kalidasan](https://github.com/shajiindia)
* [Andrew Kirkpatrick](https://github.com/spacebat)
* [Ștefan Suciu](https://github.com/stefansbv)





