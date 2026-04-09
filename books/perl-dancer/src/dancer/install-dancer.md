# Install Dancer2 using `cpanm`


* Install [cpanm](https://metacpan.org/pod/App::cpanminus) if you don't have it yet:

```sh
$ curl -L https://cpanmin.us | perl - App::cpanminus
```

* Install Dancer2:

```sh
$ cpanm Dancer2
```


Note, during the following pages I am going to use the word Dancer, however the name of the package we are using is Dancer2 and there is also a package called [Dancer](https://metacpan.org/pod/Dancer) which was the first incarnation of this framework.

## Check the installed version

```sh
$ perl -MDancer2 -E 'say $Dancer2::VERSION'
2.1.0
```

You might have a newer version, but this should be the minimal version to be used.


