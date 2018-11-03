#!/usr/bin/env perl
use strict;
use warnings;

my @testArray1 = (
	'14.1.5.1501',
	'14.1.5.1533',
	'14.1.6.2060',
	'14.1.6.1760',
	'14.1.6.1785',
	'14.1.7.1853',
	'14.1.7.1933',
	'14.1.7.1970',
	'14.1.7.1986',
	'14.1.8.2060',
	'14.1.8.2105',
	'14.1.8.2149',
	'14.1.8.2168'
);
my @testArray2 = (
	'14.1.5.1501',
	'14.1.6.2060',
	'14.1.7.1853',
	'14.1.8.2060'
);

# For array 1:
# 1. First step is to remove the first element and subsequent child. for example in testarray1 above, I need to remove 14.1.5.1501 and 14.1.5.1533 first.
# 2. Second step is to to keep all the subsequent top elements in the array like (14.1.6.2060, 14.1.7.1853 and 14.1.8.2060) and remove their child elements.

# For Array 2:
# 1. I need to remove the first element. (14.1.5.1501)
# 2. I need to keep the subsequent element (14.1.6.2060, 14.1.7.1853 and 14.1.8.2060).

# The script runs correctly for the first array giving output (14.1.6.2060, 14.1.7.1853 and 14.1.8.2060). For the second array it gives me (14.1.6.2060 and 14.1.8.2060).


