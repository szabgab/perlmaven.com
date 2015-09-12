use strict;
use warnings;
use XML::Simple qw(XMLin XMLout);
use Data::Dumper qw(Dumper);


my $xml = XMLin('order.xml', ForceArray => 1, KeepRoot => 1);
print Dumper $xml;
