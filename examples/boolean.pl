use strict;
use warnings;
use 5.010;

my $x;
my @arr;
my %hash;

if ($x) {
    say 'undef is true';
} else {
    say 'undef is false';
}

if (@arr) {
    say 'empty array is true';
} else {
    say 'empty array is false';
}

if (%hash) {
    say 'empty hash is true';
} else {
    say 'empty hash is false';
}

my @values = (0, 0.00, '', '0', '00', "0\n", [], {}, 'true', 'false');
for my $value (@values) {
    if ($value) {
        say "$value is true";
    } else {
        say "$value is false";
    }
}


