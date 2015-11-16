#!/home/vagrant/localperl/bin/plackup
#!/usr/bin/env plackup
use strict;
use warnings;

use Plack::Request;

sub {
    my ($env) = @_;
    my $request = Plack::Request->new($env);
    my $text = $request->param('text');

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

    if ($text) {
        $html .= "You wrote <b>$text</b>";
    }

$html .= <<'HTML';
</body>
</html>
HTML

    return [
        '200',
        [ 'Content-Type' => 'text/html' ],
        [ $html ],
    ];
};
