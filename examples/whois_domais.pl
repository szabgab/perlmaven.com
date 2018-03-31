use strict;
use warnings;
use 5.010;

use Net::Whois::Raw;
use Path::Tiny qw(path);

$Net::Whois::Raw::CHECK_FAIL = 1;
$Net::Whois::Raw::OMIT_MSG = 1;

my @domains = path($0)->parent->child('domains.txt')->lines( { chomp => 1 } );
if (@ARGV) {
    @domains = @ARGV;
}

foreach my $domain (@domains) {
    my $data = whois($domain);
    say $data;
}

