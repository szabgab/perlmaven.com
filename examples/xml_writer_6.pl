use strict;
use warnings;
use XML::Writer;

my $writer = XML::Writer->new(OUTPUT => 'self', DATA_MODE => 1, DATA_INDENT => 2, );
$writer->xmlDecl('UTF-8');
$writer->startTag('text');
$writer->characters("42 < 100 & 42 > 21");
$writer->endTag();
my $xml = $writer->end();
print $xml;


