sub compute {
    use strict;
    (my($param) = @_);
    ((return $param) or 'default');
}
use strict;
print('1: ', compute('hello'), "\n");
print('2: ', compute(''), "\n");
