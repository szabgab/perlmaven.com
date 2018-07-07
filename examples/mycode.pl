use 5.010;
use strict;
use warnings;
use MyMod;

{
    MyMod::f();
}

{
    no warnings 'MyMod';
    MyMod::f();
}

{
    MyMod::f();
}

say "done";
