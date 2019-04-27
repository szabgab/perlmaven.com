use 5.010;
use strict;
use warnings;
use IO::Prompter;


my $selection = prompt 'Choose wisely...', -menu => [qw(wealth health wisdom)], '>';
say $selection;
