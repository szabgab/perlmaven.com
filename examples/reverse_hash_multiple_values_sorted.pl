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

for my $key (keys %owner_of) {
    @{ $owner_of{$key} } = sort @{ $owner_of{$key} };
}


print Dumper \%owner_of;

print "$owner_of{'1112222'}[1]\n";

for my $val (@{ $owner_of{"1112222"} }) {
    print "$val\n";
}

