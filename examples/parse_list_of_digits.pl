use strict;
use warnings;
use 5.010;
use Regexp::Grammars;
use Data::Dumper qw(Dumper);

my $parser = qr {
    <nocontext:>
    <List>

    <rule: List>   <[Digit]>*

    <token: Digit>  \d
}x;

my @examples = (
    '42',
    '1923',
    '',
);

foreach my $input (@examples) {
    if ($input =~ $parser) {
        print Dumper \%/;
    }
}


