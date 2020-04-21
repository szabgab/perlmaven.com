use strict;
use warnings;
use 5.010;

for my $len (1..10) {
    say $len;

    #my $in = "123456789";
    my $in = ("1" x $len) . "6789";
    say $in;

    my $out1 = $in;
    $out1 =~ s/^(.*)(.{4})$/"*" x length($1) . $2/e;
    say $out1;
    #say "*" x (length($in) - 4) . substr($in, -4);

    my $out2 = $in;
    $out2 =~ s/^(.*)(.{4})$/****$2/;
    say $out2;
    #say '****' . substr($in, -4);

    my $out3 = $in;
    $out3 =~ s/^(.{4})(.*)$/$1****/;
    say $out3;
    #say substr($in, 0, 4) . '****';

    my $out4 = $in;
    $out4 =~ s/^(.{4})(.*)$/$1 . "*" x length($2)/e;
    say $out4;
    #say substr($in, 0, 4) . "*" x (length($in) - 4);

    say '';
}
