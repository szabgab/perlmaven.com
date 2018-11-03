use strict;
use warnings;
use 5.010;
use Regexp::Grammars;
use Data::Dumper qw(Dumper);

my $parser = qr {
    <nocontext:>
    <Pair>

    <rule: Pair>    <Key> <Sep> <Value>

    <token: Sep>     =
    <token: Key>     [^=]*?
    <token: Value>   .*\S
}x;

my @examples = (
    'foo=bar',
    'apple=  banana',
    'name   = Foo Bar',
    'main field   = Alma Mater  ',
    '   space field = Star Wars ',
);

foreach my $input (@examples) {
    if ($input =~ $parser) {
        print Dumper \%/;
    }
}

