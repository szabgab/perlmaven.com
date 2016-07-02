package MyConf;
use Moo;
with 'MooX::Singleton';
 
has file => (is => 'ro', required => 1);
 
1;
