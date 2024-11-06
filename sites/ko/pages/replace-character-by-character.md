---
title: "Perl의 tr을 사용하여 문자 대 문자 치환"
timestamp: 2013-11-21T09:05:01
tags:
  - y
  - tr
published: true
original: replace-character-by-character
author: szabgab
translator: johnkang
---


필자의 경우는 이 연산자를 자주 사용하지 않지만 문자 단위의 치환이 필요하다면,
정규표현식을 사용하는것 보다 더 좋은 해결책이 있습니다.
    


펄에서 [tr](/perldoc/tr) 은 하나 하나 이상의 문자를 각각 다른 문자(쌍으로)로 치환 할 수 있는 변환 툴 입니다.


## Simple example

`tr` 는 정규 표현식의 치환 연산자와 매우 유사 합니다.
그렇지만 좀 다른 방법으로 동작 합니다:

```perl
use strict;
use warnings;
use 5.010;

my $text = 'abc bad acdf';
say $text;

$text =~ tr/a/z/;
say $text;
```

모든 `a` 문자를 각각 `z` 로 치환 합니다.

```
abc bad acdf
zbc bzd zcdf
```


## 두개 이상의 문자

```perl
use strict;
use warnings;
use 5.010;

my $text = 'abc bad acdf';
say $text;

$text =~ tr/ab/zx/;
say $text;
```

모든 `a` 문자를 `z` 로 치환 합니다.
모든 `b` 문자를 `x` 로 치환 합니다:

```
abc bad acdf
zxc xzd zcdf
```

## More about tr

`y` 는 `tr` 과 동일한 연산자 이며, 펄 역사에 근거하여 사용 가능 합니다.
tr 에 대한 변경자와 특수한 상황은 [documentation of tr](/perldoc/tr) 에서 확인 하실 수 있습니다.


