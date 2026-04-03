# Mutation testing

The idea of Mutation testing is to make some change in the application (e.g. replace a `+` sign by a `-` sign) and run the tests. If the tests pass then it means our tests don't protect us from that kind of mutation (change) in the code.

The most recent release of [Devel::Mutator](https://metacpan.org/pod/Devel::Mutator) was in 2016, but it seems to provide this feature.

```
$ mutator mutate lib/MyMath.pm
Mutated files: 1, mutants: 2
```

```
$ mutator test

ubuntu@972783ffddb5:/opt$ mutator test
(1/2) ./mutants/e9418114e5dbd89c283e8c7c2dd5d41d/lib/MyMath.pm ... not ok
--- ./mutants/e9418114e5dbd89c283e8c7c2dd5d41d/lib/MyMath.pm	Fri Apr  3 08:10:46 2026
+++ ./lib/MyMath.pm.bak	Fri Apr  3 07:28:37 2026
@@ -5,7 +5,7 @@
 our $VERSION = '1.00';

 sub add {
-    $_[0] - $_[1];
+    $_[0] + $_[1];
 }

 sub multiply {
(2/2) ./mutants/1eefe0d5238c7e93420f6efc3ac46eb6/lib/MyMath.pm ... ok
Result: FAIL (1/2)
```

It found the problem that the tests don't protect us from changes in the `add` function, but it
did not find the problem about the `multiply` function. Probably because our issue was very esoteric.

It replaced the `+` by `-` which made the test fail. If it replaced it by `*` then the test would pass and the mutator would report this problem as well.

