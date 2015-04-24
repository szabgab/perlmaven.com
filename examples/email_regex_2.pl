use strict;
use warnings;
use Email::Valid;

my @emails = (
    'foo@bar.com',
    'foo at bar.com',
    'foo.bar42@c.com',
    '42@c.com',
    'f@42.co',
    'foo@4-2.team',

    '.x@c.com',
    'x.@c.com',
    'foo_bar@bar.com',
    '_bar@bar.com',
    'foo_@bar.com',
    'foo+bar@bar.com',
    '+bar@bar.com',
    'foo+@bar.com',
);


foreach my $email (@emails) {
    my $address = Email::Valid->address($email);

    my $username = qr/[a-z0-9_+]([a-z0-9_+.]*[a-z0-9_+])?/;
    my $domain   = qr/[a-z0-9.-]+/;
    my $regex = $email =~ /^$username\@$domain$/;

    if ($address and not $regex) {
        printf "%-20s Email::Valid but not regex valid\n", $email;
    } elsif ($regex and not $address) {
        printf "%-20s regex valid but not Email::Valid\n", $email;
    } else {
        printf "%-20s agreed\n", $email;
    }
}


