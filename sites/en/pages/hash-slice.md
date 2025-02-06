---
title: "How to get a slice of a hash?"
timestamp: 2017-09-05T22:00:01
tags:
  - "@hash{...}"
published: true
author: szabgab
archive: true
---


Given a hash of some of the [capitals of the world](https://en.wikipedia.org/wiki/List_of_national_capitals_in_alphabetical_order)

```perl
my %capital_of = (
    Bangladesh => 'Dhaka',
    Tuvalu     => 'Funafuti',
    Zimbabwe   => 'Harare',
    Eritrea    => 'Asmara',
    Botswana   => 'Gaborone',
);
```

How can we get several values out of it in one step?


Earlier we saw how to get [a slice of an array or an array reference](/array-slices),
this time we do something similar with hashes.

## Hash slice

If we have a hash like the `%capital_of` above we can access individual elements in it using `$` prefix
and curly braces after the name:

```perl
$capital_of{'Bangladesh'}
```

We can also create a list of some of the values be creating a list of these values:

```perl
($capital_of{'Zimbabwe'}, $capital_of{'Eritrea'}, $capital_of{'Botswana'})
```

We can assign them names of the capitals to an array:

```perl
my @african_capitals = ($capital_of{'Zimbabwe'}, $capital_of{'Eritrea'}, $capital_of{'Botswana'});

print Dumper \@african_capitals;
```

```
$VAR1 = [
          'Harare',
          'Asmara',
          'Gaborone'
        ];
```

If course listing "$hash_of" 3 times is already too much for most of us, but if we had to list the
capitals of all the African countries that would be really too much repetition.

Instead of that we use a syntax called `hash slice`. It returns a list of values.
In this syntax we put a `@` in front of the name of the hash and put curly braces `{}`
after it. Within the curly braces we put one or more keys of the hash. This will return the values
of the appropriate keys.

```perl
my @african_capitals = @capital_of{'Zimbabwe', 'Eritrea', 'Botswana'};
```

Results in the same list of capitals.

If you want to avoid the quotes and spaces you can also use [qw](/qw-quote-word):

```perl
my @african_capitals = @capital_of{qw(Zimbabwe Eritrea Botswana)};
```


The same would work no matter how we supply the keys of the hash, (the names of African countries). It can be an expression
including a function returning names or an array holding the names like here:

```perl
my @countries_in_africa = qw(Zimbabwe Eritrea Botswana);
my @african_capitals = @capital_of{ @countries_in_africa };
```

## Hash slice on the left-hand side

The same syntax can also be used on the left-hand side of the equation. For example:

```perl
@capital_of{'Belize', 'Kyrgyzstan'} = ('Belmopan', 'Bishkek');

print Dumper \%capital_of;
```

```
$VAR1 = {
          'Tuvalu' => 'Funafuti',
          'Eritrea' => 'Asmara',
          'Bangladesh' => 'Dhaka',
          'Zimbabwe' => 'Harare',
          'Kyrgyzstan' => 'Bishkek',
          'Belize' => 'Belmopan',
          'Botswana' => 'Gaborone'
        };
```

Here too we could use any expression in place of either of the lists:

```perl
my @countries = ('Belize', 'Kyrgyzstan');
my @capitals = ('Belmopan', 'Bishkek');
@capital_of{ @countries } = @capitals;
```

## Example

See the full sample script I used to generate the code snippets:

{% include file="examples/hash_slices.pl" %}

## Perl 5.20 and newer

As [Dave Cross](https://culturedperl.com/) pointed out, starting from Perl version 5.20 you can also write:

```
my %africa = %capital_of{'Zimbabwe', 'Eritrea', 'Botswana'};
```

## Comments

Terrific summary and reference, Gabor; I am going to save this post to Evernote because I know I am going to want to look it up every other month (or so). It seems like there are lots of esoteric descriptions of using hash slices in the most popular Perl Programming books (at least the ones on my shelf), but invariably I will try to use one to do something cool, and get the syntax ever so slightly wrong, and which point I try to remember where I read the most helpful description. Now it is here all in one handy place. Actually the way I used hash slices every week is described in Dave Cross' book "Data Munging with Perl" where he essentially slurps in a tab-separated ascii text file into an array of hashrefs using a nice hash slice (you have to grab the first row containing the column header/field names into an array first). Worth looking up (in my opinion) if you are not familiar with his book.

---
Dave Cross: And I should point out that the book is now available for free online. https://datamungingwithperl.com/

<h2>
And from Perl 5.20, there are the key/value hash slices that return list of key/value pairs.

my %africa = %capital_of{'Zimbabwe', 'Eritrea', 'Botswana'};

---
Thanks Dave & Gabor

%PERL_GURUS = %cool_guys{qw|gabor dave|}

<h2>
One another usage of hash slicing is also when you want to merge different hashes:

@merged{ keys %data } = values %data

Thanks for your great blog !

<h2>

Great article! Thank you. Question: how to use this syntaxt to get just the full list of African countries, or the full list of capitals by themselves.

Probably you are looking for `keys` and `values` functions.

<h2>
What's the syntax if you have a hash reference?
