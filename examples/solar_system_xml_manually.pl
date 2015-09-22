use strict;
use warnings;

my %DATA = (
   Mercury => [0.4,     0.055   ],
   Venus   => [0.7,     0.815   ],
   Earth   => [1,       1       ],
   Mars    => [1.5,     0.107   ],
   Ceres   => [2.77,    0.00015 ],
   Jupiter => [5.2,   318       ],
   Saturn  => [9.5,    95       ],
   Uranus  => [19.6,   14       ],
   Neptune => [30,     17       ],
   Pluto   => [39,   0.00218    ],
   Charon  => [39,   0.000254   ],
);

my $xml = qq{<?xml version="1.0" encoding="UTF-8"?>\n\n};
$xml .= qq{<solar-system>\n};
for my $planet (sort keys %DATA) {
    $xml .= qq{  <planet name="$planet">\n};
    $xml .= qq{    <average-distance>$DATA{$planet}[0]</average-distance>\n};
    $xml .= qq{    <mass>$DATA{$planet}[1]</mass>\n};
    $xml .= qq{  </planet>\n};
}
$xml .= qq{</solar-system>\n};

print $xml;


use XML::LibXML;
XML::LibXML->load_xml(string => $xml);

