use strict;
use warnings;

my $first_name = prompt("First name: ");
my $last_name = prompt("Last name: ");

sub prompt {
   my ($text) = @_;
   print $text;

   my $answer = <STDIN>;
   chomp $answer;
   return $answer;
}

