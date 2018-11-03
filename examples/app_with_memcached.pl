#!/usr/bin/env perl
use Mojolicious::Lite;
use Memcached::Client;
my $cache = Memcached::Client->new({servers => ['127.0.0.1:8888']});;

get '/' => sub {

    my $c = shift;

    my $counter = $cache->incr('counter');
    $c->render(text => "$counter $$\n");
};


app->start;
