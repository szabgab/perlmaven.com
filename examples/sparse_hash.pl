use strict;
use warnings;
use 5.010;

my %h = (
   23 => 'twenty three',
   42 => 'forty two',
   1_000 => 'thousand',
   1_000_000 => 'million',
);

for my $k (keys %h) {
    say $k;
}

say '';
for my $k (sort {$a <=> $b} keys %h) {
    say $k;
}

