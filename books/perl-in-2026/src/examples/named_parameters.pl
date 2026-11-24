use v5.44;
no warnings "experimental::signature_named_parameters";

sub pow(:$base, :$exponent) {
    return $base ** $exponent;
}

# say pow(2, 3);
say pow(base => 2, exponent => 3);
say pow(exponent => 3, base => 2);

my %params = (
    base => 2,
    exponent => 4,
);
say pow(%params);

