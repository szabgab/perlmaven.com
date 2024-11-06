---
title: "Perl에서 정적 상태 변수 쓰기"
timestamp: 2014-01-16T14:00:00
tags:
  - static
  - state
published: true
original: static-and-state-variables-in-perl
books:
  - advanced
author: szabgab
translator: gypark
---


대부분의 경우 어떤 변수가 작은 영역, 예를 들어 함수 안이나 루프 안에서만 접근할 수 있기를
설정하게 됩니다. 이 변수들은 함수(또는 블록에 의해 만들어진 영역)에 진입할 때
생성되고, 그 영역에서 나올 때 소멸됩니다.

어떤 경우에는, 특히 코드에 별 신경쓰기 싫을 때는, 전역으로 스크립트 내의 어느 곳에서나
접근할 수 있고 스크립트가 종료될 때에야 소멸되는 변수를 쓰기도 합니다. 일반적으로 이런
전역 변수를 쓰는 것은 좋은 습관은 아닙니다.

또 어떤 경우에는 함수의 이번 호출과 다음 호출 사이에는 계속 살아있으면서도, 오직 그 함수에서만
접근가능한 변수를 쓰고 싶을 때가 있습니다. 호출과 호출 사이에는 값이 유지되었으면 합니다.


C 프로그래밍 언어에서는 변수를 [정적(static) 변수](http://en.wikipedia.org/wiki/Static_variable)로
지정할 수 있습니다. 이렇게 지정된 변수는 단 한 번만 초기화되고 함수가 종료되고 다음 번 호출될 때까지 계속 값을
유지하게 됩니다.

Perl에서는, 동일한 효과를 [상태(state) 변수](/what-is-new-in-perl-5.10--say-defined-or-state)를 써서
얻을 수 있습니다. 이것은 펄 5.10에서부터 지원합니다만, Perl 5의 모든 버전에서 쓸 수 있는 다른 방법도
있습니다. 어떤 면에서는 더 효과적인 방법이지요.

예를 들어서 카운터를 만들어 봅시다:

## 상태 변수

```perl
use strict;
use warnings;
use 5.010;

sub count {
    state $counter = 0;
    $counter++;
    return $counter;
}

say count();
say count();
say count();

#say $counter;
```

이 예제에서, [my를 써서 변수를 선언](https://perlmaven.com/variable-declaration-in-perl)하는
대신에, `state` 키워드를 사용하였습니다.

`$counter`는 딱 한 번만 0으로 초기화되며, 그 시점은 처음으로 `counter()`가 호출되었을
때입니다. 다음 번 호출할 때는 `state $counter = 0;` 부분은 실행되지 않으며 `$counter`는
가장 최근에 이 함수가 종료되는 시점에 들어 있던 값이 그대로 들어 있게 됩니다.

따라서 출력은 다음과 같습니다:

```
1
2
3
```

만일 코드 마지막 줄에서 `#`를 제거한다면, 스크립트를 컴파일하는 시점에
[Global symbol "$counter" requires explicit package name at ... line ...](/global-symbol-requires-explicit-package-name)라는
에러가 발생할 것입니다.
이로써 `$counter` 변수를 함수 외부에서 접근하는 것은 불가능하다는 것을 알 수 있습니다.

## state는 첫번째 호출 때 실행됨

이 기묘한 예제를 살펴봅시다:

```perl
use strict;
use warnings;
use 5.010;

sub count {
    state $counter = say "world";
    $counter++;
    return $counter;
}

say "hello";
say count();
say count();
say count();
```

다음과 같이 출력될 것입니다:

```
hello
world
2
3
4
```

이 출력을 통해서 `state $counter = say "hi";` 행은 단 한 번만 실행되며, 실행되는 시점은 `count()`를
처음으로 호출할 때라는 것을 알 수 있습니다. (`say` 역시 [5.10부터 쓸 수 있고](/what-is-new-in-perl-5.10--say-defined-or-state)
출력에 성공하면 1를 반환합니다.)


## "전통적인" 방법으로 구현한 정적 변수

```perl
use strict;
use warnings;
use 5.010;

{
    my $counter = 0;
    sub count {
        $counter++;
        return $counter;
    }
}

say count();
say count();
say count();
```

이 코드는 `state`를 사용한 앞의 코드와 동일한 결과를 보여줍니다. 다른 점은 이 코드는
5.10보다 오래된 버전의 펄에서도 동작한다는 점입니다.
(`say` 키워드 역시 5.10부터 지원되므로 이 키워드도 사용하지 말아야겠지만요)

이 스크립트가 동작할 수 있는 건 펄에서 함수 선언은 항상 전역으로 적용되기 때문입니다 - 따라서 `count()`는
블록 안에서 선언되었지만 스크립트 내부 어디서든 접근할 수 있습니다. 반면에 `$counter` 변수는
블록 안에서 선언되었기 때문에 블록 외부에서는 접근할 수 없습니다.
마지막으로 가장 중요한 점은, 이 변수는 `count()`가 끝나거나 블록 바깥의 코드를 실행하는 도중에도
소멸되지 않는다는 점입니다. 왜냐하면 현재 존재하고 있는 `count()` 함수가 여전히 그 변수를 참조하고
있기 때문입니다.

따라서 `$count` 변수는 사실상 정적 변수가 됩니다.

## 처음 할당되는 시점

```perl
use strict;
use warnings;
use 5.010;

say "hi";

{
    my $counter = say "world";
    sub count {
        $counter++;
        return $counter;
    }
}

say "hello";
say count();
say count();
say count();
```

```
hi
world
hello
2
3
4
```

이 코드의 결과를 보면 여기서도 변수를 선언하고 초기화하는 `my $counter = say "world";` 구문은
단 한번만 실행되는 것을 알 수 있습니다. 그러나 이번에는 이 초기화가 `count()` 함수를 호출하는
것보다 <b>먼저</b> 이루어지는 것도 볼 수 있습니다. 마치 `my $counter = say "world";` 구문이
블록 <b>외부의</b> 코드의 실행 흐름의 일부인 것처럼 말이죠.

## 정적 변수 공유

이러한 "전통적인" 또는 "직접 만든" 정적 변수에는 추가적인 특징이 있습니다.
이 변수가 `count()` 서브루틴에 속한 게 아니라 그 서브루틴을 둘러싼 블록에 속해 있기 때문에,
그 블록 안에서 두 개 이상의 함수를 만들어서 그 함수들이 이 정적 변수를 공유하게 할 수 있습니다.

예를 들어 `reset_counter()` 함수를 추가할 수 있겠습니다:

```perl
use strict;
use warnings;
use 5.010;

{
    my $counter = 0;
    sub count {
        $counter++;
        return $counter;
    }

    sub reset_counter {
        $counter = 0;
    }
}


say count();
say count();
say count();

reset_counter();

say count();
say count();
```

```
1
2
3
1
2
```

이제 두 함수가 `$counter` 변수에 접근할 수 있고, 여전히 블록 바깥에서는 접근할 수
없습니다.

