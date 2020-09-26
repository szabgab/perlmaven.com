use strict;
use warnings;

sub slurp {
    my $file = shift;
    open my $fh, '<:encoding(utf8)', $file or die "Cannot open '$file' $!";
    local $/ = undef;
    my $cont = <$fh>;
    close $fh;
    return $cont;
}

