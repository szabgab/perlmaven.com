@sorted = sort {
   length $a <=> length $b
     or
    $a cmp $b
} @strings;

