#!/home/starman/perl5/perlbrew/perls/perl-5.18.1/bin/perl
use warnings;
use strict;
use Daemon::Control;

use Cwd qw(abs_path);

Daemon::Control->new(
    {
        name      => "Starman",
        lsb_start => '$syslog $remote_fs',
        lsb_stop  => '$syslog',
        lsb_sdesc => 'Starman Short',
        lsb_desc  => 'Starman controls the web sites.',
        path      => abs_path($0),

        program      => '/home/starman/perl5/perlbrew/perls/perl-5.18.1/bin/starman',
        program_args => [ '--workers', '3', '/home/starman/Demo/bin/app.pl' ],

        user  => 'starman',
        group => 'starman',

        pid_file    => '/tmp/starman.pid',
        stderr_file => '/tmp/starman.err',
        stdout_file => '/tmp/starman.out',

        fork => 2,

    }
)->run;

