use strict;
use warnings;
use 5.010;
use Data::Dumper qw(Dumper);
use Path::Tiny qw(path);
use Regexp::Grammars;

my $input = path('data/text_with_paragraphs.txt')->slurp();

my $parser = qr{
    <nocontext:>
    <Text>

    <rule: Text>   \A  <[Paragraph]>+ % <_Sep=(\n\s*\n)> \Z

    <token: Paragraph>   ^.*?$
}xsm;


if ($input =~ $parser) {
    print Dumper \%/;
}


