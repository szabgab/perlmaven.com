
Replace one line with an empty row

```
perl -i -p -e 's/^date://' *.txt
```



Remove one line (that starts with `date:`)

```
perl -i -n -e 'print if $_ !~ /^date:/' *.txt
perl -i -n -e 'print unless /^date:/' *.txt
```


