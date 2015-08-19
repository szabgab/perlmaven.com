sub f {
    use warnings;
    use strict;
    (my($txt) = @_);
    if (($txt = (~/(\d+)/))) {
        print($1);
    }
}
use warnings;
use strict;
f('abc def');
f('abc 123 def');
