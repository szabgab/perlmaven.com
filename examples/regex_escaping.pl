use 5.010;
use strict;
use warnings;

say '\\' =~ /^(\\)/ ? "OK" : "NO MATCH!\n";   # OK
