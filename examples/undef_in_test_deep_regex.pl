use Test::More;
use Test::Deep;

plan tests => 1;

my @data = (
    {
        name => 'Foo',
    },
    {
        name => undef,
    },
);

cmp_deeply \@data, array_each({
    name => re('^.*$')
});
