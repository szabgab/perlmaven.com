use strict;
use warnings;
use Data::Dumper qw(Dumper);

my @keys = ('name1', 'name2', 'name3');
my @values = (['name11', 'name21', 'name31'], ['name12', 'name22', 'name32'], ['name13', 'name23', undef]);

my %hash;

@hash{@keys} = @values;

print Dumper \%hash;


