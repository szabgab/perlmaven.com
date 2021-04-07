#!/usr/bin/env plackup
use strict;
use warnings;

use Plack::Request;

my $app = sub {
    my $env = shift;

    my $request = Plack::Request->new($env);
    my $name = $request->param('name') || '';

    return [
      '200',
      [ 'Content-Type' => 'text/html; charset=utf8' ],
      [ "Hello $name\n" ],
    ];
};

# plackup files/var/cgi-bin/app.psgi
