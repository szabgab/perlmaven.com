use strict;
use warnings;
use LWP::Simple qw(get);

my $url = 'https://perlmaven.com/';
my $html = get $url;

print($html);
