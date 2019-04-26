use Test::More tests => 3;
use strict;
use warnings;

# the order is important
use App;
use Dancer::Test;


subtest index => sub {
    my $resp = dancer_response GET => '/';
    is $resp->status, 200;
    like $resp->content, qr{<h1>Echo with GET</h1>};
    like $resp->content, qr{<form};
};

subtest echo_get_1 => sub {
    my $resp = dancer_response GET => '/echo?txt=Hello World!';
    is $resp->status, 200;
    is $resp->content, 'You sent: Hello World!'
};

subtest echo_get_2 => sub {
    my $resp = dancer_response GET => '/echo', {
        params => {
            txt => 'Hello World!',
        }
    };
    is $resp->status, 200;
    is $resp->content, 'You sent: Hello World!';
};

