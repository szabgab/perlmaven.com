package Worker::SendEmail;

use base qw( TheSchwartz::Worker );
use Data::Dump qw(dump);

my $self = bless({}, __PACKAGE__);

sub grab_for { 120 }
sub max_retries { 30 }
sub retry_delay { 60 }

my $log_file = "/var/tmp/send_email_worker.log";
open(LOG,">>$log_file") or die "Can not open $log_file!";
{ my $ofh = select LOG;
  $| = 1;
  select $ofh;
}
 
sub work {
	my ($self, $job) = @_;

	print LOG "=======================================================\n";
	print LOG `date` . "\n";
	print LOG "=======================================================\n";
	print LOG "Job:\n";
	print LOG dump $job;

	my $args		= $job->arg;
	my $client		= $job->handle->client;

	print LOG "Args:\n";
	print LOG dump $args . "\n";

	# Get args we created in worker job record. (See job.arg data in db).
	my $from		= $args->{from} ||= 'noreply@someplace.com';
	my $to			= $args->{to};
	my $subject		= $args->{subject};
	my $body		= $args->{body};

	print LOG "From: $from\n";
	print LOG "To: $to\n";
	print LOG "Subject: $subject\n";
	print LOG "Body: $body\n";

	# Let make sure we have all the required data for email.
	my @rqd_fields = qw(from to subject body);
	foreach my $rqd_field (@rqd_fields){
		if ( ! exists $args->{$rqd_field} || $args->{$rqd_field} eq ""){
			print LOG "Worker::SendEmail FAILED!  Missing required data!! (field: $rqd_field) \n";
			$job->permanent_failure( "Worker::SendEmail missing required field", 1 );
			return(1);
		}
	}

	my $sendmail	= "/usr/sbin/sendmail -t";

	print LOG "sendmail: $sendmail\n";

	# Do not change the order of the headers.
	open(SENDMAIL, "|$sendmail") or die "Cannot open $sendmail: $!";
	print SENDMAIL "From: $from" . "\n";
	print SENDMAIL "To: $to" . "\n";
	print SENDMAIL "Subject: $subject " . "\n";
	print SENDMAIL "Content-type: text/plain" . "\n";
	print SENDMAIL $body;
	close (SENDMAIL);

	print LOG "All done!\n";

	$job->completed();
}

1;
