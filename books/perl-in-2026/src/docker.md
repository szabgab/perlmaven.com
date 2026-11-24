# Docker


## Images

* [szabgab/perl](https://hub.docker.com/r/szabgab/perl)
* [perldocker/perl-tester](https://hub.docker.com/r/perldocker/perl-tester)

## Run

```
docker run -it --rm --workdir /opt -v$(pwd):/opt perldocker/perl-tester:5.44 bash
```

```
docker run -it --rm --workdir /opt -v$(pwd):/opt --user ubuntu szabgab/perl:latest bash'
```

