#!/usr/bin/env perl
use strict;
use warnings;
use 5.010;

use JSON::MaybeXS ();
use Path::Tiny qw(path);

use lib 'lib';
use Markua::Parser;

for my $input_file (glob "t/input/*.md") {
    #say $input_file;
    my $case = substr $input_file, 8, -3;
    my $m = Markua::Parser->new;
    my ($result, $errors) = $m->parse_file($input_file);
    my $json = JSON::MaybeXS->new(utf8 => 1, pretty => 1, sort_by => 1);
    path("t/dom/$case.json")->spew_utf8($json->encode($result));

    if (@$errors) {
        path("t/errors/$case.json")->spew_utf8($json->encode($errors));
    }
}
