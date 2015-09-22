use strict;
use warnings;
use XML::Writer;

my $writer = XML::Writer->new(OUTPUT => 'self', DATA_MODE => 1, DATA_INDENT => 2, );
$writer->xmlDecl('UTF-8');
$writer->startTag('people');
$writer->endTag('people');
$writer->endTag('people');
print "OK\n";
my $xml = $writer->end();
