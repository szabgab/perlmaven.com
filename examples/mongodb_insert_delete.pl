#!/usr/bin/perl
use strict;
use warnings;
use 5.010;

use MongoDB;

my $client = MongoDB::MongoClient->new( host => 'localhost', port => 27017 );
my $db_name = 'example_' . $$ . '_' . time;
#say $db_name;

my $database = $client->get_database($db_name);
my $collection = $database->get_collection('data');

$collection->insert_one({
    cpan => {
        name => 'Foo',
        version => 1,
    },
});

$collection->insert_one({
    cpan => {
        name => 'Foo',
        version => 2,
    },
});

$collection->insert_one({
    cpan => {
        name => 'Bar',
        version => 1,
    },
});

say '-----';
foreach my $e ($collection->find->all) {
    say "$e->{cpan}{name} $e->{cpan}{version}";
}

say '-----';
foreach my $e ($collection->find({ 'cpan.name' => 'Foo' })->all) {
    say "$e->{cpan}{name} $e->{cpan}{version}";
}

$collection->delete_one({ 'cpan.version' => 2 });

say '-----';
foreach my $e ($collection->find({ 'cpan.name' => 'Foo' })->all) {
    say "$e->{cpan}{name} $e->{cpan}{version}";
}

$database->drop;

