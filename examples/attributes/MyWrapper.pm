package MyWrapper;
use strict;
use warnings;

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

1;
