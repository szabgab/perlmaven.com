---
title: "신기한 단항 덧셈 연산자 (+)"
timestamp: 2015-01-16T20:00:00
tags:
  - B::Deparse
  - +
published: true
original: the-magic-unary-plus
books:
  - beginner
author: szabgab
translator: gypark
archive: true
---


[파일 크기를 알아내는 법에 대한 기사](/how-to-get-the-size-of-a-file-in-perl)에
`say (stat $filename)[7];`이라는 코드가 있었습니다. 이 코드는 처음 생각했던 대로
동작하지 않았고, 그 문제를 해결하는 방법 중 하나는 괄호 앞에 `+`를 붙여서
`say +(stat $filename)[7];`와 같이 사용하는 것이었습니다.

여기서 `+` 부호가 정확히 하는 일이 무엇인지 어느 독자분이 질문을 주셨습니다.


[문서에 있는 설명](https://metacpan.org/pod/distribution/perl/pod/perlfunc.pod#print)으로는
`+` 부호는 `print` 함수를 괄호 `(`로부터 분리하고, 펄로 하여금 이 괄호가
print 함수의 매개변수를 둘러싼 용도로 쓰인 게 아니라는 것을 알려준다고 합니다.

이 정도로 충분할지도 모르지만, 더 알고 싶다면
[B::Deparse](https://metacpan.org/pod/B::Deparse) 모듈을 사용하여 펄이 이 코드를
어떻게 받아들이는지를 살펴볼 수 있습니다.

```perl
print +(stat $filename)[7];
```

저 내용을 <b>plus.pl</b> 파일로 저장한 후 `perl -MO=Deparse plus.pl`라고 실행합니다.
그 결과는 다음과 같은 출력과

```perl
print((stat $filename)[7]);
```

그 아래 다음 출력이 나옵니다. 

```
files/plus.pl syntax OK
```

보다시피 `+` 부호는 사라졌고, 그 대신 괄호쌍이 추가되었습니다.
이 추가된 괄호는 `print` 함수의 매개변수를 둘러싸는 괄호입니다.


## say와 함께 쓰일 경우

`print` 함수의 경우를 보았으니, 이번에는 <b>plus.pl</b> 파일에서 `print`
대신에 `say`를 써 보겠습니다.

```perl
say +(stat $filename)[7];
```

`perl -MO=Deparse plus.pl`를 실행하면 결과가 이렇게 나옵니다:

```perl
'say' + (stat $filename)[7];
```

<b>아니???</b>

뜻밖의 결과를 보고, 이게 무슨 뜻인지 몰라 잠시 어리둥절합니다.
그러나 잠시 후에 `say`는 펄에 기본적으로 있는 게 아니라는 게 기억이 납니다.
`say` 함수를 사용하겠다고 어떤 식으로든 미리 알려주어야 합니다.
예를 들면 `use 5.010;`라고 적습니다.

따라서 코드는 다음과 같이 바뀌고:

```perl
use 5.010;

say +(stat $filename)[7];
```

`perl -MO=Deparse files/plus.pl`를 실행하면 이제 다음과 같은 결과가 나옵니다.

```perl
sub BEGIN {
    require 5.01;
}
no feature;
use feature ':5.10';
say((stat $filename)[7]);
```

코드가 많아졌지만, 적어도 `say`의 매개변수를 둘러싼 괄호는 제대로 추가되었습니다.

## 결론

[B::Deparse](https://metacpan.org/pod/B::Deparse) 모듈은 펄이 어떤 코드를
어떻게 해석하는지 알고 싶을 때 유용합니다.

[B::Deparse에 대한 다른 글들](/search/B::Deparse)도 읽어보세요.


