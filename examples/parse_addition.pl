use strict;
use warnings;
use 5.010;
use Regexp::Grammars;
use Data::Dumper qw(Dumper);

my $parser = qr{
    <nocontext:>
    <Expression>

    <rule: Expression>    <Left_Operand> <Operator> <Right_Operand>

    <token: Left_Operand>   \d+
    <token: Right_Operand>   \d+
    <token: Operator>  \+
}x;

my @examples = (
    '2+3',
    '7 + 8',
    '  19   + 23  ',
);

foreach my $input (@examples) {
    if ($input =~ $parser) {
        print Dumper \%/;
    }
}

