use strict;
use warnings;
use 5.010;
use Data::Dumper qw(Dumper);

my %account_masks = (
    creditcard => sub {
        my $str = shift;
        $str =~ s/^(.*)(.{4})$/"*" x length($1) . $2/e;
        return $str;
    },
    account => sub {
        my $str = shift;
        $str =~ s/^(.*)(.{4})$/****$2/;
        return $str;
    },
);


my %row = (
    creditcard => "1234567890abcd",
    account    => "abcdefghijklmnopqrs",
    balance    => 42,
);

print Dumper \%row;
mask_fields(\%row, \%account_masks);
print Dumper \%row;

sub mask_fields {
    my ($data, $masks) = @_;
    for my $key (keys %$data) {
        if (exists $masks->{$key}) {
            $data->{$key} = $masks->{$key}->($data->{$key});
        }
    }
}

