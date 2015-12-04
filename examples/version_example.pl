use strict;
use warnings;
use 5.010;

use version;

say version->parse( 1.23 ) < version->parse( 1.24 );

