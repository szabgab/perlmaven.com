use strict;
use warnings;
use 5.010;
use Data::Dumper qw(Dumper);
use Path::Tiny qw(path);
use Regexp::Grammars;

my $input = path('data/text_with_paragraphs.txt')->slurp();

my $parser = qr{
    <nocontext:>
    <Document>

    <rule: Document>    \A <Text> \Z

    <rule: Text>   <[Paragraph]>+ % <Sep>

    <token: Sep>    \n\n

    <token: Paragraph>   ^.*?$
}xsm;

if ($input =~ $parser) {
    print Dumper \%/;
}


