use strict;
use warnings;

use Text::Lorem;

sub create_payload {
    my $tl = Text::Lorem->new();
	return {
		fname   => $tl->words(1),
		lname   => $tl->words(1),
		address => $tl->words(7),
	}
}

use Data::Dumper qw(Dumper);
print Dumper create_payload();

=head1 Output

$VAR1 = {
          'fname' => 'quaerat',
          'address' => 'est enim libero aut sit architecto quis',
          'lname' => 'aliquam'
        };

=cut

