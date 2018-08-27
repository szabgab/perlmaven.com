use strict;
use warnings;
use 5.010;
use Path::Tiny qw(path);
use Regexp::Grammars;
use Data::Dumper qw(Dumper);
$Data::Dumper::Sortkeys = 1;

my $parser = qr {
    <nocontext:>
    <Document> 

    <token: Document> \A   <Text>  \Z

    <token: Text>   <Text> (<Underscore> | <Star> | <Link> ) <FreeText> | <FreeText>

    <token: FreeText>     .+?
    <token: Underscore>  _ [^_]*? _
    <token: Star>        \* [^*]*? \*
    <token: Link>        link:[^\[]+\[[^]]+\]
}xms;


my $input = path('data/text_with_markup.txt')->slurp;

if ($input =~ $parser) {
    print Dumper \%/;
}

