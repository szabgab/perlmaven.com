---
title: "Use of uninitialized value"
timestamp: 2013-05-26T03:00:00
tags:
  - undef
  - uninitialized value
  - $|
  - warnings
  - buffering
published: true
original: use-of-uninitialized-value
books:
  - beginner
author: szabgab
translator: gypark
---


이것은 Perl 코드를 실행하면서 제일 흔히 보게 되는 경고문들 중 하나입니다.

이것은 경고이고, 실행이 멈추지는 않습니다. 이 경고는 경고 출력 옵션을 켰을 때에만 나타납니다.
경고 출력 옵션은 켜 두는 것을 권장합니다.

경고 출력 옵션을 켜는 가장 일반적인 방법은 `use warnings;` 구문을 여러분의 스크립트나
모듈의 시작 부분에 넣는 것입니다.


더 오래된 방법은 쉬뱅라인(sh-bang line)에 `-w` 표식을 추가하는 것입니다.
보통은 스크립트 첫번째 줄에 다음과 같은 식으로 적습니다:

`#!/usr/bin/perl -w`

두 방법은 조금 차이가 있습니다만, `use warnings`를 사용할 수 있게 된 지 12년 이상 되었는데
이걸 쓰지 않을 이유가 없습니다. 다시 말해서:

언제나 `use warnings;`를 쓰세요!

설명하려고 했던 그 경고문 얘기로 돌아가도록 하겠습니다.

## 간단한 설명

```
Use of uninitialized value $x in say at perl_warning_1.pl line 6.
```

이 경고는 `$x` 변수에 값이 없는(변수의 값이 `undef`이라는 특별한 값인) 상태라는 것을
의미합니다. 값이 한번도 없었던 걸 수도 있고, 어느 시점에 `undef`이 할당되었을 수도 있습니다.

여러분은 이 변수에 마지막으로 값이 할당된 곳이 어디인지를 찾아야 합니다. 또는 그 할당문 코드가
왜 실행되지 못했는지를 알아내야 합니다.

## 간단한 예제

다음 예제는 이 경고를 발생시킵니다.

```perl
use warnings;
use strict;
use 5.010;

my $x;
say $x;
```

Perl은 친절해서, 어느 파일의 어느 행에서 이 경고가 발생했는지를 알려줍니다.

## 단지 경고일 뿐

말했다시피 이 경고는 경고일 뿐입니다. 저 `say` 구문 뒤에 다른 구문이 더 있다면, 그 구문들은
마저 실행됩니다:

```perl
use warnings;
use strict;
use 5.010;

my $x;
say $x;
$x = 42;
say $x;
```

이 코드는 다음과 같이 출력됩니다.

```
Use of uninitialized value $x in say at perl_warning_1.pl line 6.

42
```

## 혼란스러운 출력 순서

조심하세요, 만일 다음과 같이, 경고를 발생시키는 행 이전에 출력 구문이 있다면:

```perl
use warnings;
use strict;
use 5.010;

print 'OK';
my $x;
say $x;
$x = 42;
say $x;
```

출력 결과가 혼동스러울 수 있습니다.

```
Use of uninitialized value $x in say at perl_warning_1.pl line 7.
OK
42
```

여기서, `print`의 결과인 'OK'가 경고문보다 <b>나중에</b> 나타납니다. print문이 경고를
발생시키는 코드보다 <b>먼저</b> 호출되었는데도 말이죠.

이런 이상한 현상은 `입출력 버퍼링(IO buffering)` 때문에 발생합니다.
기본적으로 Perl에서는 STDOUT, 표준 출력 채널은 버퍼를 사용하여 출력합니다.
그러나 STDERR, 표준 에러 채널에는 버퍼를 사용하지 않습니다.

그래서 'OK' 단어가 버퍼 안에서 내보내지길 기다리는 동안 경고문이 먼저 스크린에 도달합니다.

## 버퍼링 끄기

이런 현상을 막기 위해서 STDOUT에 대해 버퍼를 사용하지 않게 할 수 있습니다.

스크립트의 시작 부분에 다음과 같은 코드를 넣으면 됩니다: `$| = 1;`

```perl
use warnings;
use strict;
use 5.010;

$| = 1;

print 'OK';
my $x;
say $x;
$x = 42;
say $x;
```

```
OKUse of uninitialized value $x in say at perl_warning_1.pl line 7.
42
```

(OK 뒤에 개행문자 `\n`을 출력하지 않았기 때문에 경고문이 같은 줄에 출력됩니다.)

## 잘못된 변수 영역

```perl
use warnings;
use strict;
use 5.010;

my $x;
my $y = 1;

if ($y) {
  my $x = 42;
}
say $x;
```

이 코드 역시 `Use of uninitialized value $x in say at perl_warning_1.pl line 11.` 경고를 발생시킵니다.

저는 이런 실수를 여러 번 했었습니다. 주의를 기울이지 않고 `if` 블록 내부에서 `my $x`라고 썼고, 이는
또다른 변수 $x를 생성한 것이고, 42를 그 변수에 넣었으나 블록이 끝날 때 그 변수는 영역을 벗어나 사라져 버립니다.
($y = 1 부분은 실제 코드나 실제 조건이 들어갔던 부분입니다. 이 예제를 좀 더 현실적으로 보이게 하려고 쓰였습니다.)

물론 if 블록 안에서 변수를 선언해야 하는 경우도 있습니다만, 항상 그런 건 아닙니다. 실수로 이렇게 선언할 경우
이 버그를 찾는 건 힘든 일입니다.

