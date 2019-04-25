use Test::More tests => 2;
use strict;
use warnings;

# the order is important
use App;
use Dancer::Test;


my $resp = dancer_response GET => '/';
is $resp->status, 200;
is $resp->content, 'Hello World';
