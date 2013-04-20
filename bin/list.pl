#!/usr/bin/perl
use strict;
use warnings;
use 5.010;

use Cwd            qw(abs_path);
use Data::Dumper   qw(Dumper);
use File::Basename qw(basename dirname);
use Getopt::Long   qw(GetOptions);

GetOptions(
	"draft"      => \my $draft,
	"help"       => \my $help,
	"site=s"     => \my $site,
	) or usage();
usage() if $help;


# list drafts  TODO: list them  sorted by =timstamp
# TODO: check the =status of the pages
# TODO: check how many pages have been translated in each language
# TODO: list the translated pages without =original or without =translator entry

my $root = dirname dirname abs_path $0;

my @languages = map { basename $_ } glob "$root/sites/*";
#say Dumper \@languages;

show('done');
if ($draft) {
	show('drafts');
}


# collect all the english pages
say "\nMinor issues";
say '-' x 30;
my %META_PAGE = map { $_ => 1 } qw(index.tt about.tt keywords.tt archive.tt products.tt);
{
	my %english = map { substr(basename($_), 0, -3), 1 } glob "$root/sites/en/pages/*.tt";
	foreach my $lang (@languages) {
		next if $lang eq 'en';
		next if $site and $lang ne $site;

		my %authors;
		open my $au, '<', "$root/sites/$lang/authors.txt" or die;
		while (my $line = <$au>) {
			chomp $line;
			my ($nick, $name, $img, $url) = split /;/, $line;
			if (not defined $url) {
				print "Missing URL for $line in authors.txt of $lang\n";
				$url = 'Unreal';
			} elsif ($url !~ m{^https://plus\.google\.com/\d+$}) {
				print "Not G+ '$url' in authors.txt for $lang\n";
				$url = 'Unreal';
			}
			$authors{$nick} = {
				name => $name,
				img  => $img,
				url  => $url,
			};
		}
		close $au;

		my @pages = glob "$root/sites/$lang/pages/*.tt";
		push @pages, glob "$root/sites/$lang/done/*.tt";
		next if not @pages;
		foreach my $file (@pages) {
			next if $META_PAGE{ basename $file };
			open my $fh, '<', $file or die "Could not open '$file' $!";
			my $original;
			my $translator;
			while (my $line = <$fh>) {
				chomp $line;
				if ($line =~ /^=original\s+(\S+)/) {
					$original = $1;
				}
				if ($line =~ /^=translator\s+(\S+)/) {
					$translator = $1;
				}
			}
			close $fh;

			# TODO do we really want to accept =translator 0
			if (not $original) {
				printf "File %-100s does not have an =original entry\n", $file;
			} elsif (not $english{$original}) {
				printf "File %-100s has =original entry '%s' which does not exist in the English version\n", $file, $original;
			}
			if (not defined $translator) {
				printf "File %-100s does not have a =translator entry\n", $file;
			} elsif ($translator and not $authors{$translator}) {
				printf "File %-100s has no mathching translator for %s\n", $file, $translator;
			}
		}
	}
}
say "\nDONE";
exit;


sub usage {
	die <<"END_USAGE";
Usage: $0
          --draft      to also show the draft folder
          --help
          --site CC    Where CC is a code in the sites/ directory
                       to restrict the result to that site
END_USAGE
}

sub show {
	my ($folder) = @_;

	printf "\nList items in %s folder\n", uc $folder;
	say '-' x 30;
	foreach my $lang (@languages) {
		next if $site and $lang ne $site;
		my @files = map { basename $_ } glob "$root/sites/$lang/$folder/*.tt";
		next if not @files;
		say "Language $lang";
		say "   $_" for @files;
	}
}


