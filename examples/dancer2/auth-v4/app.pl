#!/usr/bin/perl

use Dancer2;
use Dancer2::Plugin::Auth::Extensible;

get '/' => sub {
    return 'This is a public page. Everyone can see it. Check out the <a href="/report">report</a>';
};

get '/report' => require_role Marketing => sub {
    return 'Only authenticated users should be able to see this page';
};

get '/salaries' => require_role Management => sub {
    return 'Only management can see this';
};

dance;


