use strict;
use warnings;
use Test::More;
use Test::LongString;
use Capture::Tiny qw(capture);

{
    my ($out, $err, $exit) = capture { system q{files/var/cgi-bin/app.cgi} };
    is $exit, 0;
    is $err, '';
    is_string $out, "Content-Type: text/html; charset=utf8\r\n\r\nHello \n";
}

{
    my ($out, $err, $exit) = capture { system q{files/var/cgi-bin/app.cgi name='Foo Bar'} };
    is $exit, 0;
    is $err, '';
    is_string $out, "Content-Type: text/html; charset=utf8\r\n\r\nHello Foo Bar\n";
}

done_testing;
