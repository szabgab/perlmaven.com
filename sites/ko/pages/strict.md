---
title: "언제나 use strict!"
timestamp: 2013-08-03T15:00:00
tags:
  - strict
published: true
original: strict
books:
  - beginner
author: szabgab
translator: gypark
---


어째서 언제나 <b>use strict</b>를 써야 하냐고요?

간단합니다. 시간을 절약하고 두통거리를 줄여주거든요.


`use strict;`는 기본적으로 컴파일러 플래그이고 세 가지 중요한 점에서 Perl 컴파일러의 동작방식을
변경하도록 지시합니다.

이 세 가지 항목을 별개로 켜고 끌 수도 있습니다만, `use strict;`라고 펄 파일(스크립트든 모듈이든)의
제일 위에 적는 것만으로 세 가지를 다 켤 수 있습니다.

## use strict의 세 가지 부분

`use strict 'vars';`를 켜면 여러분이
[변수를 선언하지 않고 사용하려 하면](https://perlmaven.com/variable-declaration-in-perl) 컴파일 에러가 나게 됩니다.

`use strict 'refs';`를 켜면 여러분이
[심볼릭 레퍼런스](/symbolic-reference-in-perl)를 사용하려 하면 런타임 에러가 나게 됩니다.

`use strict 'subs';`를 켜면 여러분이
[따옴표로 둘러싸지 않은 식별자(bareword identifier)](/barewords-in-perl)를 부적절하게
쓰려 하면 컴파일 에러가 나게 됩니다.

## strict 끄기

일반적으로는 코드 전체에 대하여 `strict`가 적용되게 하는 게 좋지만, 때로는
`strict`를 꺼야만 사용할 수 있는 특별한 마법을 쓰고 싶을 때가 있습니다.
이런 경우 우리는 strict를 끄고 싶어질 것입니다.

`use strict;`를 써서 켜고 나면, 어떤 렉시컬 영역 안에서 그 중 일부 또는 전부를
끌 수 있습니다. 즉, 중괄호 `{}` 내부에서 strict의 기능 중 일부를 끌 수 있습니다.

```perl
use strict;

if (...) {
   no strict 'refs';
   # do you trick here...
}
```

예제 코드는 위에 있는 세 개의 기사를 살펴보세요.

## 숨겨진 strict

많은 모듈들은 어떤 파일 안에서 그 모듈을 `use`했을 때 자동으로 그 파일에 대해
`use strict`가 켜지게 되어 있습니다.

그런 모듈의 예로는 [Moose](https://metacpan.org/pod/Moose),
[Moo](https://metacpan.org/pod/Moo), [Dancer](https://metacpan.org/module/Dancer),
[Mojolicious](https://metacpan.org/pod/Mojolicious) 등이 있고 이 외에도 더 있습니다.

[그런 모듈의 목록](https://github.com/szabgab/Test-Strict/blob/master/lib/Test/Strict.pm#L242)이
[Test::Strict](https://metacpan.org/pod/Test::Strict)의 소스 안에 들어 있습니다.
여러분이 그런 모듈을 추가로 발견한다면, Test::Strict의 버그 리포트를 통해 알려주시거나
직접 고치신 후 pull 요청을 보내주시기 바랍니다.

## Perl 5.12와 이후 버전

어떤 파일이 Perl 5.12 또는 이후 버전을 요구한다면
(예를 들어 코드 내에 `use 5.012;` 또는 `use 5.12.0;`라고 적혀 있다거나)
이 역시 묵시적으로 `use strict;`를 적용하게 됩니다.

그러니 여러분이 코드를 읽거나 예제코드를 복사해서 쓸 때, strict가 묵시적으로 적용되고 있음을
알고 계시기 바랍니다.
