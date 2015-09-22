use strict;
use warnings;

my $xml = qq{<?xml version="1.0" encoding="UTF-8"?>\n\n};
$xml .= qq{<solar-system>\n};
$xml .= qq{  <planet name="Earth">\n};
$xml .= qq{  </planet>\n};
$xml .= qq{</solar_system>\n};

print $xml;


use XML::LibXML;
XML::LibXML->load_xml(string => $xml);

