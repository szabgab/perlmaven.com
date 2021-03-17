use strict;
use warnings;
use 5.010;

my $text = 'Some text with a number: 23 and an answer: 42 and more';
if ($text =~ /(\w+):\s+(\d+)/) {
    say $1;  # number
    say $2;  # 23
}


if ($text =~ /((\w+):\s+(\d+))/) {
    say $1;  # number: 23
    say $2;  # number
    say $3;  # 23
}
