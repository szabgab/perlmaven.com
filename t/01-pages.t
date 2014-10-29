use strict;
use warnings;

use Cwd            qw(abs_path);
use Data::Dumper   qw(Dumper);
use File::Basename qw(basename dirname);
use Path::Tiny qw(path);
use Test::More;

# TODO check all the done/ and draft/ directories, remove them where they are empty
# if they have not been touched for a long them then try to figure out what to do witht them

my $root = dirname dirname abs_path $0;
my @languages = map { basename $_ } glob "$root/sites/*";
my %META_PAGE = map { $_ => 1 } qw(index.tt about.tt keywords.tt archive.tt products.tt perl-tutorial.tt contributor.tt);
my %english = map { substr(basename($_), 0, -3), 1 } glob "$root/sites/en/pages/*.tt";
my %authors = read_authors();
my %sitemap;

foreach my $lang (@languages) {
	next if $lang eq 'en';

	my @pages = grep { ! $META_PAGE{ basename $_ } } glob "$root/sites/$lang/pages/*.tt";
	foreach my $file (@pages) {
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
		ok $original, "File '$shortname' does not have an =original entry";
		ok $english{$original}, "File '$shortname' has =original entry '$original' which does not exist in the English version" if $original;
		ok $translator, "File '$shortname' does not have a =translator entry";
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

