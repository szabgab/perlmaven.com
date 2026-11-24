use v5.44;

my $auto_id = 0;
sub increment($thing, $id = $auto_id++) {
    say "$thing has ID $id";
}

increment("table");
increment("chair");
increment("window", 10);
increment("doo0r");

