---
title: "Unknown warnings category"
timestamp: 2013-05-27T23:00:00
tags:
  - ;
  - warnings
  - unknown warnings
published: true
original: unknown-warnings-category
books:
  - beginner
author: szabgab
translator: gypark
---


이 메시지는 Perl에서 흔하게 나오는 메시지는 아니라고 생각됩니다. 적어도 저는 일찍이 이것을
본 적이 없습니다. 그러나 최근에 Perl 수강반에서 저를 당혹스럽게 하더군요.


## Unknown warnings category '1'

전체 에러 메시지는 다음과 같습니다:

```
Unknown warnings category '1' at hello_world.pl line 4
BEGIN failed--compilation aborted at hello_world.pl line 4.
Hello World
```

매우 어리둥절합니다, 코드가 아주 간단하기 때문에 더욱 그렇습니다:

```
use strict;
use warnings

print "Hello World";
```

저는 한참이나 이 코드를 들여다봤으나 어떤 문제도 발견하지 못했습니다. 여러분도 보다시피, "Hello World"
문자열도 제대로 출력되었습니다.

저는 당황했고, 문제점을 알아차릴 때까지 한참 걸렸습니다. 아마 여러분은 벌써 알아차리셨을 것 같지만요.

문제는 `use warnings` 뒤에 세미콜론이 빠져 있다는 것입니다. Perl은 print 구문을 실행하고, 그
구문은 문자열을 출력하고 `print` 함수는 성공했음을 알리는 1을 반환합니다.

Perl은 이제 제가 `use warnings 1`라고 작성한 것처럼 간주합니다.

경고들의 종류가 다양히 있지만, 그 중에 "1"이란 범주는 없습니다.

## Unknown warnings category 'Foo'

동일한 문제의 또다른 사례입니다.

에러 메시지는 다음과 같습니다:

```
Unknown warnings category 'Foo' at hello.pl line 4
BEGIN failed--compilation aborted at hello.pl line 4.
```

예제 코드는 어떻게 문자열 안에서 변수가 치환되는지를 보여주는 코드입니다.
제가 "Hello World" 바로 다음에 두번째로 가르치는 예제입니다.

```perl
use strict;
use warnings

my $name = "Foo";
print "Hi $name\n";
```

## 빠뜨린 세미콜론

물론 이런 것은 세미콜론을 빠뜨린다는 포괄적인 문제 중 특수한 경우입니다.
Perl은 그 다음 구문에 가서야 세미콜론이 빠졌다는 것을 알 수 있습니다.

에러 메시지에서 지적된 위치의 직전 라인을 점검해 보는 것은 바람직한 생각입니다.
거기에 세미콜론이 빠져 있을 수 있으니까요.

