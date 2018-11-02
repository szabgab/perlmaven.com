use 5.010;
use strict;
use warnings;
use Fcntl qw(SEEK_SET SEEK_CUR SEEK_END); # better than using 0, 1, 2

my ($file) = @ARGV;
die "Usage: $0 NAME FILE\n" if not $file;

say "file size: ", -s $file;

open my $fh, '<', $file or die;
my $line;

say tell($fh);
$line = <$fh>;
print($line);
say tell($fh);


say '-- go to 0';
seek $fh, 0, SEEK_SET;
say tell($fh);
$line = <$fh>;
print($line);
say tell($fh);

say '-- go to 20';
seek $fh, 20, SEEK_SET;
say tell($fh);
$line = <$fh>;
print($line);
say tell($fh);

say '-- go back 14';
seek $fh, -14, SEEK_CUR;
say tell($fh);
$line = <$fh>;
print($line);
say tell($fh);

say '-- go to the end';
seek $fh, 0, SEEK_END;
say tell($fh);
say eof($fh);

say '-- go 12 from the end';
seek $fh, -12, SEEK_END;
say tell($fh);
$line = <$fh>;
print($line);
say tell($fh);

