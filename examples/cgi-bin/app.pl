use 5.010;
use strict;
use warnings;

use CGI;

my $q = CGI->new;
print $q->header(-charset    => 'utf-8');

my $response = '';
my $text = $q->param('text');
if (defined $text and $text =~ /\S/) {
    $response = qq{<hr>You sent: <b>$text</b>};
}

my $html = qq{
<html>
<head>
<title>CGI Echo</title>
</head>
<body>
<h1>Welcome to CGI Echo</h1>
<form>
<input name="text">
<input type="submit" value="Echo">

$response

</form>
</body>
</html>
};

print $html;
