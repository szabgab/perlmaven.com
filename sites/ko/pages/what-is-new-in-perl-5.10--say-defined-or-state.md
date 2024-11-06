---
title: "Perl 5.10의 새로운 기능들 say, //, state"
timestamp: 2013-06-04T15:00:00
tags:
  - v5.10
  - 5.010
  - say
  - //
  - defined or
  - state
published: true
original: what-is-new-in-perl-5.10--say-defined-or-state
books:
  - beginner
author: szabgab
translator: johnkang
---


 2007년 12월 18일, 펄 20주년이 되던 해 Perl 5.10 버전이 릴리즈 되었고, 이 새로운 기능들을 소개 하는것은 더 이상 소재감이 아닌것 같습니다. 많은 사람들이 이에 관한 기사를 썼고, 온라인에서 이용 할 수 있는 프리젠테이션도 있습니다. [PerlMonks](http://perlmonks.org/?node_id=654042)에서의 토론을 살펴보면 몇몇의 괜찮은 링크들이 있습니다.
 
많은 펄 사용자들이 신기술 사용에 더디고 어떻게 Perl 5.10 또는 향후 버전이 그들의 인생(삶)을 이롭게 하는지 보고 싶어 하기에 이 기사를 써보려 합니다. 

(이 기사는 2007년 12월 24일 [szabgab.com](https://szabgab.com/) 에서 처음 작성 되었습니다.)

새로운 많은 feature들이 있습니다, 간단한 몇개를 가지고 시작해 봅시다.


## say

`say`라 불리는 새로운 함수가 있습니다. <b>print</b>와 똑같지만 자동으로 new line <b>(\n)</b>을 모든 호출에 덧붙인다는 점이 다릅니다. 엄청나지도 않고 크게 문제될 것이 없습니다. 그렇지만 say는 많은 타이핑을 줄여 줍니다, 특히 디버깅 코드에서 말이죠!.
이와 같이 작성하는 경우가 많습니다.

```perl
print "$var\n";
```

이제 여기에 say를 사용 할 수 있습니다.

```perl
say $var;
```

오래된 코드에서 새로운 함수들이 발견되어지는건 걱정 할 필요가 없습니다.
이 새로운 함수들은 명시적으로 Perl에 요청해야만 사용 할 수 있습니다.

```perl
use feature qw(say);
```

아니면, 해당 코드가 실행 될 수 있는 최소한의 환경(5.10)을 require 할 수 있습니다.

```perl
use 5.010;
```

## defined or

또다른 유용한 함수로는 <b>//</b>, defined-or 연산자 입니다.
이것은 <i>"0은 실제 값이 아니다"</i> 라는 점을 제외 하면
자주 사용하는 <b>||</b> 와 거의 흡사 합니다. bug:

이전엔 스칼라변수에 <b>default 값</b>을 할당 하고 싶을때 아래와 같이 작성 할 수 있었습니다.

```perl
$x = defined $x ? $x : $DEFAULT;
```

꽤 길죠!, 또는 이렇게도 작성 할 수 있습니다.

```perl
$x ||= $DEFAULT;
```

그렇지만 숫자 0 또는 문자열 "0" 또는 빈문자열은 유효한 값으로 취급되지 않습니다.
그래서 이것들은 $DEFAULT 값으로 대체 되어집니다.
어떤 경우에는 문제가 되지 않는 반면에 다른 경우(0 or "0", empty string)에는 버그를 만들게 됩니다.

새로운 defined-or 연산자는 오직 좌항이 `undef`일때만 우항의 값을 반환 함으로써 이러한 문제를 해결 할 수 있습니다. 이제부터 <b>짧고 정확</b>한 형태를 사용 할 것 입니다.

```perl
$x //= $DEFAULT;
```

## state

3번째로 이 기사에서 필자가 본 것은 새로운 <b>state</b> 키워드 입니다. 이 키워드도 선택적이고 아래와 같이 요청되어질 때만 사용 가능합니다.

```perl
use feature qw(state);
```

또는 이렇게

```perl
use 5.010;
```

state가 사용되어질때 <b>my</b>와 유사하지만 state는 변수를 생성하고 오직 한번만 초기화 합니다. C 언어에서의 <b>static</b> variable(사설변수)과 같습니다. 일전에는 아래와 같이 작성 했었어야만 했습니다.

```perl
{
    my $counter = 0;
    sub next_counter {
        $counter++;
        return $counter;
    }
}
```

왜 $counter 변수가 오로지 한번만 0으로 설정 되어지고 어떻게 항상 0보다 큰 값을 반환하는지는 너무 많은 설명이 필요하고, 저 익명블럭 또한 언뜻보기에 모호 합니다.

이제 이와 같이 작성 할 수 있습니다.

```perl
sub next_counter {
    state $counter = 0;
    $counter++;
    return $counter;
}
```

매우 명확해졌습니다.

`state` 키워드의 또다른 사용예는 [Perl에서 경고메시지를 가로채어 저장하기](https://ko.perlmaven.com/how-to-capture-and-save-warnings-in-perl)를 확인 해보세요.
