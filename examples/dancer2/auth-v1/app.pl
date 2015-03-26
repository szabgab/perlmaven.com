#!/usr/bin/perl

use Dancer2;

get '/' => sub {
    return 'This is a public page. Everyone can see it. Check out the <a href="/report">report</a>';
};

get '/report' => sub {
    return 'Only authenticated users should be able to see this page';
};

dance;


