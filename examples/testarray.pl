#!/usr/bin/perl

use strict;
use warnings;

my @superArray;

processArray("test");

my @testArray1 = ('14.1.5.1501','14.1.5.1533','14.1.6.2060','14.1.6.1760','14.1.6.1785','14.1.7.1853','14.1.7.1933','14.1.7.1970','14.1.7.1986','14.1.8.2060','14.1.8.2105','14.1.8.2149','14.1.8.2168');
my @testArray2 = ('14.1.5.1501','14.1.6.2060','14.1.7.1853','14.1.8.2060');

print "first array processing starts\n";
processArray(@testArray1);
print "super array is @superArray\n";
@superArray = ();
print "first array processing ends\n";

print "second array processing starts\n";
processArray(@testArray2);
print "super array is @superArray\n";
print "second array processing ends\n";


sub processArray
{
    my @processArray = @_;
    #remove the base element
    my $baseElement = $processArray[0];
    my $baseElementSubstr = substr $baseElement,1,6;
    #print "base element substring is $baseElementSubstr\n";
    
    foreach my $processArrayElement(@processArray)
    {
        my $processArrayElementSubstr = substr $processArrayElement,1,6;
        if($processArrayElementSubstr eq $baseElementSubstr)
        {
          @processArray = grep {!/$baseElementSubstr/} @processArray;
        }
    }
    
    #print "processed array is @processArray\n";
    
    foreach my $baseElement(@processArray)
    {
        push @superArray,$baseElement;
        my $baseElementSubstr = substr $baseElement,1,6;
        @processArray = grep {!/$baseElementSubstr/} @processArray;
        #print "second level processarray is @processArray\n";
        
    }
    #print "super array is @superArray \n";
}
