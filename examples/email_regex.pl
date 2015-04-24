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
);


foreach my $email (@emails) {
    my $address = Email::Valid->address($email);
    my $regex = $email =~ /^[a-z0-9.]+\@[a-z0-9.-]+$/;
    if ($address and not $regex) {
        printf "%-20s Email::Valid but not regex valid\n", $email;
    } elsif ($regex and not $address) {
        printf "%-20s regex valid but not Email::Valid\n", $email;
    } else {
        printf "%-20s agreed\n", $email;
    }
}


