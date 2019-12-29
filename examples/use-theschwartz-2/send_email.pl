#!/usr/bin/perl
 
use strict;
use warnings;
 
use TheSchwartz::Simple;
use DBI;

my $dbname		= "schwartz";
my $host		= "localhost";
my $port		= "5432";
my $username	= "USERNAME";
my $password	= "PASSWORD";
my $dbh = DBI -> connect(
	"dbi:Pg:dbname=$dbname;host=$host;port=$port",  
	$username,
	$password,
	{AutoCommit => 1, RaiseError => 1}
) or die $DBI::errstr;
 
my $client = TheSchwartz::Simple->new([ $dbh ]); 
my $job    = TheSchwartz::Simple::Job->new;
my $time   = time();
 
if ($client && $job) {
	$job->funcname("Worker::SendEmail");
	$job->arg({
		from	=> "darth.vader\@cloudcity.com",
		to		=> "luke.skywalker\@cloudcity.com",
		subject	=> "Luke",
		body	=> "I, am your father. -Dad",
	}); 
	$job->run_after($time + 10);
	my $success = $client->insert($job);
	if ($success) {
		warn "Record added to jobs table successfully.\n";
	} else {
		warn "Record addition to jobs table failed!\n";
	}   
} else {
	warn "Could not instantiate the Schwartz::Simple client and job objects!\n";
}  

exit;
