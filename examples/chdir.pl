use 5.010;
use strict;
use warnings;

use Cwd qw(getcwd);

say getcwd();
system 'pwd';


chdir "/home";
say getcwd();
system 'pwd';


