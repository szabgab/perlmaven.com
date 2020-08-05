use strict;
use warnings;
use 5.010;

use MetaCPAN::Client;
my $mcpan  = MetaCPAN::Client->new();
my $recent = $mcpan->recent(10);
#say $recent;

while (my $item = $recent->next) {
    say $item->name;
    say $item->distribution;
}
