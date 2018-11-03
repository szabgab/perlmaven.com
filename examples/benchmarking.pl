use strict;
use warnings;

sub a { $_[0] =~ /x/; }
sub b { 
    for my $i (0..length($_[0])-1) {
        return 1 if substr($_[0], $i, 1) eq "x";
    }
    return;
}
sub c { 
    for my $c (split //, $_[0]) {
        return 1 if $c eq 'x'
    }
    return;
}
sub d { my $r = "x"; $_[0] =~ /$r/; }
sub e { index($_[0], 'x') > -1 }

my $str = "qwertyuiopasdfghjklzxcvbnm";

a($str) for 1..10;
b($str) for 1..20;
c($str) for 1..30;
d($str) for 1..50;
e($str) for 1..100;

# perl -d:NYTProf full.pl
