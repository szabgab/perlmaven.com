use strict;
use warnings;
use feature 'say';

use WWW::Mechanize;

my $url = 'https://httpbin.org/headers';

my $mech = WWW::Mechanize->new;
$mech->get( $url );
say $mech->status;
say '---';
say $mech->dump_headers;
say '---';
say $mech->content;
