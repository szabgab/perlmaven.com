use strict;
use warnings;
use 5.010;

use Devel::Size qw(size total_size);

my $x;
my @y;
my %z;

say '                           size  total_size';
both('SCALAR', \$x);        #    24    24
both('ARRAY',  \@y);        #    64    64
both('HASH',   \%z);        #   120   120
both('CODE', sub {} );      #  8452  8452
say '';

both('SCALAR', \$x);        #  24    24
$x = 'x';
both('SCALAR-1', \$x);      #  56    56
$x = 'x' x 15;
both('SCALAR-15', \$x);     #  56    56
$x = 'x' x 16;
both('SCALAR-16', \$x);     #  72    72
$x = 'x' x 31;
both('SCALAR-31', \$x);     #  72    72
$x = 'x' x 32;
both('SCALAR-32', \$x);     #  88    88
$x = '';
both('SCALAR=""', \$x);     #  88    88
$x = undef;
both('SCALAR=undef', \$x);  #  88    88
undef $x;
both('undef SCALAR', \$x);  #  40    40
say '';

both('ARRAY',  \@y);               #    64    64
@y = ('x');
both('ARRAY-1', \@y);              #    96   152
@y = ('x' x 15);
both('ARRAY-15', \@y);             #    96   152
@y = ('x' x 16);
both('ARRAY-16', \@y);             #    96   168
@y = ('x' x 31);
both('ARRAY-31', \@y);             #    96   168
@y = ('x' x 32);
both('ARRAY-32', \@y);             #    96   184
@y = ('x') x 2;
both('ARRAY-1-1', \@y);            #    96   208
@y = ('x') x 4;
both('ARRAY-1-1-1-1', \@y);        #    96   320
@y = ('x') x 5;
both('ARRAY-1-1-1-1-1', \@y);      #   104   384
@y = ('x') x 6;
both('ARRAY-1-1-1-1-1-1', \@y);    #   112   448
@y = ('x') x 7;
both('ARRAY-1-1-1-1-1-1-1', \@y);  #   128   520
@y = ();
both('ARRAY = ()', \@y);           #   128   128
undef @y;
both('undef ARRAY', \@y);          #    64    64
say('');

both('HASH',   \%z);                       #  120   120
%z = ('x' => undef);
both('HASH x => undef',   \%z);            #  179   203
%z = ('x' => "x");
both('HASH x => "x"',   \%z);              #  179   235
%z = ('x' x 10 => "x" x 20);
both('HASH "x" x 10 => "x" x 20',   \%z);  #  188   260
for my $c (qw(a b c d e f g h i)) {
    $z{$c x 10} = $c x 20;
}
both('HASH 10 * 10 + 10 * 20',   \%z);     #  864  1584
%z = ();
both('HASH=()',   \%z);                    #  184   184
undef %z;
both('undef HASH',   \%z);                 #  120   120
my $o = bless \%z,'Some::Very::Long::Class::Name::That::Probably::Noone::Uses';
both('blessed HASH', $o);                  #  120   120
say('');

both('CODE', sub {}  );                   #  8516  8516
both('CODE2', sub { my $w }  );           #  8612  8612
both('CODE3', sub { my $w = 'a' }  );     #  8820  8820

sub both {
    my ($name, $ref) = @_;
    printf "%-25s %5d %5d\n", $name, size($ref), total_size($ref);
}

