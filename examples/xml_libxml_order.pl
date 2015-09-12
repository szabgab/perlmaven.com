use strict;
use warnings;
use XML::LibXML;

my $dom = XML::LibXML->load_xml(location => 'order.xml');
print $dom->toString();

