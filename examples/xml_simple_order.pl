use strict;
use warnings;
use XML::Simple qw(XMLin XMLout);

my $xml = XMLin('order.xml', ForceArray => 1, KeepRoot => 1);
print XMLout($xml, KeepRoot => 1);
