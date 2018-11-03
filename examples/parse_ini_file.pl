use strict;
use warnings;
use 5.010;
use Regexp::Grammars;
use Data::Dumper qw(Dumper);
$Data::Dumper::Sortkeys = 1;

my $parser = qr {
    <nocontext:>
    <INI>
    
    <rule: INI>    <[Section_Row]>* <[Section]>*

    <rule: Section>  <Section_Title> <[Section_Row]>*

    <rule: Section_Title>  ^\s*\[ <Title> \]\s*$

    <token: Title>   [^\]]*?

    <rule: Section_Row>   <Pair> | <Comment>

    <rule: Comment>    ^\s*\#.*?$

    <rule: Pair>    ^\s*<Key> <Sep> <Value>$

    <token: Sep>     =
    <token: Key>     .*?
    <token: Value>   .*\S

}xm;

my @examples = (
q{
generic = 42

[Multi Part Name]
specific = 19
   # Some comment
  other key   = space name

[Rest] 
specific = 23

},
);

foreach my $input (@examples) {
    if ($input =~ $parser) {
        print Dumper \%/;
    }
}

