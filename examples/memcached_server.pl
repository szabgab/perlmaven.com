use strict;
use warnings;
use Memcached::Server::Default;
use AE;

Memcached::Server::Default->new(
    open => [[0, 8888]]
);

AE::cv->recv;
