#!/usr/bin/perl
use strict;
use warnings;

use CGI;
my $q = CGI->new;
print $q->header;

my $text = $q->param('text');


my $html = <<'HTML';
<!DOCTYPE html>
<html lang="en">
<head>
  <meta charset="utf-8">
  <meta name="viewport"
     content="width=device-width, initial-scale=1, user-scalable=yes">
 
  <title>Echo</title>
</head>
<body>
<form>
<input type="text" name="text">
<input type="submit" value="Echo">
</form>
HTML

if (defined $text) {
    $html .= "You wrote <b>$text</b>";
}

$html .= <<'HTML';
</body>
</html>
HTML

print $html;

