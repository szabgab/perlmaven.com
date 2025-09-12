# Remove leading spaces


```
perl -pE 's/^ +//' src/examples/text_with_spaces.txt
```

```
perl -pE 's/^[ \t] +//' src/examples/text_with_spaces.txt
```

Using `\s` looks easy but this will also eliminate every row that has only spaces and/or tabs in it.

```
perl -pE 's/^\s +//' src/examples/text_with_spaces.txt
```


