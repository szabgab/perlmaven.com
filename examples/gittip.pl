use strict;
use warnings;
use 5.010;

use LWP::UserAgent;
use MIME::Base64;

my $ua = LWP::UserAgent->new;

my $url = 'https://www.gittip.com/for/communities.json';
$ua->default_header('Authorization',  "Basic " . MIME::Base64::encode('123-456:', '') );
my $resp = $ua->get( $url );
say $resp->status_line;
say $resp->decoded_content;

