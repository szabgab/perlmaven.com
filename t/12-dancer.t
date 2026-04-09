use strict;
use warnings;

use Cwd qw(cwd);
use Path::Iterator::Rule;
use IPC::Run qw(run timeout);

use Test::More;

my $root = cwd();
diag "root: $root";

my $path = "books/perl-dancer/src/examples/dancer";
opendir my $dh, $path or die;
my @examples = grep {$_ ne '.' and $_ ne '..'} readdir($dh);
close $dh;

my %skip = map {$_ => 1} qw(
App-Skeleton
calc
calc1
calc2
counter
counter1
counter2
get-parameters
hello_404
hello_500
hooks
logging
other-keywords
params-in-routes
params-in-routes-int
params-in-routes-optional
params-in-routes-regex
params-in-routes-wildcard
post-parameters
random-redirect
redirection
return-404
return-json
route-based-multi-counter
session
show-config
show-errors
show_array
show_hoh
show_time
show_time_using_template
simple-todo
template-include
template-layout
template-tiny
template-toolkit
template-toolkit-tags
uploader
);

for my $example (@examples) {
    if ($skip{$example}) {
        diag "Skipping $example";
	next;
    }

    chdir "$path/$example";
    diag cwd();
    my @cmd = ('prove', '-v', '.');
    my ($in, $out, $err);
    my $exit = run \@cmd, \$in, \$out, \$err, timeout( 10 );
    my $exit_code = $?;
    is $exit_code, 0, "exit code of $example";
    diag $out;
    diag $err;

    chdir $root;
}

done_testing;
