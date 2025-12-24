use JSON::Schema::Validate;
use JSON ();
use open qw( :std :encoding(UTF-8) );
my $schema = {
    '$schema' => 'https://json-schema.org/draft/2020-12/schema',
    '$id'     => 'https://example.org/s/root.json',
    type      => 'object',
    required  => [ 'name' ],
    properties => {
        name => { type => 'string', minLength => 5 },
        next => { '$dynamicRef' => '#Node' },
    },
    '$dynamicAnchor' => 'Node',
    additionalProperties => JSON::false,
};
my $js = JSON::Schema::Validate->new( $schema )
    ->compile
    ->content_checks
    ->ignore_unknown_required_vocab
    ->prune_unknown
    ->register_builtin_formats
    ->trace
    ->trace_limit(200) # 0 means unlimited
    ->unique_keys; # enable uniqueKeys

    #my $data = {
    #    name => 'head',
    #    next => {
    #        name => 'tail'
    #    }
    #};
    #my $data = {
    #    name => 23,
    #    next => {
    #        name => 'tail'
    #    }
    #};
    #my $data = {
    #    name => 'head',
    #};
my $data = {
    name => 'head big',
};


my $ok = $js->validate($data)
    or die( $js->error );
print "ok\n";
