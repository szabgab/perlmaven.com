use Test::More tests => 7;
use strict;
use warnings;

# the order is important
use App;
use Dancer::Test;

my $text1 = 'Hello World!';
my $text2 = 'Some other text';

subtest index => sub {
    my $resp = dancer_response GET => '/';
    is $resp->status, 200;
    like $resp->content, qr{<h1>Session</h1>};
    like $resp->content, qr{<form};
    like $resp->content, qr{<b></b>};
};

subtest save => sub {
    my $resp = dancer_response POST => '/save', {
        params => {
            txt => $text1,
        }
    };
    is $resp->status, 200;
    like $resp->content, qr{You sent: <b>$text1</b>};
};

subtest index => sub {
    my $resp = dancer_response GET => '/';
    is $resp->status, 200;
    like $resp->content, qr{<h1>Session</h1>};
    like $resp->content, qr{<form};
    like $resp->content, qr{<b>$text1</b>};
};

subtest save => sub {
    my $resp = dancer_response POST => '/save', {
        params => {
            txt => $text2,
        }
    };
    is $resp->status, 200;
    like $resp->content, qr{You sent: <b>$text2</b>};
};

subtest index => sub {
    my $resp = dancer_response GET => '/';
    is $resp->status, 200;
    like $resp->content, qr{<h1>Session</h1>};
    like $resp->content, qr{<form};
    like $resp->content, qr{<b>$text2</b>};
};

subtest delete => sub {
    my $resp = dancer_response GET => '/delete';
    is $resp->status, 200;
    like $resp->content, qr{DONE};
};


subtest index => sub {
    my $resp = dancer_response GET => '/';
    is $resp->status, 200;
    like $resp->content, qr{<h1>Session</h1>};
    like $resp->content, qr{<form};
    like $resp->content, qr{<b></b>};
};


