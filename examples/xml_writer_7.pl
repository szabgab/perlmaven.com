use strict;
use warnings;
use XML::Writer;

my $writer = XML::Writer->new(OUTPUT => 'self', DATA_MODE => 1, DATA_INDENT => 2, );
$writer->xmlDecl('UTF-8');
$writer->startTag('te<xt');
$writer->endTag();
my $xml = $writer->end();
print $xml;

use XML::LibXML;
XML::LibXML->load_xml(string => $xml);


