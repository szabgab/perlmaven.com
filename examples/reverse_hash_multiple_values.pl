use strict;
use warnings;
use Data::Dumper qw(Dumper);

my %phone_of = (
    'Foo' => '1112222',
    'Bar' => '3334444',
    'Qux' => '1112222',
);

my %owner_of;
for my $key (keys %phone_of) {
    my $value = $phone_of{$key};
    push @{ $owner_of{$value} }, $key;
}
print Dumper \%owner_of;


