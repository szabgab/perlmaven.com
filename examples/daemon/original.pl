#!/usr/bin/env perl
use strict;
use warnings;

main();

sub main {
    my $logfile = 'process.log';
    my $continue = 1;

    $SIG{INT} = sub {
        logger('INT received');
        $continue = 0;
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
        print $fh " $text\n";
    }
}

