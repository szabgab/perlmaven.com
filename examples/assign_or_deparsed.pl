use strict;
(my $x = '');
((my $y = $x) or '???');
print("$y\n");
