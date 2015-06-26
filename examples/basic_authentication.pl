use strict;
use warnings;
use v5.10;
use LWP::UserAgent;
use HTTP::Request::Common;

my $ua = LWP::UserAgent->new();
my $request = GET 'https://pause.perl.org/pause/authenquery';

$request->authorization_basic('szabgab', '*******');

my $response = $ua->request($request);
say $response->as_string();
