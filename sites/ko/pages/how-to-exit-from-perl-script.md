---
title: "Perl 스크립트를 종료하는 방법"
timestamp: 2013-06-22T02:00:00
tags:
  - exit
  - $?
published: true
original: how-to-exit-from-perl-script
books:
  - beginner
author: szabgab
translator: gypark
---


여러분이 [Perl 튜토리알](/perl-tutorial)을 여기까지 따라오시는 동안 모든 스크립트들은
여러분이 만든 파일 안에 들어있는 코드의 마지막 줄에 도달했을 때 종료되었습니다.

하지만 더 일찍 실행을 종료하고자 하는 경우가 있습니다.

예를 들어, 사용자에게 나이를 물어보고 13살 미만이라면 스크립트가 종료되는 식으로 말이죠.


```perl
use strict;
use warnings;
use 5.010;

print "How old are you? ";
my $age = <STDIN>;
if ($age < 13) {
    print "You are too young for this\n";
    exit;
}

print "Doing some stuff ...\n";
```

그저 평범하게 `exit`를 호출하면 됩니다.

## 종료 상태값

여러분이 유닉스/리눅스 셀을 쓴다면, 모든 프로그램이 종료할 때 종료 상태값을 제공하고
그 값은 `$?` 변수에 담기는 것을 알고 계실 겁니다.
펄 스크립트 역시도 `exit()`를 호출할 때 숫자를 인자로 전달함으로써 종료 상태값을
제공할 수 있습니다.

```perl
use strict;
use warnings;
use 5.010;

exit 42;
```

예를 들어 여기에서는 종료 상태값을 42로 설정했습니다. (기본값은 0입니다.)

## 리눅스에서 종료 상태값 확인하기

유닉스/리눅스 시스템에서는 여러분은 스크립트를 `perl script.pl`처럼 실행했을 것이고, 종료
상태값은 `echo $?`를 써서 검사할 수 있습니다.

## Perl 안에서 종료 상태값 검사하기

만일, 예를 들어 [system](https://perlmaven.com/running-external-programs-from-perl) 함수를 사용하여,
하나의 펄 스크립트 안에서 다른 펄 스크립트를 실행한다면, Perl에도 동일한 `$?` 변수가 있어서
"다른 프로그램"의 종료 상태값을 저장하게 됩니다.

여러분에게 script.pl이라는 코드가 있고 "executor.pl"이라는 또다른 코드가 다음과 같이 되어 있다면:

```perl
use strict;
use warnings;
use 5.010;

say system "perl script.pl";
say $?;
say $? >> 8;
```

출력은 다음과 같을 것입니다:

```
10752
10752
42
```

`system` 함수를 호출하면 종료 상태값을 반환하며, 이 값은 또한 Perl의 `$?` 변수에도 저장됩니다.
중요한 것은 이 값은 2바이트 크기이고 실제 종료 상태값은 상위 바이트에 들어간다는 점입니다.
따라서 위에서처럼 42를 다시 얻기 위해서는 비트단위 연산자 `&gt;&gt;`를 사용하여 오른쪽으로
8비트 쉬프트해야 합니다. 위 예제에서 마지막 줄에서 볼 수 있습니다.

