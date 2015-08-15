use 5.010;
use strict;
use warnings;

sub memoize {
    my ($func) = @_;

    my $original = \&{$func};
    my %cache;
    my $sub = sub {
        my ($n) = @_;
        if (not exists $cache{$n}) {
            $cache{$n} = $original->($n);
        }
        return $cache{$n};
    };
    no strict 'refs';
    no warnings 'redefine';
    *{$func} = $sub;
}

sub fibonacci {
    my ($n) = @_;
    say "fibonacci($n)";
    return 1 if $n == 1 or $n == 2;
    return fibonacci($n-1) + fibonacci($n-2);
}

memoize('fibonacci');

say fibonacci(6);
