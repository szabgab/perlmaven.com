use strict;
use warnings;

my $copyrightsfile = shift @ARGV;
my @COPYRIGHTS;

open my $COPYR, '<', $copyrightsfile or die "Can't open copyrights $copyrightsfile";
while(my $line = <$COPYR>){
    chomp $line;
    next if $line =~ /^#/;
    my ($firstname, $lastname) = split /,/, $line;
    next if not defined $lastname or $lastname eq '';
    push @COPYRIGHTS,{
        firstname => $firstname,
        lastname => $lastname,
    };
}
close $COPYR;

use Data::Dumper qw(Dumper);
print Dumper \@COPYRIGHTS;
