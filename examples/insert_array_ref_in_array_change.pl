use strict;
use warnings;
use 5.010;
use Data::Dumper;

my @names = qw(Foo Bar Baz);
my @languages = qw(Perl Python Ruby PHP);

splice @names, 1, 1, \@languages;

print Dumper \@names;

say $names[1][2];



print Dumper $names[1];

$languages[2] = "JavaScript";

say '';
print Dumper \@languages;
print Dumper \@names;


