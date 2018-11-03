#!/usr/bin/perl
use strict;
use warnings;

use CGI;
use CGI::Session;

my $q = CGI->new;
#print $q->header;
my $session = CGI::Session->new();
print $session->header;


print <<HTML;
<html><head></head><body>
<form>
<input name="username">
<input name="password" type="password">
</form>

</html>
HTML

