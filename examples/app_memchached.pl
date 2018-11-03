# app.pl memcached – incr needs a default value and it cannot be 0 (which might be a bug in this client)

#!/usr/bin/env perl
use strict;
use warnings;
use 5.010;

use Mojolicious::Lite;
use Memcached::Client;
my $cache = Memcached::Client->new({servers => ['127.0.0.1:8887']});;
my $LIMIT = 5;

get '/' => sub {
    my $c = shift;

    my $counter = $cache->incr('counter', 1, 1);
    $c->render(text => "$counter $$\n");
};

app->start;

get '/' => sub {

    my $c = shift;
    my $time = time;
    my $limit = $cache->incr("count_$time", 1, 1) || 0; # how can $limit be undef? Another bug
    if ($limit >= $LIMIT) {
        $c->render(text => "Rate limit reached ($limit - $time)\n");
        return;
    }
    my $counter = $cache->incr('counter', 1, 1);
    $c->render(text => "$counter $$\n");
};
