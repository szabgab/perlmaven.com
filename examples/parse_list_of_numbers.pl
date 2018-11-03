use strict;
use warnings;
use 5.010;
use Regexp::Grammars;
use Data::Dumper qw(Dumper);

my $parser = qr {
    <nocontext:>
    <List>

    <rule: List>   <[Number]>* % (\s+) 

    <token: Number>  \d+ 
}x;

my @examples = (
    '42',
    '19  23 9',
    '',
);

foreach my $input (@examples) {
    if ($input =~ $parser) {
        print Dumper \%/;
    }
}

