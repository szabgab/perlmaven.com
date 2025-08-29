---
title: "What is autovivification?"
timestamp: 2015-01-21T07:50:00
tags:
  - autovivification
  - exists
  - delete
published: true
books:
  - advanced
author: szabgab
---


Autovivification is both a wonderful blessing and a curse in Perl. It eliminates a lot of
code required when initializing deep data structures, but if you come from a very
strict world it can freak you out at first.

Or make you wonder how could you live without it.

The word **autovivification** itself comes from the word **vivify**
which means **to bring to life**.



## The simple cases for hashes

The simplest form of autovivification is when you have a hash and you set a value of a
key that did not exist before.

```perl
use strict;
use warnings;

use Data::Dumper qw(Dumper);

my %phone_of;

print Dumper \%phone_of;
$phone_of{Foo} = '123-456';
print Dumper \%phone_of;
```

```
$VAR1 = {};
$VAR1 = {
          'Foo' => '123-456'
        };
```

As a Perl programmer this does not surprise you any more.

Even if you have a reference to a hash:

```perl
use strict;
use warnings;

use Data::Dumper qw(Dumper);

my $phone_of;

print Dumper $phone_of;
$phone_of->{Foo} = '123-456';
print Dumper $phone_of;
```

A slightly more surprising version of this is when
we use the auto-increment operator `++` on a
hash element that did not exist before.

```perl
use strict;
use warnings;

use Data::Dumper qw(Dumper);

my %counter;
print Dumper \%counter;
$counter{Foo}++;
print Dumper \%counter;
```

```
$VAR1 = {};
$VAR1 = {
          'Foo' => 1
        };
```

Perl treats the nonexistent value as [undef](/undef-and-defined-in-perl).
When `undef` is used in a [numerical operation](/numerical-operators) it acts as if it were 0.
In most cases this would generate a <a href="/use-of-uninitialized-value"">use of uninitialized value"</a> warning,
but specifically in the auto-increment operation it works without complaining.

The resulting value is then assigned back to the hash, creating the key.

## The simple cases for arrays

In the case of an array, if you assign a value to a nonexistent element,
or use auto-increment on such an element, Perl will automatically enlarge the array
creating all the elements up to the required index, and assigning `undef`
to each intermediate element.

```perl
use strict;
use warnings;

use Data::Dumper qw(Dumper);

my @counter;
print Dumper \@counter;
$counter[1] = 20;
$counter[3]++;
print Dumper \@counter;
```

The output looks like this:

```
$VAR1 = [];
$VAR1 = [
          undef,
          20,
          undef,
          1
        ];
```

This means writing `$counter[1_000_000]++;` will enlarge the array to have a million elements with almost all of them being `undef`.
Such a [sparse array](http://en.wikipedia.org/wiki/Sparse_array) is a huge waste of memory.
In such cases a hash would be probably a better data structure to use.


## Complex data structures

Autovivification starts to be really interesting in deep data structures. Even when creating a two dimensional hash,
you can just write `$people{Foo}{phone} = '123-456';` and Perl will create the internal hash for the 'Foo' key:

```perl
use strict;
use warnings;

use Data::Dumper qw(Dumper);

my %people;

print Dumper \%people;
$people{Foo}{phone} = '123-456';
print Dumper \%people;
```

Resulting in

```
$VAR1 = {};
$VAR1 = {
          'Foo' => {
                     'phone' => '123-456'
                   }
        };
```

This is a good thing as you don't have to explicitly create the internal hash.

It even works on undefined scalars:

```perl
use strict;
use warnings;

use Data::Dumper qw(Dumper);

my $people;

print Dumper $people;
$people->{Foo}{phone} = '123-456';
print Dumper $people;
```

When we created the `$people` scalar, Perl did not yet know that it will become a reference to a hash.
As you can see from the following printout, it was still just an `undef`:

```
$VAR1 = undef;
$VAR1 = {
          'Foo' => {
                     'phone' => '123-456'
                   }
        };
```

Once we used it as a reference to a hash, it `autovivified` to be a reference to a hash.

The same would happen if we used it as a reference to an array but, if we try to do one after the other:

```perl
use strict;
use warnings;

use Data::Dumper qw(Dumper);

my $people;

print Dumper $people;
$people->{Foo}{phone} = '123-456';
print Dumper $people;

$people->[0] = 23;
print Dumper $people;
```

We will get an exception.

```
$VAR1 = undef;
$VAR1 = {
          'Foo' => {
                     'phone' => '123-456'
                   }
        };
Not an ARRAY reference at autovivification.pl line 12.
```

Once `$people` became a reference to a hash, it will not
automatically turn into being a reference to an array. This of course
is a good thing as it can help us avoid some really erroneous code.


## autovivification and accessing elements

As you might see the autovivification described above can save quite a lot of typing.
It also seems quite logical even if surprising at first.

Unfortunately there are other cases when it is mostly surprising and not that logical.

```perl
use strict;
use warnings;

use Data::Dumper qw(Dumper);

my %people;

print Dumper \%people;
if (exists $people{Foo}{phone}) {
    print "Good, Foo might have a phone\n";
} else {
    print "Foo has no phone\n";
}

print Dumper \%people;
```

In this case we don't assign any value to the hash, we just check if one of the
internal values (the phone of Foo) exists. It does not exist (Foo has not phone),
but the internal hash was created by this operation:

```
$VAR1 = {};
Foo has no phone
$VAR1 = {
          'Foo' => {}
        };
```

This is quite unfortunate.

This means we have changed the state of the `%people` has just by 
[observing it](http://en.wikipedia.org/wiki/Observer_effect_%28physics%29).

## autovivification and deleting elements

It looks even worse if we are trying to delete an element that does not exist:

```perl
use strict;
use warnings;

use Data::Dumper qw(Dumper);

my %people;

print Dumper \%people;
delete $people{Foo}{phone};
print Dumper \%people;
```

The result is:

```
$VAR1 = {};
$VAR1 = {
          'Foo' => {}
        };
```

In an attempt to reach the element that needs to be deleted, Perl
created the internal hash of 'Foo'.


## A bug

I think these undesirable cases are now generally considered to be a bug in Perl.
Unfortunately it is very unlikely that this bug will be fixed in Perl 5 as there is a lot of code
out in the wild (both on CPAN and in companies) that rely on this behavior.
Correcting the behavior would break a lot of code.

The way to avoid this is simple, it is "just" more typing:

```perl
use strict;
use warnings;

use Data::Dumper qw(Dumper);

my %people;

print Dumper \%people;
if (exists $people{Bar}) {
    if ($people{Bar}{phone}) {
        print "Check Bar...\n";
    }
}

if (exists $people{Foo}) {
    delete $people{Foo}{phone};
}

print Dumper \%people;
```

If we first check if the key to the outer hash `exists` and only then
check the phone number, or try to delete it, the element will not be created.

This will keep the outer hash clean:

```
$VAR1 = {};
$VAR1 = {};
```

## no autovification

As an alternative, there is a pragma on CPAN called
[autovivification](https://metacpan.org/pod/autovivification)
that can turn off the bad effects in a lexical scope (within a pair of curly braces),
but it is not widely used:

```perl
use strict;
use warnings;

use Data::Dumper qw(Dumper);

my %people;

print Dumper \%people;
delete $people{Foo}{phone};
{
    #no autovivification;
    delete $people{Bar}{phone};
}
print Dumper \%people;
```

Running the above code will have the undesired effect for both 'Foo' and 'Bar':

```
$VAR1 = {};
$VAR1 = {
          'Bar' => {},
          'Foo' => {}
        };
```

If you remove the `#` and run the script again the
undesired effect is gone:

```
$VAR1 = {};
$VAR1 = {
          'Foo' => {}
        };
```


## Conclusion

Autovivification is a good thing but we need to be careful we don't create unnecessary
elements while trying to check (or delete) internal elements.

At least now we know why were they created.


## Comments

Well explained, Gabor!

This nested condition:
if (exists $people{Bar}) {
if ($people{Bar}{phone}) {
print "Check Bar...\n";
could more safely be written like this:
if (exists $people{Bar}) {
if (exists $people{Bar}{phone}) { # I added 'exists ' here.
print "Check Bar...\n";
in case $people{Bar}{phone} contains some false value like 0.
But the nested condition could also be simplified to this:
if (exists $people{Bar} and exists $people{Bar}{Phone}) {
because the 2nd part of the condition will be tested only if the 1st part evaluates to true.

And a minor typo - "As an alternatively" should read "As an alternative".

<hr>

Thanks Gabor.

I have some issues as mentioned below.Can you please help
I have arrays which has below format
key1->key2->key3->value
key1->key2->value
key1->value
....
..
There can be multiple arrays with unique value.Now when i try to create nested hash and json then i get the error :Not a HASH reference at createjson.pl at line $ref = \$$ref->{ $_ } foreach @_;

#!/usr/bin/perl
use strict;
use warnings;
use Data::Dumper;

#Checking whether JSON perl module is installed or not
is_JSON();

my @lines = `find . -name *.txt|xargs grep -R 'TEST-TAG ='`;
my $hash;
my %jdata;
##pattern of TEST-TAG is "/*TEST-TAG = Half_Pre_Float-Point->fma->hfma2_mma*/" or /*TEST-TAG = Half_Pre_Float-Point->fma*/

foreach (@lines)
{
    my($all_cat) = $_ =~ /\=(.*)\*\//;
    my($testname) = $_ =~ /\/.*\/(.*)\./;
    if(!$all_cat eq ""){
        $all_cat =~ s/ //g;
        my @ts = split(',', $all_cat);
        my $i;
        foreach (@ts){
            my @allfeat = split('->',$_);
            my $count =  scalar @allfeat;
            for($i = 0; $i<$count; $i++){
                my @temparr = @allfeat[$i..$count-1];
                push @temparr, $testname;
                ToNestedHash($hash, @temparr);
            }
        }
    }
}
%jdata = (%jdata, %$hash);

my $json = JSON::XS->new->utf8->pretty(1);
my $file_category = "./category.json";
open my $fth, ">", $file_category or die "Failed to open $file_category: $!.\nPlease open it with p4 edit and retry";
print $fth $json->encode(\%jdata);
close $fth;

#add the value in nested hash.
sub ToNestedHash {
    my $ref   = \shift;
    my $h     = $$ref;
    my $value = pop;
    $ref      = \$$ref->{ $_ } foreach @_;
    if(!isinlist(\@{$$ref},$value)){
        push @{$$ref}, $value;
    }
    return $h;
}


# If element exists in the list
sub isinlist {
    my ($aref, $key) = ($_[0], $_[1]);
    foreach my $elem (@$aref){ if ($elem eq $key) { return 1;}}
    return 0;
}

---

This expression: \$$ref->{ $_ } is really confusing. Could you simplify it?
What is in $ref ?

I'd add a print statement in front of that line to see what is in there. That might help to understand the problem.
I'd also change the name to reflect the content not the type of the content that I think it has. (That seems to be incorrect anyway).
Finally, I'd use File::Find or some more fun Perl module instead of external find and xargs.


----


Sure.
explanation is here for subroutine ToNestedHash
Take the first value as a hashref
Take the last value as the value to be assigned
The rest are keys.
Then create a SCALAR reference to the base hash.
Repeatedly:
Dereference the pointer to get the hash (first time) or autovivify the pointer as a hash
Get the hash slot for the key
And assign the scalar reference to the hash slot.
( Next time around this will autovivify to the indicated hash ).

I had added print statements and have same question here  https://stackoverflow.com/questions/54070085/perl-not-a-hash-reference-while-creating-nested-hash-from-multi-dimension-array

---

BTW i was going through your another article https://perlmaven.com/multi-dimensional-hashes and issue is similar to Foo Bar, Programming: ARRAY(0x7fc409028508)

I have around 20 arrays with below data.1-19 arrays has the same keys till dmma_simple and their values are different. 20th array has this content "MMA->Dmma->dmma_simple->dmma_complex-->value20" i.e. dmma_simple key now has the another key as well dmma_complex along with array of values.How to store such data?

so the output is
'MMA' => {
'Dmma' => {
'dmma_simple' => [
'value1'
'value2'
...
till 'value 19'
]
}
},
These are the arrays:
MMA->Dmma->dmma_simple->value1
MMA->Dmma->dmma_simple->value2
...
MMA->Dmma->dmma_simple->dmma_complex-->value20

some keys e.g. dmma_simple has values mentioned in array and sub keys e.g. dmma_complex as well.So when program comes to key dmma_complex,it see dmma_simple is ARRAY and not hash hence gives error.How to solve this scenatio?

Below is the output of this code.
foreach my $i (@_) {
print " before INDEX $i\n";
print Dumper($ref);
$ref =\$$ref->{$i};
print "after INDEX $i\n";
print Dumper($ref);
}

before INDEX dmma_simple
$VAR1 = \{
'dmma_simple' => [
'dmma_884_row_col_aShared_bGlobal_cGeneric_rz',
'dmma_884_row_col_aGlobal_bShared_cGeneric_rz',
'dmma_884_row_col_aGeneric_bShared_cGlobal_rn'
]
};
after INDEX dmma_simple
$VAR1 = \[
'dmma_884_row_col_aShared_bGlobal_cGeneric_rz',
'dmma_884_row_col_aGlobal_bShared_cGeneric_rz',
'dmma_884_row_col_aGeneric_bShared_cGlobal_rn'
];
before INDEX dmma_complex
$VAR1 = \[
'dmma_884_row_col_aShared_bGlobal_cGeneric_rz',
'dmma_884_row_col_aGlobal_bShared_cGeneric_rz',
'dmma_884_row_col_aGeneric_bShared_cGlobal_rn'
];
Not a HASH reference at createjson.pl line 81.
