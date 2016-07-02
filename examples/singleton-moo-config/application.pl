use strict;
use warnings;
use 5.010;
 
use MyConf;
use ModuleA;
use ModuleB;

sub setup {
    MyConf->instance(file => 'config.ini');
}

setup();

ModuleA->new->do_something();
ModuleB->new->do_something_else();

