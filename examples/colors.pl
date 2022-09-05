use strict;
use warnings;
use feature 'say';

my $black   = "\033[0;30m";
my $red     = "\033[0;31m";
my $green   = "\033[0;32m";
my $yellow  = "\033[0;33m";
my $white   = "\033[0;37m";
my $nocolor = "\033[0m";

say("Plain text in the default color");
say($green);
say("Green text");
say($red);
say("Red text");
say("$yellow yellow $green green $red red");
say($white);
say("White text");
say($black);
say("Black text");
