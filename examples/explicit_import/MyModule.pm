package MyModule;
use strict;
use warnings;

use Exporter qw(import);
our @EXPORT = qw(greeting);

sub greeting {
    print "Hello World!\n";
}
1;
