use strict;
use warnings;

my $answer = prompt();
# some code
my $second_answer = prompt();

sub prompt {
   print "Have we arrived already?";

   my $answer = <STDIN>;
   chomp $answer;
   return $answer;
}

