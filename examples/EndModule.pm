package EndModule;
use strict;
use warnings;

END {
    print "in END of EndModule\n";
}

sub some_code {
    print "in some_code\n";
}

1;

