use strict;
use warnings;
use 5.010;
use List::Util qw(first);

my @animals = ('snake', 'camel', 'etruscan shrew', 'ant', 'hippopotamus', 'giraffe');

my ($first_with_grep) = grep { my_cond($_) } @animals;
say $first_with_grep;
say '---------';

my $first_with_first = first { my_cond($_) } @animals;
say $first_with_first;

sub my_cond {
    my ($str) = @_;
    say "length of $str";
    return length($str) > 5;
}
