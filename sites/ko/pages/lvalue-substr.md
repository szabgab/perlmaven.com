---
title: "L밸류 substr - 스트링의 일부를 치환하기"
timestamp: 2014-03-19T16:00:00
tags:
  - substr
  - Lvalue
published: true
original: lvalue-substr
author: szabgab
translator: gypark
---


Perl에 있는 몇몇 함수는 신기하게도 할당문의 좌변에 올 수 있습니다.
예를 들어 어떤 문자열의 내용을 변경하고 싶을 때 여러분은
[substr에 매개변수 4개를 주어](/string-functions-length-lc-uc-index-substr)
실행할 수 있고 이 때 네번째 매개변수가 치환할 문자열이 됩니다.
또는 여러분은 `substr`을 L밸류로 사용하고 치환할 문자열을 매개변수 3개짜리 형태의
substr에 할당할 수 있습니다.


`substr $text, 14, 7, "jumped from";`

이것과

`substr($text, 14, 7) = "jumped from";`

이것은 `$text`를 동일하게 변경합니다.

다음 예제를 해봅시다:

## 매개변수가 4개인 substr

```perl
use strict;
use warnings;
use 5.010;

my $text = "The black cat climbed the green tree.";
substr $text, 14, 7, "jumped from";
say $text;
```

## 매개변수가 3개인 substr을 L밸류로 사용

```perl
use strict;
use warnings;
use 5.010;

my $text = "The black cat climbed the green tree.";
substr($text, 14, 7) = "jumped from";
say $text;
```

이 두 코드 모두 다음과 같이 출력합니다:

```
The black cat jumped from the green tree.
```

## 어느 쪽을 사용할까?

저는 매개변수 4개짜리 형태가 더 명확하다고 생각합니다.
여러분의 팀원이 L밸류 형태의 substr을 쓰지 못하도록 강제하고 싶다면
[Perl::Critic](https://perlmaven.com/perl-critic-one-policy) 모듈을
사용할 수 있습니다.
[ProhibitLvalueSubstr](https://metacpan.org/pod/Perl::Critic::Policy::BuiltinFunctions::ProhibitLvalueSubstr)
정책을 켰는지 확인하세요.

