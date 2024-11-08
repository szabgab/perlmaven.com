# D. Test with a special string
print "D. Test\n";
my $Tmp = '8614547481120	8986011880217742798	460017484706396	1111	';  # 55 characters with 4 tab characters.

print "Length of the string is " . length ($Tmp) . "\n";

if ( substr ($Tmp, 13, 1) eq chr(9)) { 
  print " My string has a tab at 5; = chr(9) \n";
}

if ( substr ($Tmp, 13, 1) eq '	') { 
  print " My string has a tab at 5; = <	> \n";
}

print "1st Location of a Tab is " . index ($Tmp, '	'), 0  . "\n";  # This should be 13.
print "2nd Location of a Tab is " . index ($Tmp, '	'), 15 . "\n";  # This should be 33.
print "3rd Location of a Tab is " . index ($Tmp, '	'), 34 . "\n";  # This should be 49.

print "1st Location of a Tab is " . index ($Tmp, chr(9)), 0  . "\n";  # This should be 13.
print "2nd Location of a Tab is " . index ($Tmp, chr(9)), 15 . "\n";  # This should be 33.
print "3rd Location of a Tab is " . index ($Tmp, chr(9)), 34 . "\n";  # This should be 49.

print "1st Location of a Tab is " . index ($Tmp, '/\t'), 0  . "\n";  # This should be 13.
print "2nd Location of a Tab is " . index ($Tmp, '/\t'), 15 . "\n";  # This should be 33.
print "3rd Location of a Tab is " . index ($Tmp, '/\t'), 34 . "\n";  # This should be 49.

print "1st Location of a Tab is " . index ($Tmp, '\t'), 0  . "\n";  # This should be 13.
print "2nd Location of a Tab is " . index ($Tmp, '\t'), 15 . "\n";  # This should be 33.
print "3rd Location of a Tab is " . index ($Tmp, '\t'), 34 . "\n";  # This should be 49.

print "1st Location of a Tab is " . index ($Tmp, '/t'), 0  . "\n";  # This should be 13.
print "2nd Location of a Tab is " . index ($Tmp, '/t'), 15 . "\n";  # This should be 33.
print "3rd Location of a Tab is " . index ($Tmp, '/t'), 34 . "\n";  # This should be 49.


