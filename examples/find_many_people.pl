use strict;
use warnings;
use Data::Dumper qw(Dumper);

our $people;
do 'people.pl';


my %lookup = map { $_->{id} => $_ } @$people;
#print Dumper \%lookup;

die "Usage: $0 IDs\n" if not @ARGV;
foreach my $id (@ARGV) {
    print Dumper $lookup{$id};
}
