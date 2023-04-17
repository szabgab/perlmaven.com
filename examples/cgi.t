use strict;
use warnings;

use Test::More;
use Capture::Tiny qw(capture);
use File::Temp qw(tempdir);

plan tests => 2;


subtest get => sub {
    plan tests => 5;

    local $ENV{REQUEST_METHOD} = 'GET';
    local $ENV{QUERY_STRING}   = 'name=foo&email=bar@corp.com';

    my ($out, $err, $exit) = capture { system "./cgi.pl" };

    #diag $out;
    like $out, qr{<tr><td>request_method</td><td>GET</td></tr>}, 'GET';
    like $out, qr{<tr><td>name</td><td>foo</td></tr>}, 'name';
    like $out, qr{<tr><td>email</td><td>bar\@corp.com</td></tr>}, 'email';
    is $err, '', 'stderr is empty';
    is $exit, 0, 'exit code is 0';
};

subtest post => sub {
    plan tests => 5;

    my $params = 'language=Perl&creator=TimToady';
    local $ENV{REQUEST_METHOD} = 'POST';
    local $ENV{CONTENT_LENGTH} = length($params);

    my $dir = tempdir(CLEANUP => 1);
    my $infile = "$dir/in.txt";
    open my $fh, '>', $infile or die "Could not open '$infile' $!";
    print $fh $params;
    close $fh;

    my ($out, $err, $exit) = capture { system "./cgi.pl < $infile" };

    #diag $out;
    like $out, qr{<tr><td>request_method</td><td>POST</td></tr>}, 'POST';
    like $out, qr{<tr><td>language</td><td>Perl</td></tr>}, 'language';
    like $out, qr{<tr><td>creator</td><td>TimToady</td></tr>}, 'creator';
    is $err, '', 'stderr is empty';
    is $exit, 0, 'exit code is 0';
};

