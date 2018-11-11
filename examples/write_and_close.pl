use 5.010;
use strict;
use warnings;

my $filename = 'data.txt';
save("Hello World!\n");
say -s $filename;  # 13
save("Welcome Back!\n");
say -s $filename;  # 27


sub save {
    my ($str) = @_;

    open my $fh, '>>', $filename or die;
    print $fh $str;
    close $fh;
}

