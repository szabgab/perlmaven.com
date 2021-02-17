use 5.010;


my $html = <<'HTML';
<html>
<title>four</title>
  <head>
   <title>one</title>
  </head>
  <body>
  <title>two</title>
  </body>
<title>three</title>
</html>
HTML


use HTML::TreeBuilder::XPath;
my $tree= HTML::TreeBuilder::XPath->new;
$tree->parse($html);
say $tree->findvalue( '/html/head/title');


use XML::Twig;
my $twig = XML::Twig->new(
    twig_handlers => { 'html/head/title' => sub { print $_->text(), "\n" } },
);
$twig->parse($html);
