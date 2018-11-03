#!/usr/bin/perl
use strict;
use warnings;
use 5.010;

use DBI;
use Data::Dumper;

#$Data::Dumper::Indent = 1;
#$Data::Dumper::Sortkeys = 1;
#$Data::Dumper::Useqq = 1;

my $user = "root";
my $database = "mysql";
my $pw = "";
my $port = 3306;
my $host = "localhost";

my %permission;

my $dsn = "DBI:mysql:database=$database:host=$host:port=$port";
my $dbh = DBI->connect($dsn, $user, $pw, {
    PrintError       => 0,
    RaiseError       => 1,
    AutoCommit       => 1,
    FetchHashKeyName => 'NAME_lc',
});

my $sth = $dbh->prepare(qq(SELECT DISTINCT user,host from mysql.user;));
$sth->execute();

my @login;
while (my $hr = $sth->fetchrow_hashref) {
    push @login, $hr;
}

#say Dumper \@login;

my %grants;
foreach my $e (@login) {
    my $sql = qq( SHOW GRANTS for '$e->{user}'\@'$e->{host}';);
    my $sth = $dbh->prepare($sql);
    $sth->execute();
    while (my $row = $sth->fetchrow_array) {
        #say $row;
        my ($permissions, $db, $schema, $user, $scope) = $row =~ m/.*GRANT\s(.+)\sON\s(.+)\.(.+)\sTO\s([^\@]+)\@(\S+)/i;
        if (not defined $permissions) {
            warn "No match, skipping line '$row'\n";
            next;
        }
        for my $field  ($permissions, $db, $schema, $user, $scope) {
            if (defined $field) {
                $field =~ s/[`']//g;
            }
            if ($field eq '') {
                $field = '__'; # some default values instead of the empty string
            }
        }
        for my $perm (split /,/, $permissions) {
            $grants{$host}{$user}{db}{$db} = 1;
            $grants{$host}{$user}{perm}{$perm} = 1;
        }
    }
}
#say Dumper \%grants;
foreach my $host (sort keys %grants) {
    foreach my $user (sort keys %{ $grants{$host} }) {
        say "$host:" . join(',', keys %{ $grants{$host}{$user}{perm} }) . " :$user:" . join(',', keys %{ $grants{$host}{$user}{db} }); 
    }
}

#GRANT USAGE ON *.* TO 'some_user'@'%'
#GRANT ALL PRIVILEGES ON *.* TO 'root'@'127.0.0.1'
#GRANT SELECT,INSERT  ON *.* TO 'root'@'::1'


