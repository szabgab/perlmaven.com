use 5.010;
use strict;
use warnings;
use IO::Prompter;

my $user = prompt 'Username:';
my $passwd = prompt 'Password:', -echo=>'*';

say $user;
say $passwd;
