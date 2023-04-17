#!/usr/bin/env perl
use strict;
use warnings;
use 5.010;

use WWW::Mechanize;

my $dir = '/tmp';

my $url = shift or die "Usage: $0 URL\n";

my $name;
if ($url =~ m{^https://metacpan.org/pod/([a-zA-Z0-9:]+)$}) {
    $name = $1;
} elsif ($url =~ m{^https://metacpan.org/release/([a-zA-Z0-9-]+)$}) {
    $name = $1;
}


die "Invalid URL\n" if not $name;

my $w = WWW::Mechanize->new;
$w->get($url);
my $download_link = $w->find_link( text_regex => qr{^Download} );
die "Could not find download link\n" if not $download_link;
say $download_link;
exit;
my ($file) = $download_link->url =~ m{([^/]+)$};
say $download_link->url;
say $file;
my $path = "$dir/$file";
if (-e $path) {
    say "Already downloaded to $path";
    exit;
}

$w->follow_link( text_regex => qr{^Download} );
$w->save_content( $path, binary => 1 );
say "Saved to $path";
chdir $dir;
system "tar xzf $file";

