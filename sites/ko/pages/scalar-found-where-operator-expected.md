---
title: "Scalar found where operator expected"
timestamp: 2013-05-31T04:00:00
tags:
  - syntax error
  - scalar found
  - operator expected
published: true
original: scalar-found-where-operator-expected
books:
  - beginner
author: szabgab
translator: gypark
---


이것은 제가 정말 흔하게 보게 되는 에러 메시지입니다. 이해하기 다소 어려워보이는 에러이기도 합니다.

문제는, 사람들이 <b>숫자 연산자</b>와 <b>문자열 연산자</b>에 대해서는 생각하면서, 쉽표
`,`는 연산자로 생각하지 않는다는 점입니다. 그런 사람들에게는 이 에러 메시지에서 사용된
용어는 다소 혼란스럽습니다.

몇 가지 예제를 보도록 합시다:


## 쉼표 누락

코드는 다음과 같습니다:

```perl
use strict;
use warnings;

print 42 "\n";
my $name = "Foo";
```

그리고 에러 메시지는 다음과 같습니다.

```
String found where operator expected at ex.pl line 4, near "42 "\n""
      (Missing operator before  "\n"?)
syntax error at ex.pl line 4, near "42 "\n""
Execution of ex.pl aborted due to compilation errors.
```

이 메시지는 문제가 발생한 위치를 정확하게 보여주고 있습니다. 그러나 저는 많은 분들이
에러 메시지를 읽기도 전에 에디터로 돌아가서 문제점을 고치려고 시도할 것을 압니다.
해결될 것이라 기대하며 수정을 하지만 또다른 에러 메시지를 보게 됩니다.

이번 경우는 숫자 42 뒤에 쉼표 `,`를 넣는 걸 잊어버린 것이 문제입니다.
`print 42, "\n";`가 올바른 모습입니다.


## String found where operator expected

이번 코드에서는 연결 연산자 `.`를 누락했고, 같은 에러 메시지가 나옵니다:

```perl
use strict;
use warnings;

my $name = "Foo"  "Bar";
```

```
String found where operator expected at ex.pl line 4, near ""Foo"  "Bar""
      (Missing operator before   "Bar"?)
syntax error at ex.pl line 54, near ""Foo"  "Bar""
Execution of ex.pl aborted due to compilation errors.
```

의도했던 코드는 다음과 같습니다: `my $name = "Foo" . "Bar";`.

## Number found where operator expected

```perl
use strict;
use warnings;

my $x = 23;
my $z =  $x 19;
```

위 코드는 다음과 같은 에러 메시지를 나오게 합니다:

```
Number found where operator expected at ex.pl line 5, near "$x 19"
  (Missing operator before 19?)
syntax error at ex.pl line 5, near "$x 19"
Execution of ex.pl aborted due to compilation errors.
```

이 코드는 아마도 더하기 `+`나 곱하기 `*` 연산자가 빠졌나봅니다. 물론
반복 연산자 `x`일 수도 있긴 하지만요.

## Syntax error while comma is missing

쉼표가 누락되는 것이 언제나 연산자가 누락된 걸로 인식되는 것은 아닙니다.
예를 들어 다음 코드는:

```perl
use strict;
use warnings;

my %h = (
  foo => 23
  bar => 19
);
```

더 자세한 설명은 없이 다음과 같은 에러 메시지를 생성합니다:
<b>syntax error at ... line ..., near "bar"</b>

숫자 23 뒤에 쉼표를 추가하면 해결됩니다:

```perl
my %h = (
  foo => 23,
  bar => 19
);
```

저는 해시의 모든 쌍 뒤에 쉼표를 붙이는 것을 선호합니다 (이 경우, 19 뒤에도):

```perl
my %h = (
  foo => 23,
  bar => 19,
);
```

이렇게 습관을 들이면 거의 모든 경우에 이런 형태의 에러를 피할 수 있습니다.

## Scalar found where operator expected at

```perl
use strict;
use warnings;

my $x = 23;
my $y = 19;

my $z =  $x $y;
```

```
Scalar found where operator expected at ... line 7, near "$x $y"
    (Missing operator before $y?)
syntax error at ... line 7, near "$x $y"
Execution of ... aborted due to compilation errors.
```

이번에도, $x와 $y 사이에 숫자 연산자나 문자열 연산자가 들어갈 수 있습니다.

## Array found where operator expected

```perl
use strict;
use warnings;

my @x = (23);
my $z =  3 @x;
```

## 그 외에 여러분이 자주 겪는 경우는?

이런 형태의 문법 에러를 겪게 되는 흥미로운 경우를 더 알고 계신가요?


