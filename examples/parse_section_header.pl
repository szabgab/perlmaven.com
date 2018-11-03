use strict;
use warnings;
use 5.010;
use Regexp::Grammars;
use Data::Dumper qw(Dumper);

my $parser = qr {
    <nocontext:>
    <Section>

    <rule: Section>   \[ <Title> \]

    <token: Title>   [^\]]*
}x;

my @examples = (
    '[name]  ',
    '[Multi Part Name]  ',
);

foreach my $input (@examples) {
    if ($input =~ $parser) {
        print Dumper \%/;
    }
}

