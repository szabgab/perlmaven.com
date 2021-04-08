#!/usr/bin/env plackup
use strict;
use warnings;

use Plack::Request;

my $app = sub {
    my $env = shift;

    my $request = Plack::Request->new($env);
    my $html;
    if ($request->param('pid')) {
        $html = $$;
    } else {
        my $name = $request->param('name') || '';
        $html = "Hello $name\n";
    }

    return [
      '200',
      [ 'Content-Type' => 'text/html; charset=utf8' ],
      [ $html ],
    ];
};

