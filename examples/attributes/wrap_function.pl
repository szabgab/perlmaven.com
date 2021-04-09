use strict;
use warnings;
use 5.010;

use Attribute::Handlers;

sub Wrap : ATTR(CODE) {
    my ($package, $symbol, $referent, $attr, $data, $phase, $filename, $linenumber) = @_;
    my $function_name = *{$symbol}{NAME};

    my $new = sub {
        my $params = join ', ', @_;
        print "Before $function_name($params)\n";
        my @results = $referent->(@_);
        print "After $function_name($params) resulting in: (@results)\n";
        return @results;
    };

    no warnings qw(redefine);
    *$symbol = $new;
}

sub sum :Wrap {
    my $sum = 0;
    $sum += $_ for @_;
    return $sum;
}


say sum(2, 3);
say sum(-1, 1, 7);
