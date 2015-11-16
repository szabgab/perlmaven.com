#!/usr/bin/env plackup
use strict;
use warnings;

use Plack::Request;

sub {
    my ($env) = @_;

    my $request = Plack::Request->new($env);
    my $name = $request->param('name') || '';

    return [
        '200',
        [ 'Content-Type' => 'text/html' ],
        [ "Hello $name" ],
    ];
};
