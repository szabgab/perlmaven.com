use 5.010;
use strict;
use warnings;

use MongoDB 1.0.1;

my $name = shift or die "Usage: $0 NAME\n"; 

my $client = MongoDB::MongoClient->new;
my $db   = $client->get_database( 'test' );
my $col = $db->get_collection('counter');


my $res = $col->find_one_and_update(
    { _id => $name },
    {'$inc' => { val => 1}},
    {'upsert' => 1, new => 1},
);
say $res->{val};
