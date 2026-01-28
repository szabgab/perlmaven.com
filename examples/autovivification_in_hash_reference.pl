use strict;
use warnings;

use Data::Dumper qw(Dumper);

my $phone_of;

print Dumper $phone_of;
$phone_of->{Foo} = '123-456';
print Dumper $phone_of;

