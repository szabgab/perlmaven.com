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

use XML::Writer;
my $writer = XML::Writer->new(OUTPUT => 'self', DATA_MODE => 1, DATA_INDENT => 2, );
# NEWLINES => 1 is also available but it is not what I wanted. 

$writer->xmlDecl('UTF-8');
$writer->startTag('solar-system');
for my $planet (sort keys %DATA) {
    $writer->startTag('planet', name => $planet);

    $writer->startTag('average-distance');
    $writer->characters($DATA{$planet}[0]);
    $writer->endTag('average-distance');

    $writer->dataElement('mass', $DATA{$planet}[1]);

    $writer->endTag('planet');
}
$writer->endTag('solar-system');

my $xml = $writer->end();
print $xml;

use XML::LibXML;
XML::LibXML->load_xml(string => $xml);

# Document cannot end without a document element
# Document ended with unmatched start tag(s): planet 

