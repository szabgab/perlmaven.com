---
title: "Name 'main::x' used only once: possible typo at ..."
timestamp: 2013-05-27T19:00:00
tags:
  - warnings
  - strict
  - possible typo
published: true
original: name-used-only-once-possible-typo
books:
  - beginner
author: szabgab
translator: gypark
---


Perl 스크립트 실행 도중 이 경고를 보았다면 여러분은 심각한 곤경에 처한 것입니다.


## 변수에 할당만 하기

변수에 값을 할당하고는 전혀 사용하지 않는 것, 또는 변수에 값을 할당한 적도 없으면서 그 변수를
한 번 사용하는 것, 이런 게 올바른 경우는 어느 코드에서든 거의 없습니다.

아마도 유일하게 "설명이 되는" 경우는, 여러분이 오타를 냈고, 그래서 단 한 번만 사용된 변수가
생겼다는 것입니다.

다음은 <b>변수에 값을 할당만 하고 사용하지는 않는</b> 코드 예시입니다:

```perl
use warnings;

$x = 42;
```

이 코드는 다음과 같은 경고를 냅니다:

```
Name "main::x" used only once: possible typo at ...
```

"main::" 부분과 $가 없다는 것 때문에 혼란스러울 수도 있겠습니다.
"main::" 부분이 있는 이유는 Perl의 모든 변수는 기본적으로 "main" 네임스페이스에 속해 있기 때문입니다.
"main::x"라고 불릴 수 있는 것이 여러개 있고 그 중 하나만이 앞에 $가 붙습니다.
혼란스럽게 들린다면, 걱정하지 마세요. 이건 혼란스러운 게 맞습니다만, 한동안은 다룰 일이 없을 겁니다.

## 값을 읽기만 하기

만일 <b>변수를 한 번만 사용한다면</b>

```perl
use warnings;

print $x;
```

두 가지의 경고를 보게 됩니다:

```
Name "main::x" used only once: possible typo at ...
Use of uninitialized value $x in print at ...
```

이 중 하나는 지금 설명하는 것이고, 다른 하나는
[Use of uninitialized value](/use-of-uninitialized-value)에서 설명하고 있습니다.

## 저기서 뭐가 오타라는 거죠?

...라고 물으실 수도 있겠습니다.

누군가가 `$l1`라는 변수를 사용하고 있었다고 상상해봅시다. 그리고 나중에, 여러분이 와서
같은 변수를 사용하려고 했는데 `$ll`라고 적었습니다. 사용하는 폰트에 따라서 이 둘은
매우 비슷하게 보일 수 있습니다.

아니면 `$color`라는 변수가 있는데, 여러분이 영국인이라서 저 변수를 떠올리면서 자동으로
`$colour`라고 타이핑할 수도 있습니다.

또는 `$number_of_misstakes`라는 변수가 있었는데 여러분이 저 변수 이름에 있는 오타를 발견하지
못하고 `$number_of_mistakes`라고 적습니다.

감이 오셨을 겁니다.

만일 운이 좋다면, 이 실수를 한 번만 하고 말았겠지만, 그렇게까지 운이 좋지 않다면, 잘못된 변수 이름을
두 번 사용하고, 이 경고가 나오지 않게 됩니다. 무엇보다도 같은 변수를 두 번 이상 사용하는 건 충분한
이유가 있었을 겁니다.

그럼 이 문제를 어떻게 피할 수 있을까요?

한 가지 방법은, 변수 이름에 혼동하기 쉬운 글자를 쓰지 않고, 변수 이름을 타이핑할 때 매우 조심스럽게
하는 겁니다.

제대로 이 문제를 해결하고 싶다면, <b>use strict</b>를 쓰십시오!

## use strict

위의 예시에서는 보다시피 strict를 사용하지 않았습니다. 만일 strict를 썼다면, 오타일 가능성에 대해
경고가 나오는 게 아니라, 컴파일할 때 에러가 나게 됩니다:
[Global symbol requires explicit package name](/global-symbol-requires-explicit-package-name).

이 에러는 잘못된 변수 이름을 두 번 이상 사용하더라도 여전히 발생합니다.

이러면 물론 부랴부랴 잘못된 변수 이름 앞에 "my"를 붙이는 사람들도 있긴 합니다만, 여러분은 그러시지
않을 겁니다, 그렇죠? 여러분은 이 문제에 대해 생각해보고 진짜 변수 이름을 찾아보고 발견할 것입니다.

이 경고를 보게 되는 가장 흔한 이유는 strict를 사용하지 않고 있다는 것입니다.

그리고, 그 말은 여러분이 심각한 곤경에 처해 있다는 얘깁니다.

## strict를 사용해도 경고가 발생하는 경우

GlitchMr와 익명의 독자가 지적했듯이, 그 외에도 이 경고가 발생하는 경우가 몇 가지 있습니다:

다음 코드 역시 그 경고를 발생시킵니다.

```perl
use strict;
use warnings;

$main::x = 23;
```

경고 메시지는 다음과 같습니다: <b>Name "main::x" used only once: possible typo ...</b>

여기서 최소한 'main'이 어디서 온 건지는 명확합니다. 다음 예제에서 'Mister'가 어디에서 온 건지도
마찬가지고요. (힌트. 이것은 패키지 이름이고
[패키지 이름에 대한 다른 에러](/global-symbol-requires-explicit-package-name)가 발생하지
않은 상황입니다.) 다음 예제에서 패키지 이름은 'Mister'입니다.

```perl
use strict;
use warnings;

$Mister::x = 23;
```

이번 경고 메시지는 <b>Name "Mister::x" used only once: possible typo ...</b>입니다.

다음 예문 역시 이 경고를 발생시킵니다. 두 번이나:

```perl
use strict;
use warnings;

use List::Util qw/reduce/;
print reduce { $a * $b } 1..6;
```

```
Name "main::a" used only once: possible typo at ...
Name "main::b" used only once: possible typo at ...
```

이것은 `$a`와 `$b`가 내장 함수인 sort에서 사용하는 특별한 변수라서 여러분이 따로
선언할 필요는 없는데, 저 변수들을 한 번만 사용하고 있어서 발생합니다.
(사실 제가 보기에는 이 코드가 저 경고를 낼 이유가 명확하지 않습니다, <b>sort</b>를 사용하는
동일한 코드는 경고가 발생하지 않는 것과 비교하면 말이죠.
[Perl 수도사](http://www.perlmonks.org/?node_id=1021888)들은 알지도 모르겠습니다.)


