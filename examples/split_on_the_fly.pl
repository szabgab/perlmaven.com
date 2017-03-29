my $str = "root:*:0:0:System Administrator:/var/root:/bin/sh";
my $indexes="0,4"; ######## HERE####

my ($username, $real_name) = (split /:/, $str)[$indexes]; ##and HERE##
print "$username\n";
print "$real_name\n";
