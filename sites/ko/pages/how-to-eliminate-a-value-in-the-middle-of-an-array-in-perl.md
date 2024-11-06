---
title: "Perl의 배열 중간에 있는 값을 제거하는 법"
timestamp: 2013-05-15T08:00:00
tags:
  - undef
  - splice
  - array
  - delete
published: true
original: how-to-eliminate-a-value-in-the-middle-of-an-array-in-perl
books:
  - beginner
author: szabgab
translator: gypark
---


[undef](https://perlmaven.com/undef-and-defined-in-perl)에 대한 예전 문서에 대해 어느 독자께서 다음과 같은 질문을 보내오셨습니다:

Perl에서 배열 중간에 있는 값을 제거하려면 어떻게 해야 합니까?

`undef`과 배열에서 값을 제거하는 것이 관련이 있는지 의문이지만, 추측컨데, 값이 `undef`인 상태를 "비어 있는" 것으로 간주한다면 관련성을 이해할 수도 있겠습니다. 일반적으로 생각하면, 어떤 것을 `undef`으로 세팅하는 것과 그것을 제거하는 것은 서로 별개의 일입니다.


먼저 어떤 배열의 원소 하나의 값을 `undef`으로 세팅하는 법을 알아보고, 그 다음에 배열에서 원소를 제거하는 법을 살펴보겠습니다.

다음과 같은 코드가 있다고 합시다:

```perl
use Data::Dumper qw(Dumper);
my @dwarfs = qw(Doc Grumpy Happy Sleepy Sneezy Dopey Bashful);
print Dumper \@dwarfs;
```

`Data::Dumper`를 사용하여 출력하면 다음과 같이 출력됩니다:

```
$VAR1 = [
          'Doc',
          'Grumpy',
          'Happy',
          'Sleepy',
          'Sneezy',
          'Dopey',
          'Bashful'
        ];
```

## 원소를 undef으로 세팅하기

`undef()` 함수의 리턴값을 이용합니다:

```perl
use Data::Dumper qw(Dumper);
my @dwarfs = qw(Doc Grumpy Happy Sleepy Sneezy Dopey Bashful);

$dwarfs[3] = undef;

print Dumper \@dwarfs;
```

이 코드는 3번 원소(배열의 4번째 원소)를 `undef`으로 세팅하지만, 배열의 크기는 변하지 <b>않습니다</b>:

```
$VAR1 = [
          'Doc',
          'Grumpy',
          'Happy',
          undef,
          'Sneezy',
          'Dopey',
          'Bashful'
        ];
```

`undef()`함수를 직접 배열의 원소에 적용해도 동일한 결과를 얻을 수 있습니다:

```perl
use Data::Dumper qw(Dumper);
my @dwarfs = qw(Doc Grumpy Happy Sleepy Sneezy Dopey Bashful);

undef $dwarfs[3];

print Dumper \@dwarfs;
```

결국 `$dwarfs[3] = undef;`과 `undef $dwarfs[3];`은 우리 의도에 맞게 동일한 일을 합니다.
둘 다 어떤 값을 `undef`으로 세팅합니다.

## splice를 이용하여 배열의 원소를 제거하기

`splice` 함수는 배열의 원소를 아예 제거할 수 있습니다:

```perl
use Data::Dumper qw(Dumper);
my @dwarfs = qw(Doc Grumpy Happy Sleepy Sneezy Dopey Bashful);

splice @dwarfs, 3, 1;

print Dumper \@dwarfs;
```

```
$VAR1 = [
          'Doc',
          'Grumpy',
          'Happy',
          'Sneezy',
          'Dopey',
          'Bashful'
        ];
```

보다시피, 이 경우 배열 중간에서 <b>원소들 중 하나를 삭제하였고</b>, 그에 따라 배열은 원소 하나만큼 짧아졌습니다.

이런 방법으로 <b>배열에서 원소를 제거</b>할 수 있습니다.

더 상세한 내용은 [how to splice arrays in Perl](https://perlmaven.com/splice-to-slice-and-dice-arrays-in-perl)을 참고하세요.

