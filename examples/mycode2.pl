use 5.010;
use strict;
use warnings;
use MyMod2;

{
    MyMod2::f();
}

{
    no warnings 'misc';
    MyMod2::f();
}

{
    MyMod2::f();
}

say "done";
