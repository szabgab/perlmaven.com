package App;
use strict;
use warnings;
use Dancer ':syntax';

get '/' => sub {
  return 'Hello World';
};


true;

