#!/usr/bin/env perl
use strict;
use warnings;
use 5.010;

use DBI;
my $db_file      = 'process.db';
my $TIMEOUT      = 22;

my ($wait, $end_status) = @ARGV;
$end_status ||= ('success', 'failure')[int rand 2];
$wait ||= rand(60);
say "$end_status $wait";

my $start_time = time;

my $new_db = !-e $db_file;
my $dbh = DBI->connect( "dbi:SQLite:dbname=$db_file", "", "" );
if ($new_db) {
    $dbh->do(
        q{CREATE TABLE processes (
        id INTEGER PRIMARY KEY,
        timestamp VARCHAR(100),
        status VARCHAR(100),
        pid INTEGER,
        elapsed_time REAL
   )}
    );
}
my ($timestamp, $status, $pid)
    = $dbh->selectrow_array('SELECT timestamp, status, pid FROM processes WHERE status="running"');

if ($timestamp) {
    say "There is already a running process using PID $$ started at " . localtime($timestamp);
    if ($timestamp < $start_time - $TIMEOUT) {
        say "This has been running for too long. We should report it";
    }
    exit;
}


$dbh->do(
'INSERT INTO processes (timestamp, status, pid) VALUES (?, ?, ?)',
        undef,
        $start_time,
        'running',
        $$
    );
my $id = $dbh->last_insert_id('', 'main', 'processes', 'id');
say "Running PID $$ id $id (will take $wait seconds)";
sleep $wait;
my $elapsed_time = time - $start_time;
$dbh->do('UPDATE processes SET status=?, elapsed_time=?, pid=? WHERE id=?',
    undef, $end_status, $elapsed_time, undef, $id);

system "echo .dump | sqlite3 $db_file";

