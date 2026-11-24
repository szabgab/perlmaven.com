use v5.44;

use Data::Dumper qw(Dumper);


sub mymap($function, @inputs) {
    my @results;
    push @results, $function->($_) foreach @inputs;
    return @results;
}

{
    my @response = mymap( sub {  2 * shift }, 3, 4);
    say Dumper \@response;
}

{
    my @response = mymap( sub {  2 * shift });
    say Dumper \@response;
}


