use strict;
use warnings;
use 5.010;
use Email::Valid;


foreach my $email ('foo@bar.com', ' foo@bar.com ', 'foo at bar.com') {
    my $address = Email::Valid->address($email);
    say ($address ? "yes '$address'" : "no '$email'");
}

