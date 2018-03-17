use strict;
use warnings;

ask_question();
my $answer = get_answer();
# some code
ask_question();
my $second_answer = get_answer();

########## sub declarations come here

sub ask_question {
  print "Have we arrived already?";
  return;
}

sub get_answer {
  my $answer = <STDIN>;
  chomp $answer;
  return $answer;
}

sub terminate {
   die "Hasta La Vista";
}

