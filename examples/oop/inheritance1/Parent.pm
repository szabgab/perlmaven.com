package Parent;
use strict;
use warnings;

use parent 'GrandParent';
#use base 'GrandParent';

sub say_hello {
    print "Hello from Parent\n";
}

1;
