use strict;
use warnings;
use 5.010;

use LWP::Simple qw(get);
use Web::Query qw(wq);

my $url = 'http://www.unicode.org/Public/emoji/1.0/full-emoji-list.html';
#my $html = get $url;

my $page = wq($url);
say $page; # Web::Query
my $table = $page->find('table');
say $table; # #web::Query

say $page->as_html;
my $tr = $page->find('table tr');
say $tr;
say '---';
$page->find('table')->each(sub {
	my $what = shift;
	say $what;
	say $_;
	#exit;
});

#    ->find('div.head dt')
#    ->each(sub {
#        my $i = shift;
#        printf("%d %s\n", $i+1, $_->text);
#    });


