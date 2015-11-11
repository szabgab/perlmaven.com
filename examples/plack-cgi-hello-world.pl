#!/usr/bin/env plackup
use strict;
use warnings;

sub {
  return [
    '200',
    [ 'Content-Type' => 'text/html' ],
    [ 'Hello World!' ],
  ];
};

