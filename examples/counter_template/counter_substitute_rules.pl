use strict;
use warnings;

use Path::Tiny qw(path);
#use Data::Dumper qw(Dumper);

my @rules_rows = path('rules.txt')->lines_utf8;
chomp @rules_rows;
my %rules = @rules_rows;
#die Dumper \%rules;

my $data = path('counter.txt')->slurp_utf8;
foreach my $rule (keys %rules) {
    $data =~ s/$rule/ $rules{$rule} /gee;
}
foreach my $p ($data =~ /(\d+)/g) {
    print "$p\n";
}
path('counter.txt')->spew_utf8($data);

