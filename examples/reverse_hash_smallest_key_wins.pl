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
    if (exists $owner_of{$value}) {
        if ($key lt $owner_of{$value}) {
            $owner_of{$value} = $key;
        }
    } else {
        $owner_of{$value} = $key;
    }
}
print Dumper \%owner_of;

