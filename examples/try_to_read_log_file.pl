use strict;
#use warnings;

my $filename = '/tmp/application.conf';

open(F, "<$filename");
while(<F>) {
   # do something with $_
}
close F;

