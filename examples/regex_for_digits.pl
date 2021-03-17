use strict;
use warnings;
use utf8;
use 5.010;

binmode(STDOUT, ':utf8');

my $text = "Text with a number 42 and another number: '٣' which is 3 in arabic";

# ASCII digits
say($text =~ /[0-9]/g);           # 423
say($text =~ /\p{PosixDigit}/g);  # 423

# Unicode digits
say($text =~ /\d/g);              # 42٣3
say($text =~ /[[:digit:]]/g);     # 42٣3
say($text =~ /\p{Digit}/g);       # 42٣3

# Hexadecimal digits
say($text =~ /[[:xdigit:]]/g);    # eabe42adahebec3aabc
say($text =~ /[0-9a-fA-F]/g);     # eabe42adahebec3aabc
say($text =~ /\p{PosixXDigit}/g); # eabe42adahebec3aabc


