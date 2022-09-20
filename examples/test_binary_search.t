use strict;
use warnings;
use feature 'say';
use File::Temp qw(tempdir);
use File::Spec::Functions qw(catfile);
use Test::More;

my $dir = tempdir( CLEANUP => 1);

my $filepath =  create_file();

subtest memory => sub {
    my $cmd = "$^X examples/read_file_into_array.pl Citrus $filepath";
    my $result = qx($cmd);
    is $result, "Citrus found at 2\n";

    $cmd = "$^X examples/read_file_into_array.pl orange $filepath";
    $result = qx($cmd);
    is $result, "orange not found\n";
};

subtest linear => sub {
    my $cmd = "$^X examples/linear_search_in_file.pl Citrus $filepath";
    my $result = qx($cmd);
    is $result, "Citrus found in row 3\n";

    $cmd = "$^X examples/linear_search_in_file.pl orange $filepath";
    $result = qx($cmd);
    is $result, "orange not found\n";
};

subtest binary => sub {
    my $cmd = "$^X examples/binary_search_in_file.pl Citrus $filepath";
    my $result = qx($cmd);
    is $result, "Citrus found at byte 13\n";

    $cmd = "$^X examples/binary_search_in_file.pl orange $filepath";
    $result = qx($cmd);
    is $result, "orange not found\n";
};

done_testing;

sub create_file {
    my $filepath = catfile($dir, 'data.txt');
    open(my $fh, '>', $filepath) or die;
    print $fh "Apple\n";
    print $fh "Banana\n";
    print $fh "Citrus\n";
    print $fh "Dates\n";
    print $fh "Figs\n";
    close($fh);
    return $filepath;
}


