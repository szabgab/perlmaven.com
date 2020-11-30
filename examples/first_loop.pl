use strict;
use warnings;
use 5.010;

my @animals = ('snake', 'camel', 'etruscan shrew', 'ant', 'hippopotamus', 'giraffe');

my $first;
for my $animal (@animals) {
    if (length($animal) > 5) {
        $first = $animal;
        last;
    }
}
say $first;  # etruscan shrew
