use strict;
use warnings;
use 5.010;

sub fibo {
   my ($n) = @_;

   die 'There is no point in calling fibo() in VOID context'
       if not defined wantarray;

   my @fibo = (1, 1);
   push @fibo, $fibo[-1] + $fibo[-2] for 3 .. $n;

   return wantarray ? @fibo : $fibo[-1];
}

my @numbers = fibo(4);
say "@numbers";
my $value   = fibo(5);
say $value;
fibo(100);

