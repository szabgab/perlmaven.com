# Remove one line from a file


For example the one that starts with `date:`

```
perl -i -n -e 'print if $_ !~ /^date:/' *.txt
perl -i -n -e 'print unless /^date:/' *.txt
```


