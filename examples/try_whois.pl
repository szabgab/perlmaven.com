use strict;
use warnings;
use 5.010;

use Net::Whois::Raw;

$Net::Whois::Raw::CHECK_FAIL = 1;
$Net::Whois::Raw::OMIT_MSG = 1;

my $domain = shift or die "Usage: $0 DOMAIN\n";

my $data = whois($domain);
say $data;

