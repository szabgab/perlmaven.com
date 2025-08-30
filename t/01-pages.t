use strict;
use warnings;

use Cwd            qw(abs_path);
use Data::Dumper   qw(Dumper);
use File::Basename qw(basename dirname);
use Path::Tiny qw(path);
#use HTML::Tidy;
use Test::More;
#use Test::HTML::Tidy;

# TODO check all the done/ and draft/ directories, remove them where they are empty
# if they have not been touched for a long them then try to figure out what to do witht them

my $root = dirname dirname abs_path $0;
my @languages = map { basename $_ } glob "$root/sites/*";
my %META_PAGE = map { $_ => 1 } qw(index.txt about.txt keywords.txt archive.txt products.txt perl-tutorial.txt contributor.txt search.txt);
my %english = map { substr(basename($_), 0, -4), 1 } glob "$root/sites/en/pages/*.txt";
my %authors = read_authors();
my %sitemap;
#my $tidy = html_tidy();

foreach my $lang (@languages) {

	my @pages = grep { ! $META_PAGE{ basename $_ } } glob "$root/sites/$lang/pages/*.txt";
	foreach my $file (@pages) {
		if ($lang eq 'en') {
			#my $html = path($file)->slurp_utf8;
			#$html =~ s{<hl>}{<span>}g;
			#$html =~ s{</hl>}{</span>}g;
			#html_tidy_ok( $tidy, $html ) or diag "File $file";
			next;
		}

		my @lines = path($file)->lines_utf8;
		chomp @lines;
		my $original;
		my $translator;
		foreach my $line (@lines) {
			if ($line =~ /^=original\s+(\S+)/) {
				$sitemap{$lang}{$file}{original} = $original = $1;
			}
			if ($line =~ /^=translator\s+(\S+)/) {
				$sitemap{$lang}{$file}{translator} = $translator = $1;
			}
		}

		#diag $original;
		#diag $translator;
		my ($shortname) = $file =~ m{/(sites/$lang/pages/.*)};
		# TODO do we really want to accept =translator 0
        #ok $original, "File '$shortname' does not have an =original entry";
        #ok $english{$original}, "File '$shortname' has =original entry '$original' which does not exist in the English version" if $original;
        #SKIP: {
		#	skip 'original article', 1 if 'sites/ru/pages/how-i-learn-english.txt' eq $shortname;
		#	ok $translator, "File '$shortname' does not have a =translator entry";
		#};
		ok $authors{$translator}, "File '$shortname' has no mathching translator for '$translator'" if $translator;
	}
}


sub read_authors {
	my %autho;
	open my $au, '<', "$root/authors.txt" or die;
	while (my $line = <$au>) {
		chomp $line;
		my ($nick, $name, $img, $url) = split /;/, $line;
		if (not defined $url) {
			#print "Missing URL for line '$line' in authors.txt\n";
			$url = 'Unreal';
		} elsif ($url !~ m{^https://plus\.google\.com/}) {
			#print "Not G+ '$url' in line '$line' in authors.txt\n";
			$url = 'Unreal';
		}
		$autho{$nick} = {
			name => $name,
			img  => $img,
			url  => $url,
		};
	}
	close $au;
	return %autho;
}

done_testing;


sub html_tidy {
	my $tidy = HTML::Tidy->new;

	# HTML 4: <script src="/jquery.js" type="text/javascript"></script>
	# HTML 5: <script src="/jquery.js"></script>
	$tidy->ignore( text => qr{<script> inserting "type" attribute} );

	# HTML 4: <link rel="stylesheet" href="/style.css" type="text/css" />
	# HTML 5: <link rel="stylesheet" href="/style.css" />
	$tidy->ignore( text => qr{<link> inserting "type" attribute} );

	# HTML 4.01    <meta http-equiv="Content-Type" content="text/html; charset=UTF-8">
	# HTML 5       <meta charset="utf-8" />
	$tidy->ignore( text => qr{<meta> proprietary attribute "charset"} );
	$tidy->ignore( text => qr{<meta> lacks "content" attribute} );

	# AFAIK HTML 5 does not support the "summary" attribute
	$tidy->ignore( text => qr{<table> lacks "summary" attribute} );

	# We should probably replace & in gravatar URLS by &amp; instead of hiding the warning:
	#$tidy->ignore( text => qr{unescaped & or unknown entity "&d"} );

	#$tidy->ignore( text => qr{inserting} ); #: <script> inserting "type" attribute} );

	$tidy->ignore( text => qr{missing <!DOCTYPE> declaration} );
	$tidy->ignore( text => qr{plain text isn't allowed in <head> elements} );
	$tidy->ignore( text => qr{<head> previously mentioned} );
	$tidy->ignore( text => qr{inserting implicit <body>} );
	$tidy->ignore( text => qr{inserting missing 'title' element} );
	#$tidy->ignore( text => qr{} );
	#$tidy->ignore( text => qr{} );


	# These are parts of <code> sections. Those should be disregarded!
	$tidy->ignore( text => qr{<stdin> is not recognized!} );
	$tidy->ignore( text => qr{discarding unexpected <stdin>} );


	return $tidy;
}


