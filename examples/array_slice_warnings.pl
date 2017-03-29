use strict;
use warnings;

my $str = "root:*:0:0:System Administrator:/var/root:/bin/sh";
my @fields = split /:/, $str;

my $num="0,4";
my ($username, $real_name) = @fields[$num];

print "$username\n";
print "$real_name\n";
