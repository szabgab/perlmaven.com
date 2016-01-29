use strict;
use warnings;
use Data::Dumper qw(Dumper);

my %capital_of = (
    Bangladesh => 'Dhaka',
    Tuvalu     => 'Funafuti',
    Zimbabwe   => 'Harare',
    Eritrea    => 'Asmara',
    Botswana   => 'Gaborone',
);

#my @african_capitals = @capital_of{'Zimbabwe', 'Eritrea', 'Botswana'};
#my @african_capitals = @capital_of{qw(Zimbabwe Eritrea Botswana)};
my @countries_in_africa = qw(Zimbabwe Eritrea Botswana);
#my @african_capitals = @capital_of{ @countries_in_africa };

#print Dumper \@african_capitals;

#@capital_of{'Belize', 'Kyrgyzstan'} = ('Belmopan', 'Bishkek');

my @countries = ('Belize', 'Kyrgyzstan');
my @capitals = ('Belmopan', 'Bishkek');
#@capital_of{ @countries } = @capitals;

#print Dumper \%capital_of;


