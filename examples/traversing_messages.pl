use strict;
use warnings;
use 5.010;

use Path::Iterator::Rule;
use Email::Folder;

my $path_to_dir = shift or die "Usage: $0 path/to/mail\n";

my $count = 0;

my $rule = Path::Iterator::Rule->new;
my $it = $rule->iter( $path_to_dir );
while ( my $file = $it->() ) {
    next if not -f $file;
    say $file;
    my $folder = Email::Folder->new($file);
    while (my $msg = $folder->next_message) {  # Email::Simple objects
        $count++;
    }
}
say $count;

