use strict;
use warnings;
use 5.010;

say ord('a');   # 97
say ord('b');   # 98
say ord('A');   # 65
say ord('=');   # 61
say ord('abc'); # 97

say ord('ű');   # 197  (Hungarian)
say ord('ñ');   # 195  (Spanish)

say ord('א');   # 215 (Hebrew Aleph)
say ord('אב');  # 215 (Hebrew Aleph and Bet)
say ord('ב');   # 215 (Hebrew Bet)

say ord('٣');   # 217 (Arabic 3)
