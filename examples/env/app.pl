use strict;
use warnings;

use Dotenv;

Dotenv->load;

printenv();

print("-------------------------\n");
print "$ENV{X_ANSWER}\n";
print "$ENV{X_TEXT}\n";



sub printenv {
    for my $key (sort keys %ENV) {
        printf("%-26s %s\n", $key, substr($ENV{$key}, 0, 40));
    }
}



