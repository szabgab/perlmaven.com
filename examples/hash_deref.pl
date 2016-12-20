use 5.010;
use strict;
use warnings;
use Data::Dumper qw(Dumper);

my $hr = {
   	name => 'Foo',
    email => 'foo@corp.com',
};

say $hr;

say Dumper $hr;

my %h = %$hr;

say $h{name};

say $hr->{name};  # arrow notation - this is the preferred one!

say $$hr{name};   # stacked sigils - not recommended

