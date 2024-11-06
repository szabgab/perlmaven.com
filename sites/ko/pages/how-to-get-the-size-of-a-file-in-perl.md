---
title: "파일의 크기를 알아내는 법"
timestamp: 2015-01-13T10:00:00
tags:
  - -s
  - stat
  - File::stat
published: true
original: how-to-get-the-size-of-a-file-in-perl
author: szabgab
translator: gypark
---


`my $filename = "path/to/file.png";`처럼 변수에 어떤 파일의 경로명이 들어있을
때, 그 파일의 크기를 알아내는 가장 쉬운 방법은 `-s` 연산자를 사용하는
것입니다: `my $size = -s $filename;`


```perl
use strict;
use warnings;
use 5.010;

my $filename = "/etc/passwd";
my $size = -s $filename;
say $size;
```


## stat 함수

다른 방법으로는, 내장 함수인 `stat`을 사용하면 파일의 상태를 나타내는
13가지 정보의 리스트를 받을 수 있습니다. 그 중 8번째 (인덱스 7) 원소가
파일의 크기입니다.

```perl
use strict;
use warnings;
use 5.010;

my $filename = "/etc/passwd";
my @stat = stat $filename;
say $stat[7];
```

## 리스트 원소를 즉석으로 가져오기

물론 `stat` 함수의 반환값을 굳이 배열에 담지 않아도 됩니다.
전체 표현식을 괄호로 감싼 후 뒤에 대괄호 안에 인덱스를 적어주면 특정 원소를
곧바로 얻어올 수 있습니다: `(stat $filename)[7];`

```perl
use strict;
use warnings;
use 5.010;

my $filename = "/etc/passwd";
my $size = (stat $filename)[7];
say $size;
```

`$size` 변수도 굳이 사용할 필요가 없습니다. 다만 단순하게
`say (stat $filename)[7];` 또는 `print (stat $filename)[7];`처럼
적으면 안 됩니다.

이 경우 펄이 저 괄호가 `say`나 `print` 함수에 결합된 것으로
간주하고, `[7]`은 `say` 또는 `print`의 반환값에 적용되는
인덱스인 것으로 처리하게 됩니다.

이 문제를 해결하려면 진짜로 `say/print` 함수의 일부가 되는 괄호를 따로
적어주거나, 괄호 앞에 `+` 부호를 적어줍니다.

```perl
use strict;
use warnings;
use 5.010;

my $filename = "/etc/passwd";
say ((stat $filename)[7]);
say +(stat $filename)[7];
```


## 객체 지향

여러 해결방법 중에서 가장 눈으로 봐서 이해하기 쉬운 것은 아마도
[File::stat](https://metacpan.org/pod/File::stat) 모듈을
사용하는 것일 겁니다. 이 모듈에는 펄의 내장 함수 대신 사용할 수 있는
`stat` 함수가 있는데, 이 함수는 객체를 반환하며, 그 객체에 있는
메소드 중에는 파일의 크기를 반환하는 `size` 메소드도 있습니다.

이번 예제에서도 첫 번째 버전은 객체를 `$stat` 변수에 할당한 후
사용하고, 두 번째 버전은 별도의 변수를 쓰지 않고 즉석에서
`size` 메소드를 호출하고 있습니다.

```perl
use strict;
use warnings;
use 5.010;

my $filename = "/etc/passwd";

use File::stat;
my $stat = stat($filename);
say $stat->size;

say stat($filename)->size;
```

