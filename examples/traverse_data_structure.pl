use strict;
use warnings;

my %h = (
    name => 'Foo',
    phones => [ 
        {
           name => 'home',
           num  => '123',
        },
        {
           name => 'work',
           num  => '456',
        }
    ],
    addresses => {
        street => 'Sesame',
        number => 42,
        city   => 'New York City'
    }
);

sub _print {
    my ($depth, $value) = @_;
    print "  " x $depth;
    print $value;
}

sub process {
    my ($o, $depth) = @_;
    $depth //= 0;

    if (not ref $o) {
        _print $depth, "$o\n";
        return;
    }
    if ('HASH' eq ref $o) {
         for my $k (sort keys %$o) {
             _print $depth, "$k\n";
             process($o->{$k}, $depth+1);
         }
         return;
    }

    if ('ARRAY' eq ref $o) {
         for my $k (@$o) {
             _print $depth, "$k\n";
             process($k, $depth+1);
         }
         return;
    }
    die "Unhandled ref " . ref $o;
}

process(\%h);

# my @queue = (\%h);
# while (my $o = shift @queue) {
#     next if not ref $o;
#     if ('HASH' eq ref $o) {
#         for 
#         print 
#         push @queue, values %$o;
#     }
# 
# }
