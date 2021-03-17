use strict;
use warnings;
use 5.010;
use utf8;

say ord('a');   # 97
say ord('b');   # 98
say ord('A');   # 65
say ord('=');   # 61
say ord('abc'); # 97

say ord('ű');   # 369 (Hungarian)
say ord('ñ');   # 241 (Spanish)

say ord('א');   # 1488 (Hebrew Aleph)
say ord('אב');  # 1488 (Hebrew Aleph and Bet)
say ord('ב');   # 1489 (Hebrew Bet)

say ord('٣');   # 1635 (Arabic 3)


