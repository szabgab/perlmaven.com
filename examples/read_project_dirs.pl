use strict;
use warnings;
use Data::Dumper;

my $dir = shift or die "Usage: $0 DIR\n";

my %data;
collect_data();

print Dumper \%data;

sub collect_data {
    opendir my $dh_root, $dir or die "Could not open '$dir'\n";;
    foreach my $project (readdir $dh_root) {
        next if $project eq '.' or $project eq '..';
        print "$project\n";
        opendir my $dh_project, "$dir/$project" or die "Could not open '$dir/$project'\n";
        foreach my $library (readdir $dh_project) {
            next if $library eq '.' or $library eq '..';
            print "    $library\n";
            opendir my $dh_library, "$dir/$project/$library" or die "Could not open '$dir/$project/$library'\n";
            foreach my $type (readdir $dh_library) {
                next if $type eq '.' or $type eq '..';
                print "        $type\n"; 
                opendir my $dh_type, "$dir/$project/$library/$type" or die "Could not open '$dir/$project/$library/$type'\n";
                foreach my $file (readdir $dh_type) {
                     next if $file eq '.' or $file eq '..';
                     print "            $file\n";
                     push @{ $data{$project}{$library}{$type} }, $file;
                } 
            }
        }
    }
    return;
}



print get_library('DLL', 'src', 'vkg_fib_mpls_ltrace_encoder.c') , "\n";

sub get_library {
    my ($project, $type, $file) = @_;
    foreach my $library (keys %{ $data{$project} }) {
        foreach my $filename (@{ $data{$project}{$library}{$type} }) {
            if ($filename eq $file) {
                return $library;
            }
        }
    }
    return;
}

