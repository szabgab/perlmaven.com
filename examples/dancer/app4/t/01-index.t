use Test::More tests => 2;
use strict;
use warnings;

# the order is important
use App;
use Dancer::Test;


subtest index => sub {
    my $resp = dancer_response GET => '/';
    is $resp->status, 200;
    like $resp->content, qr{<h1>Echo with POST</h1>};
    like $resp->content, qr{<form};
};

subtest echo_post => sub {
    my $resp = dancer_response POST => '/echo', {
        params => {
            txt => 'Hello World!',
        }
    };
    is $resp->status, 200;
    is $resp->content, 'You sent: Hello World!'
};

