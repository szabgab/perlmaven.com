use strict;
use warnings;
use 5.010;
use Config;
use English qw($OSNAME);

say $^O;
say $OSNAME;
say $Config{'osname'};
