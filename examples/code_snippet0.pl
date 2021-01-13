my $copyrightsfile = shift @ARGV;

open COPYR,"<$copyrightsfile" or die "Can't open copyrights $copyrightsfile";
while(<COPYR>){
    chomp;
	next if /^#/;
	@COPYRIGHT=split /,/;
	next unless scalar(@COPYRIGHT)==2;
	push @COPYRIGHTS,{
		firstname=>$COPYRIGHT[0],
		lastname=>$COPYRIGHT[1],
	};
}
close COPYR;

use Data::Dumper qw(Dumper);
print Dumper \@COPYRIGHTS;
