#!/usr/bin/perl

use lib "/usr/local/lib";

use TheSchwartz;
require Worker::SendEmail;
 
my $dbname      = "schwartz";
my $host        = "localhost";
my $port        = "5432"; 
my $username    = "USERNAME";
my $password    = "PASSWORD";

# Database connection string.
my $dsn = "dbi:Pg:dbname=$dbname;host=$host";

# Add on credentials
my $databaseref = [
	{
		dsn => $dsn,
		user => $username,
		pass => $password,
	},
];

# Create schwartz client object
my $sclient = TheSchwartz->new(
	databases => $databaseref,
	driver_cache_expiration => 900,
);

# Specify the type of job to work on (from funcmap.funcname in db)
$sclient->can_do("Worker::SendEmail");

my $log_file = "/var/tmp/send_email_runner.log";
open(LOG,">>$log_file") or die "Can not open $log_file!";
{ my $ofh = select LOG;
  $| = 1;
  select $ofh;
}

warn "Service started. Using dbhost: $host / dbname: $dbname\n";

$loopcount = 0;
$sleepint = 10;
if ($loopcount eq 0) {
	# main loop of program; goes forever, running jobs
	$sclient->work($sleepint);
} else {
	for (my $i = 0; $i <= $loopcount; $i++) {
		$sclient->work_once();
		sleep $sleepint;
	}
}

exit 0;
