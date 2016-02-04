use strict;

sub compute {
    my ($param) = @_;

    # ...
    return $param or 'default';
}

print '1: ', compute('hello'), "\n";
print '2: ', compute(''), "\n";

