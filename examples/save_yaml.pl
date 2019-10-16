use strict;
use warnings;
use YAML qw(DumpFile);

my %data = (
    name => 'Foo Bar',
    email => 'foo@bar.com',
    ids   => [12, 23 ,78],
);

DumpFile('data.yml', \%data);
