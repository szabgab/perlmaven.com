use strict;
use warnings;
use 5.010;
 
use MyConf;
 
my $c = MyConf->instance( file => 'conf.ini' );
say $c->file;
 
my $d = MyConf->instance( file => 'data.ini' );
say $d->file;
 
my $w = MyConf->instance();
say $w->file;
 
my $o = MyConf->new( file => 'other.ini' );
say $o->file;
 
my $z = MyConf->new( file => 'zorg.ini' );
say $z->file;
