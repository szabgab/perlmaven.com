use strict;
#use warnings;
#use warnings FATAL => 'all';

my $user_code = shift;

my $code_from_db = get_code();
if ($user_code eq $code_from_db) {
    print "Accessing account information...\n" ;
} else {
    print "Access denied\n";
}


sub get_code {
    # get the verification code from the databae which, in some rare cases, might be NULL
    # returning undef
}


