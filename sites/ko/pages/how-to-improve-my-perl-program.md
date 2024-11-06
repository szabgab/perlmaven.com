---
title: "내 Perl 프로그램을 개선하는 법"
timestamp: 2013-12-02T14:00:00
tags:
  - open
  - Perl::Critic
  - Perl::Tidy
published: true
original: how-to-improve-my-perl-program
books:
  - beginner
author: szabgab
translator: gypark
---


예전에 사람들이 제게 고쳐야 할 문제점이 있는 코드를 보내오곤 했었습니다.
그 문제점을 고쳐주는 것 외에도 저는 종종 그분들의 펄 코드를 개선할 수 있는
몇 가지 간단한 방법들을 권해드렸습니다.


## 레이아웃 - 특히 들여쓰기

깔끔한 레이아웃을 유지하면 코드를 훨씬 더 읽기 쉽게 만듭니다.
또한 버그의 원인을 찾는 데 도움이 됩니다.
예를 들어 루프가 제대로 들여쓰기가 되어 있지 않다면 특정한 부분이
어디에 속한 것인지 불분명할 것입니다.

저 `next` 문은 어느 `foreach`에 속해 있을까요?

```perl
foreach my $a (@array1) {
foreach my $y (@array2} { }
if (cond) {
next;
}
}
```

아래의 것이 훨씬 더 읽기 쉽습니다:

```perl
foreach my $a (@array1) {
    foreach my $y (@array2} {
    }
    if (cond) {
        next;
    }
}
```

완벽하지는 않지만 [Perl::Tidy](https://metacpan.org/pod/Perl::Tidy)
모듈에 들어 있는 `perltidy`라는 툴을 써서 여러분들의 코드의 레이아웃을
개선할 수 있습니다.

## 변수 이름은 내용을 나타내도록

위 예제에서 `@array1` 안에는 무엇이 들어 있을까요? 우리는 이게 배열이라는
것을 이름 앞의 `@`를 보고 알 수 있습니다. 이 변수의 이름이 array1이라는
것은 그다지 큰 도움이 되지 않습니다. 변수의 이름을 지을 때는 그 변수의 내용을 드러낼
수 있는 이름을 지으세요. 실제 이름이 무엇일지는 프로그램의 문맥에 좌우되겠지만
`@users`나 `@server_names` 같은 이름이면 훨씬 좋을 것입니다.

루프 변수도 마찬가지입니다. `$a`나 `$y` 같은 것보다 더 길고
의미있는 이름들이 있을 겁니다.

## $a와 $b는 사용하지 마세요

특별하게, `$a`와 `$b`는 
[sort](https://perlmaven.com/sorting-arrays-in-perl) 함수에서 사용되는
특수 변수입니다.
이 변수를 다른 곳에 쓰지 마세요. 짧은 일회용 코드에도요!
그저 혼란스러워질 뿐이고 그 변수는 `my` 선언을 필요로 하지 않기 때문에
초보자들을 어리둥절하게 할 것입니다.

(어째서 Perl은 $x가 선언되지 않았다고 불평하면서 $a에 대해서는 불평하지 않죠...?)


## $_ 없애기

Perl의 디폴트 변수 `$_`는 굉장합니다만, 일반적으로는 이것을
코드에 직접 적지는 말아야 합니다.
[디폴트 변수](/the-default-variable-of-perl)의
중요한 점은 여러분이 그것을 직접 타이핑할 필요가 없다는 점입니다.

`$_`는 여러분들 코드에서 눈으로 볼 수는 없어야 합니다.

주요 예외는 
[map](https://perlmaven.com/transforming-a-perl-array-using-map),
[grep](https://perlmaven.com/filtering-values-with-perl-grep)
그리고 유사한 함수들입니다. 여기에서는 직접 적지 않을 수 없습니다.

그 외의 곳에서는, 만일 여러분이 `$_`라고 타이핑해야 한다면, 그건 아마
좀 더 <b>의미있는 이름</b>의 변수를 직접 선언해서 쓸 시점이라는 뜻입니다.

## 언제나 strict 와 warnings를 사용하세요

언제나 [use strict](/strict)와
[use warnings](https://perlmaven.com/installing-perl-and-getting-started)를
사용하세요. 이것들은 여러분의 안전망입니다!

## 렉시컬 파일핸들과 3인자 open

아주 구식 교육:

```perl
open FH, $filename or die;
```

신식 교육:

```perl
open my $fh, '<', $filename or die;
```

더 신식 교육:

```perl
open my $fh, '<:encoding(UTF-8)', $filename or die;
```

쿨한 교육:

```perl
use Path::Tiny qw(path);
my $fh = path($filename)->openr_utf8;
```

[Path::Tiny](https://metacpan.org/pod/Path::Tiny)를 사용하는 쿨한 방법들이
몇 가지 더 있습니다만, 어떤 이유로든 Path::Tiny를 사용하지 못하더라도, 렉시컬 변수
(my $fh)와 파라메터 3개를 사용하는 open을 쓰실 수는 있을 겁니다.

어떤 경우에도,
[오래된 방법으로 파일을 열지는 마세요](https://perlmaven.com/open-files-in-the-old-way).

## 직접적인 객체 표기(Direct object notation)

이것은 문제점이라기보다는 제가 싫어하는 부분입니다.

어떤 클래스의 오브젝트를 생성할 때 다음과 같이 적으세요:

```perl
Module->new(param, param);
```

다음과 같이 간접적인 객체 표기(indirect object notation) 말고요:

```perl
new Module(param, param);
```

모듈의 설명서에서 두번째 방법을 보여주고 있더라도 말이죠.

대부분의 경우 이 두 가지는 동일하기는 합니다만, 모든
스크립트/응용프로그램/프로젝트/회사에서 한 가지 방법을 쓰는 게 더 낫고, 그렇다면, 제발,
첫번째 방법을 쓰세요.

## Perl::Critic 사용하기

[Perl::Critic](https://metacpan.org/pod/Perl::Critic)은 굉장한
모듈입니다. 저는 이 모듈 작성자도 알고 있습니다. 이 모듈에는
<b>perlcritic</b>이라는 툴이 들어 있는데 파일 이름을 입력받아서
개선할 수 있는 부분들의 목록을 알려줍니다.
따로 설정할 수도 있습니다만 디폴트 설정(엄격한 정도 5레벨. "gentle")으로
시작해도 좋습니다.


## 객체 지향 프로그래밍

여러분의 코드가 OOP로 작성되어 있거나, bless를 사용하고 있거나,
접근자 생성기(accessor generator)를 쓰고 있다면, 
[Moo](https://perlmaven.com/moo)나
[Moose](https://metacpan.org/pod/Moose)를
사용하도록 이전함으로써 코드를 개선할 수 있을지 모릅니다.
