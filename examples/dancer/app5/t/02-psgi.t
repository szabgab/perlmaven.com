use Test::More tests => 4;
use strict;
use warnings;

# the order is important
use App;
use Test::WWW::Mechanize::PSGI;


my $text1 = 'Hello World!';
my $text2 = 'Some other text';


my $mech1 = Test::WWW::Mechanize::PSGI->new( app => Dancer::Handler->psgi_app );
my $mech2 = Test::WWW::Mechanize::PSGI->new( app => Dancer::Handler->psgi_app );

subtest index => sub {
    $mech1->get_ok( '/' );
    $mech1->content_like( qr{<h1>Session</h1>} );
    $mech1->content_like( qr{<b></b>} );
};

subtest save => sub {
    $mech1->post_ok('/save', {
            txt => $text1,
    });
    $mech1->content_like( qr{You sent: <b>$text1</b>} );
};


subtest index => sub {
    $mech1->get_ok( '/' );
    $mech1->content_like( qr{<h1>Session</h1>} );
    $mech1->content_like( qr{<b>$text1</b>} );
};


subtest index_another_browser => sub {
    $mech2->get_ok( '/' );
    $mech2->content_like( qr{<h1>Session</h1>} );
    $mech2->content_like( qr{<b></b>} );
};

