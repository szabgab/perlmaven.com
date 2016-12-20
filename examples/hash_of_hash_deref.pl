use 5.010;
use strict;
use warnings;
use Data::Dumper qw(Dumper);

my $hr = {
    player_a => {
   	    name => 'Foo',
        email => 'foo@corp.com',
    },
    player_b => {
   	    name => 'Bar',
        email => 'bar@corp.com',
    },
};

say $hr;
say $hr->{player_a};
say $hr->{player_b};


say Dumper $hr->{player_a};

say $hr->{player_b}{name};

