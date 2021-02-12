use strict;
use warnings;
use 5.010;

use LWP::UserAgent;
use JSON qw(encode_json);
use POSIX ();
use HTTP::Request::Common qw(POST);

send_data();

sub send_data {
    my $ua = LWP::UserAgent->new(timeout => 10);
    my %data = (
        timestamp => POSIX::strftime("%Y-%m-%dT%H:%M:%S", gmtime()),
        dice => int(rand(6)),
    );

    my $json = encode_json \%data;
    say $json;

    my $req = POST 'http://elastic.server:9200/perl/doc/';
    $req->header( 'Content-Type' => 'application/json' );
    $req->content( $json );
    my $response = $ua->request($req);
    if ($response->is_success) {
        say 'OK', $response->decoded_content;
    }
    else {
        say 'BAD', $response->status_line;
    }
}


