use strict;
use warnings;
use 5.010;

use JSON ();
use JSON::XS ();
use Benchmark qw(cmpthese);

my $json = create_json(100);

cmpthese(10000, {
    'JSON'     => sub { JSON::decode_json($json) },
    'JSON::XS' => sub { JSON::XS::decode_json($json) },
});

sub create_json {
    my ($n) = @_;
    my @data = map { { $_ => $_ } } 1 .. $n;
    return JSON::encode_json \@data;
}

