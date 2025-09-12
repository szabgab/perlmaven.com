# Remove trailing spaces

```
$ perl -pE 's/[ \t]+$//' src/examples/text_with_spaces.txt
```

This is not good as it will convert all the file into one long line:

```
perl -pE 's/\s+$//' src/examples/text_with_spaces.txt
```

This fixes it:

```
perl -nE 's/\s+$//; say' src/examples/text_with_spaces.txt
```

```
perl -lpE 's/\s+$//' src/examples/text_with_spaces.txt
```

