use strict;
use warnings;
use XML::Writer;

my $writer = XML::Writer->new(OUTPUT => 'self', DATA_MODE => 1, DATA_INDENT => 2, );
$writer->xmlDecl('UTF-8');
$writer->startTag('people');

$writer->startTag('user', name => 'Foo');
$writer->characters('content');
$writer->endTag('user');

$writer->dataElement('user', 'content', name => 'Bar');

$writer->emptyTag('img', src => 'xml.png');

$writer->endTag('people');

my $xml = $writer->end();
print $xml;

use XML::LibXML;
XML::LibXML->load_xml(string => $xml);

