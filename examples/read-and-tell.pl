use strict;
use warnings;
use 5.010;

my $filename = shift or die "Usage: $0 FILENAME\n";

open my $fh, '<', $filename or die;

my $cont = <$fh>;
print "'$cont'\n";
say length $cont;
say tell $fh;

read $fh, $cont, 20;
print "'$cont'\n";
say length $cont;
say tell $fh;

