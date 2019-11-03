use strict;
use warnings;
use 5.010;
use DateTime;

my $filename = shift or die "Usage: $0 FILENAME\n";

my @stat = stat($filename);
say $stat[9];

my $modify_time = (stat($filename))[9];
say $modify_time;
say scalar localtime($modify_time);

my $dt = DateTime->from_epoch( epoch => $modify_time );
say $dt;


my $modify_days = -M $filename;
say $modify_days;

say $^T - $modify_days * 60*60*24;

