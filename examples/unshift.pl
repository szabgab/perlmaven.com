use strict;
use warnings;

my @animals = ('wombat', 'kenguru');
print "@animals\n"; # wombat kenguru

unshift @animals, 'koala';
print "@animals\n"; # koala wombat kenguru

my @birds = ('penguin', 'kiwi');
print "@birds\n";   # penguin kiwi

unshift @animals, @birds;
print "@animals\n"; # penguin kiwi koala wombat kenguru

