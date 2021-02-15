use warnings;
use strict;
use Daemon::Control;
use File::Basename qw(dirname);
use File::Spec::Functions qw(catfile);

my $dir = dirname(__FILE__);

exit Daemon::Control->new(
    name        => "My Daemon",
    lsb_start   => '$syslog $remote_fs',
    lsb_stop    => '$syslog',
    lsb_sdesc   => 'My Daemon Short',
    lsb_desc    => 'My Daemon controls the My Daemon daemon.',
    path        => $dir,

    program     => catfile($dir, 'local.pl'),
    program_args => [ ],

    pid_file    => '/tmp/mydaemon.pid',
    stderr_file => '/tmp/mydaemon.out',
    stdout_file => '/tmp/mydaemon.out',

    fork        => 2,

)->run;
