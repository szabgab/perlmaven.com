use strict;
use warnings;
use 5.010;

my $kings = ['Baldwin', 'Melisende', 'Fulk', 'Amalric', 'Guy', 'Conrad'];

my @names = ($kings->[2], $kings->[4], $kings->[1]);
say join ', ', @names;    # Fulk, Guy, Melisende


my @slice = @{$kings}[2,4,1];
say join ', ', @slice;    # Fulk, Guy, Melisende


