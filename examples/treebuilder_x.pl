use 5.010;

use HTML::TreeBuilder::XPath;
my $tree= HTML::TreeBuilder::XPath->new;

my $html = <<'HTML';
<html>
  <body>
  <p><b>one</b></p>
  <b>two</b>
  </body>
</html>
HTML

$tree->parse($html);
say $tree->findvalue( '/html/body/p/b');
