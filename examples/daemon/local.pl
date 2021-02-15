#!/usr/bin/env perl
use strict;
use warnings;

use File::Basename qw(dirname);
use File::Spec::Functions qw(catfile);

main();

my $code;

sub main {
    $code = read_config();
    logger('starting');
    my $continue = 1;

    $SIG{TERM} = sub {
        logger('TERM received');
        $continue = 0;
    };

    $SIG{HUP} = sub {
        logger('HUP received');
        $code = read_config();
    };

    while ($continue) {
        logger('');
        sleep 1;
    }
}

sub logger {
    my ($text) = @_;

    if (open my $fh, '>>', 'process.log') {
        print $fh scalar localtime();
        print $fh " $code - $text\n";
    }
}

sub read_config {
    my $config_file = 'config.txt';
    open my $fh, '<', $config_file or die "Could not open '$config_file'\n";
    my $code = <$fh>;
    chomp $code;
    return $code;
}

