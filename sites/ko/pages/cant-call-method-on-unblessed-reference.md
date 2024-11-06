---
title: "Can't call method ... on unblessed reference"
timestamp: 2014-04-09T02:00:00
tags:
  - B::Deparse
published: true
original: cant-call-method-on-unblessed-reference
books:
  - beginner
author: szabgab
translator: gypark
---


얼마 전에 독자에게서 다음과 같은 질문을 받았습니다:

<blockquote>
`subname $param`과 `subname($param)`의 차이는 무엇입니까?

하나는 잘 동작하는데 다른 하나는 `Can't call method ... on unblessed reference`라고
에러가 납니다.
</blockquote>

다른 말로 표현하면: <b>함수를 호출할 때 매개변수 좌우에 괄호를 넣어야 합니까?</b>


몇 가지 살펴봅시다:

## require

다음 스크립트를 실행한다면 에러가 날 것입니다:
`Storable::freeze $data;`를 호출하는 라인에서 
`Can't call method "Storable::freeze" on unblessed reference at ...` 에러가 납니다.

```perl
use strict;
use warnings;

require Storable;

my $data = { a => 42 };
my $frozen = Storable::freeze $data;
```

문제가 되는 라인을 수정하여 매개변수를 괄호 안에 넣는다면 모든 게 잘 됩니다:
`my $frozen = Storable::freeze($data);`


## B::Deparse

B::Deparse 모듈을 다시 사용해봅시다. 이 모듈은 예전에
[for 루프 문제를 해결하는 데에도 도움이 되었었습니다](https://perlmaven.com/bug-in-the-for-loop-b-deparse-to-the-rescue).

스크립트 첫번째 버전을 `perl -MO=Deparse  store.pl`과 같이 실행해봅시다:

```perl
use warnings;
use strict;
require Storable;
my $data = {'a', 42};
my $frozen = $data->Storable::freeze;
```

그리고 두번째 버전을 실행하면 다음처럼 나옵니다:

```perl
use warnings;
use strict;
require Storable;
my $data = {'a', 42};
my $frozen = Storable::freeze($data);
```

두번째 버전은 우리가 파일에 작성한 코드와 완전히 똑같은 코드를 보여줍니다.
(음, [fat-arrow](https://perlmaven.com/perl-hashes)를 쉼표로 바꾼 것만 제외하면 말이죠,
하지만 이 두 가지가 동일한 것이란 걸 우리는 알고 있습니다.)

반면에, 첫번째 버전에서는, 코드의 중요한 부분이 `$data->Storable::freeze;`와 같이 바뀌어 버렸습니다.

Perl은 우리가 `$data` 객체에 대하여 `Storable::freeze` 메쏘드를 호출한 것으로 간주합니다.
이 코드는 `$data`가
[bless된 레퍼런스](https://perlmaven.com/getting-started-with-classic-perl-oop)였다면
동작했을 겁니다. 그 동작이 우리가 의도했던 것과 좀 다를지는 몰라도 말이죠.

## use

만일 `require Storable;` 부분을 `use Storable;`로 고친다면 두 가지 버전 모두
제대로 동작합니다. 또한 두 경우 모두 B::Deparse 모듈은 `Storable::freeze($data);`라고
코드를 보여줄 것입니다.

## eval "use Storable";

만일 `use`를 직접 부르지 않고 `eval` 뒤에 문자열로 오게 한다면, 원래의 문제가 다시 나타납니다.

## 설명

`use`는 컴파일 타임에 처리됩니다. 펄이 `Storable::freeze` 호출 부분을 보는 시점에는
이미 `Storable` 모듈이 로드되어 있는 상태입니다.

`require`와 `eval "use ...";`는 실행 시간에 처리됩니다. 따라서 펄이
`Storable::freeze $data`를 컴파일하는 시점에는 `Storable::freeze` 함수가
존재한다는 것을 모릅니다. 이 시점에서 펄은 이 코드가 어떤 모습이 되어야 하는지 추정해야 하고,
우리가 <b>간접적인 객체 표기(indirect object notation)</b>를 했다고 부정확하게 추정해 버립니다.
펄은 `$data`가 객체이고 `Storable::freeze`는 그 객체의 메쏘드라고 판단하게 됩니다.

이것이 바로 B::Deparse 모듈이 이 코드를 `$data->Storable::freeze;`로 표시하는 이유입니다.

## 해결책

이 에러를 방지하기 위해서는 여러분이 사용하는 함수가 실제로 사용하는 시점 이전에 정의되거나
로드되어 있도록 해야 합니다.

함수 호출 뒤에 괄호를 사용하는 경우는 이런 제약이 없어지고, 실제 사용하는 부분을 아무 위치에나
둘 수 있도록 해 줍니다.

