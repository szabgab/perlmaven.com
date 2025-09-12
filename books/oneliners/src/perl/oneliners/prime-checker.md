# Check if a number is prime

Originally Written by Abigail in 1998 it listed in the [JAPH](https://www.cpan.org/misc/japh) file.

```
perl -E 'say "Prime" if (1 x shift) !~ /^1?$|^(11+?)\1+$/' 23
```


