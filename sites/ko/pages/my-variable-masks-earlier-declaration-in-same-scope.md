---
title: "'my' variable masks earlier declaration in same scope"
timestamp: 2013-06-20T05:00:00
tags:
  - my
  - scope
published: true
original: my-variable-masks-earlier-declaration-in-same-scope
books:
  - beginner
author: szabgab
translator: gypark
---


컴파일 타임에 발생하는 이 경고는, 여러분이 실수로 동일한 변수를 동일한 스코프 내에서
두 번 선언할 때 발생합니다.

```
"my" variable ... masks earlier declaration in same scope at ... line ...
```

어떻게 이런 경우가 생길 수 있을까요, 또 어째서 루프를 반복할 때마다 변수를 재선언하게 되는 것은
가능한 것일까요?

하나의 스코프 안에서 `my $x`를 두 번 쓰는 것이 불가능하다면, 변수를 비우기 위해서는
어떻게 해야 할까요?


다음 몇 가지 경우의 차이점을 살펴봅시다:

## 평범한 스크립트

```perl
use strict;
use warnings;

my $x = 'this';
my $z = rand();
my $x = 'that';
print "OK\n";
```

이 경우 다음과 같이 컴파일 타임에 경고가 뜹니다:

```
"my" variable $x masks earlier declaration in same scope at ... line 7. )
```

스크립트를 실행하면 "OK" 역시 출력되는 것으로 보아 이것은 단지 경고일 뿐이라는 걸 알 수 있습니다.

## 조건문 내의 블록

```perl
use strict;
use warnings;

my $z = 1;
if (1) {
    my $x = 'this';
    my $z = rand();
    my $x = 'that';
}
```

이것은 다음과 같은 경고문을 발생시킵니다:

```
"my" variable $x masks earlier declaration in same scope at ... line 7.
```

두 경우 모두, 동일한 스코프 내에서 `$x`를 두 번 선언했고, 이것은
컴파일 타임에 경고를 발생시킵니다.

두번째 예제의 경우 `$z` 역시 두 번 선언했으나, 이것은 아무런 경고를 띄우지 않습니다.
왜냐하면 블록 안의 `$z`는 별개의 [스코프](/scope-of-variables-in-perl)
안에 있기 때문입니다.

## 함수의 스코프

동일한 코드인데, 이번에는 함수 안에서입니다:

```perl
use strict;
use warnings;

sub f {
    my $x = 'this';
    my $z = rand();
    my $x = 'that';
}
f(1);
f(2);
```

여기서도, 같은 컴파일 타임 경고를 `$x` 변수에 대해(서만) 보게 됩니다.
함수를 호출할 때마다 변수 `$z`가 반복적으로 '생겨나게' 되지만, 이것은 괜찮습니다.
`$z` 변수는 이 경고를 발생시키지 않습니다: Perl은 동일한 변수를 두 번 생성할 수
있지만, 여러분은 그러면 안 됩니다. 적어도 같은 스코프 내에서는 말이죠.

## for 루프의 스코프

동일한 코드인데, 이번에는 루프 안에서입니다:

```perl
use strict;
use warnings;

for (1 .. 10) {
    my $x = 'this';
    my $z = rand();
    my $x = 'that';
}
```

이 코드 역시 `$x` 변수에 대해서만(!) 경고를 띄우지, `$z`에 대해서는
띄우지 않습니다.

이 코드에서도 동일한 일이 루프를 반복할 때마다 <b>매번</b> 발생합니다:
Perl은 매 반복마다 `$z` 변수를 저장할 메모리를 할당할 것입니다.

## "my"가 의미하는 게 도대체 무엇인가?

`my $x`가 의미하는 것은 여러분이 perl에게, 특히 `strict`를 사용할 때,
[현재 스코프](/scope-of-variables-in-perl) 내에서 <b>$x</b>라는 전용 변수를
사용하겠다는 것을 알려주는 것입니다.
이렇게 알려주지 않으면, perl은 바깥쪽 스코프에서 선언을 찾아보게 되고, 어디에서도 선언을
발견하지 못할 경우 컴파일 타임에
[Global symbol requires explicit package name](/global-symbol-requires-explicit-package-name)
에러를 내게 됩니다.

블록 안에 진입하는 것, 함수를 호출하는 것, 루프를 반복하는 것은 매번 새로운 세상에 들어서는
것입니다. 반면에, 동일한 스코프 안에 `my $x`를 두 번 적는 것은 단지 perl에게 같은 말을
두 번 하는 것입니다. 이것은 불필요한 일이고 보통은 어디선가 실수를 했다는 얘기입니다.

달리 말하면, 여러분에게 보이는 이 경고는 코드의 <b>컴파일</b>에 관련된 것이지 실행에 관련된
것이 아닙니다. 이 경고는 개발자가 변수를 선언하는 것에 관련된 것이지 실행 시간에 perl이
메모리를 할당하는 것에 관련된 것이 아니라는 얘기입니다.

## 존재하고 있는 변수를 비우는 방법

하나의 스코프 안에 `my $x;`를 두 번 적을 수 없다면, 그 변수를 "비우려면" 어떻게 해야 할까요?

첫째로, 변수가 어떤 스코프, 즉 중괄호로 둘러쌓인 내부에서 선언되었다면, 이 변수는 그
[스코프](/scope-of-variables-in-perl)를 벗어난 곳을 실행하는 시점에 자동으로
사라질 것입니다.

만일 여러분이 현재 스코프 내에서 스칼라 변수를 "비우기" 원한다면, 그 변수를 `undef`으로
설정하고, [배열이나 해시](/undef-on-perl-arrays-and-hashes)의 경우라면, 빈 리스트를
할당하여 비울 수 있습니다:

```perl
$x = undef;
@a = ();
%h = ();
```

정리하자면, "my"는 perl에게 여러분이 어떤 변수를 사용하기를 원한다는 것을 알려줍니다.
여러분이 "my 변수"를 사용하는 곳에 이르면 perl은 그 변수와 변수의 내용을 담기 위한 메모리를
할당합니다. 
`$x = undef;` 또는 `@x = ();` 또는 `undef @x;`를 수행하게 되면
perl은 현재 존재하고 있는 변수의 내용을 지울 것입니다.


