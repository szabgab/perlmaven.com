---
title: "Perl의 심볼릭 레퍼런스"
timestamp: 2013-07-19T03:00:00
tags:
  - strict
  - symbolic references
published: true
original: symbolic-reference-in-perl
books:
  - advanced
author: szabgab
translator: gypark
---


`use strict`를 적용할 경우 사용하지 못하게 되는 세 가지 중 하나는
<b>심볼릭 레퍼런스 (symbolic reference)</b>입니다.

이것이 어떻게 여러분의 시간을 절약하고 문제를 피할 수 있게 해주는지 알아봅시다!

왜 심볼릭 레퍼런스를 피하는 게 좋은지 알아봅시다!

언젠가는 심볼릭 레퍼런스를 유용하게 사용하는 예도 보게 될 것입니다.


일반적으로, 심볼릭 레퍼런스는 Perl의 매우 강력한 도구입니다. 그러나 실수로 사용할 경우, 머리를
박박 긁을 일을 잔뜩 만들 것입니다. 모든 스크립트에서 심볼릭 레퍼런스의 사용을 금지시켜 놓고, 왜
이게 필요한지 정확히 알고 있을 때만 허용하도록 하는 게 최선입니다.

## 위험

오래 전 Perl 학습 강좌에서, 토론 끝에 스칼라 변수와 배열, 해시에 동일한 이름을 사용할 수 있다는 언급을
하게 되었습니다. 이것은 권장되는 습관은 아닙니다만 기술적으로는 가능합니다. 저는 다소 도취되어 있었고
제가 말한 대로 동작하는 것을 학생들에게 보여주고 싶었습니다. 그래서 다음과 같은 코드를 작성했습니다:

```perl
my $person = "Foo";
my %person;
$person->{name} = 'Bar';
```

... 그리고는 제가 `$person` 스칼라 변수를 선언했고, "Foo"를 할당했다고 설명했습니다.
그 다음 같은 이름의 해시를 만들었고, 키와 값을 그 해시에 넣었습니다. 이것이 동작하는 것을 보이기 위해
해시의 내용을 출력했습니다.

```perl
use Data::Dumper;
print Dumper \%person;
```

출력은 다음과 같았고 저는 깜짝 놀랐습니다:

```
$VAR1 = {};
```

저는 매우 당황했습니다. 키/값 쌍은 어디로 갔죠?

저는 정말 무슨 일이 벌어진 건지 몰랐습니다.

매우 당황스러운 상황이었죠.

다행히 점심 휴식시간이 되었고, 수프를 먹은 직후에 제가 코드에 <b>strict</b>를 사용하지 않았다는 걸
알았습니다.

## 이해

강의실로 돌아와서 저는 `use strict`를 추가하고 코드를 다시 실행했습니다:

```perl
use strict;
use Data::Dumper;

my $person = "Foo";
my %person;
$person->{name} = 'Bar';
```

다음과 같은 에러 메시지가 나왔습니다:

```
Can't use string ("Foo") as a HASH ref while "strict refs" in use at ...
```

명백히 저는 <b>심볼릭 해시 레퍼런스</b>를 쓰고 있었던 겁니다, 실수로.

사실, 저는 `%person` 해시를 건드리지도 않았습니다. 두번째 할당 구문에서 저는
`$person` 스칼라 변수를 해시 레퍼런스로 사용했습니다. 만일 `$person` 변수가 undef인 상태였다면
이것은 문제가 없었을 것입니다. 이 변수는 해시 레퍼런스로
[autovivify](https://perlmaven.com/autovivification)(pro 페이지)
되었을 것입니다. 이 변수가 이미 문자열을 담고 있기 때문에, Perl은 그 변수에 담긴 문자열을 해시의 이름으로
사용하려고 시도합니다. 그 효과로 저는 `%Foo` 해시의 'name' 키에다 'Bar'를 할당했던 것입니다.

다음과 같이 확인할 수 있습니다:

```perl
use Data::Dumper;

my $person = "Foo";
my %person;
$person->{name} = 'Bar';

print Dumper \%person;
print Dumper \%Foo;
```

출력은 다음과 같습니다:

```
$VAR1 = {};
$VAR1 = {
        'name' => 'Bar'
      };
```

보시다시피, 첫번째로 출력한  `%person`의 내용은 비어있습니다.
그러나 `%Foo` 해시가 어느새 생겨 있고 'name' 키와 'Bar' 값이 들어 있습니다.

분명히 제가 원했던 게 <b>아닙니다</b>.

Perl에는 진짜 레퍼런스가 있기 때문에, 여러분은 이 심볼릭 레퍼런스를 써야 할 일이 거의 없습니다.
그리고 실수로 이런 일이 생겼을 때, 말없이 잘못된 결과가 나오는 것보다는 명백히 에러가 나는 게 낫습니다.

그러니 <b>언제나 use strict를 쓰세요</b>.
