use strict;
use warnings;
use feature 'say';

use WWW::Mechanize;

my $url = 'https://httpbin.org/headers';

my $mech = WWW::Mechanize->new;
$mech->add_header("User-Agent" => "Internet Explorer/6.0");
$mech->add_header("api-key" => "Some API key");
$mech->get( $url );
#say $mech->status;
#say '---';
#say $mech->dump_headers;
#say '---';
say $mech->content;
