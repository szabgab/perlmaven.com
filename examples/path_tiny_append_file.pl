use strict;
use warnings;
use Path::Tiny qw(path);

my $filename = shift or die "Usage: $0 FILENAME";

my $data = <<'END';
Some text
More lines
END

path($filename)->append_utf8($data);

