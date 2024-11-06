---
title: "Global symbol requires explicit package name"
timestamp: 2013-05-04T17:09:08
tags:
  - strict
  - my
  - package
  - global symbol
published: true
original: global-symbol-requires-explicit-package-name
books:
  - beginner
author: szabgab
translator: yongbin
---


<b>Global symbol requires explicit package name</b> 오류는 Perl에서 가장 흔하게 만날 수 있는 오류메시지입니다. 하지만 제 생각에 이 오류메시지는 적어도 초심자들에게는 이해하기 어려운 아주 모호한 에러메시지라고 생각합니다.

이 오류를 빠르게 해결하는 방법은 "사용하는 모든 변수를 미리 <b>my</b>로 선언" 하는 것입니다.


## 단순한 예제

```perl
use strict;
use warnings;

$x = 42;
```

위 코드를 실행하면

```
Global symbol "$x" requires explicit package name at ...
```

우리는 위와 같은 오류메시지를 만나게 됩니다. - 전역 변수 "$x"는 명시적인 패키지 이름이 필요합니다. 이 메시지의 내용은 정확하지만, 초심자들에게 유용하지는 않습니다. 왜냐하면, 초심자들은 패키지에 대해서 아직 배우지 않았을 뿐만 아니라 어떻게 해야 $x보다 더 명시적인 이름인지 모르기 때문입니다.

일차적으로 이 오류의 원인은 use strict에 있습니다.

use strict 문서에 명시된 설명된 내용은 다음과 같습니다.

<i>
This generates a compile-time error if you access a variable that wasn't
declared via "our" or "use vars", localized via "my()", or wasn't fully qualified.

미리 our와 use vars를 통해 선언되거나 my()를 통해서 지역화(localize)되지 않은 변수를 축약형태로 접근할 경우 컴파일시점에 오류가 발생합니다.
</i>

초심자들은 단지 모든 스크립트에는 <b>use strict</b>를 사용해야 한다고 알고 있고 이 문제는 my를 통해 피할 수 있다고 배울 뿐 더 자세한 내막은 모르는 경우가 많습니다.

저는 이 오류메시지가 어떻게 변경되는 것이 옳은지는 잘 모르겠습니다. 다만 이 기사를 통해 초심자들이 자신들의 언어로 위 오류메시지가 정말 의미하는 내용을 이해할 수 있게 되었으면 좋겠습니다.

먼저 저 오류를 피하기 위한 한가지 방법은 아래와 같습니다.

```perl
use strict;
use warnings;

my $x = 42;
```

<b>사용하려고 하는 모든 변수를 사용하기 전에 미리 my로 선언</b>하는 방법입니다.

## 나쁜 해결 방법

문제를 해결하는 다른 방법으로 <b>strict</b> 를 제거하는 방법이 있습니다.

```perl
#use strict;
use warnings;

$x = 23;
```

위 코드는 에러없이 동작하지만, 또 다른 [Name "main::x" used only once: possible typo at ...](/name-used-only-once-possible-typo) 경고를 출력합니다.

여러분들이 운전벨트 없이 운전하지 않듯이 strict 없이 프로그램을 작성하는것은 매우 안전하지 않은 방법입니다.

## 두번째 예제 : 범위
초심자들이 이 오류를 만나는 또 다른 흔한 경우는 아래와 같은 상항입니다.

```perl
use strict;
use warnings;

my $x = 1;

if ($x) {
my $y = 2;
}

print $y;
```

위 코드도 첫번째 예제와 마찬가지로 아래와 같은 오류를 출력합니다.

```
Global symbol "$y" requires explicit package name at ...
```

시키는 데로 모든 변수를 사용하기 전에 `my`로 선언했는데 오류를 만나게 되니 처음 프로그램을 작성하는 사람들은 혼란스러워집니다.

먼저 이 코드는 `my $y = 2;` 줄에 들여쓰기가 없어서 시각적으로 조금 문제가  있습니다. 만약 위 코드를 공백이나 탭을 이용해 적절하게 들여쓰기를 한다면 다음과 같습니다. 이렇게 보면 문제의 원인이 조금 더 명백해 보입니다.

```perl
use strict;
use warnings;

my $x = 1;

if ($x) {
    my $y = 2;
}

print $y;
```

문제는 변수 `$y`가 블록(중괄호 속)에서 선언되었기 때문에 이 변수는 블록 밖에서는 존재하지 않기 때문에 발생했습니다. 이런 현상을 우리는 <a href="/scope-of-variables-in-perl">변수의 <b>영역</b></a>이라고 부릅니다.

프로그래밍 언어마다 <b>영역(Scope)</b>의 개념은 서로 다릅니다. Perl에서는 중괄호로 둘러싸인 블록이 하나의 영역을 만듭니다. 만약 블록 안에서 변수를 `my`로 선언하면 그 변수는 블록 밖에서는 접근할 수 없습니다.

오류를 해결할수 있는 방법은 아래와 같이 `print`를 블럭 안에서 호출하는 방법이 있습니다.

```perl
use strict;
use warnings;

my $x = 1;

if ($x) {
    my $y = 2;
    print $y;
}
```

아니면 아래와 같이 해당 변수를 블록 밖에서 미리 선언하는 방법도 있습니다.

```perl
use strict;
use warnings;

my $x = 1;
my $y;

if ($x) {
    $y = 2;
}

print $y;
```

위 두 가지 방법은 문법적으로 오류를 해결하는 방법을 제시한 것입니다. 실제로 둘 중 어떤 방법을 사용할지는 그 시점에 하려고 하는 일에 따라 달라집니다.

참고로 마지막 예제에서 안쪽 블록에서 `my` 로 `$y`를 선언하거나, `$x`가 참이 아니라면 우리는 [Use of uninitialized value](/use-of-uninitialized-value) 경고를 받게 됩니다.

## The other ways

우리는 `our`나 `user vars`를 사용하거나 이름공간을 포함한 전체 변수이름을 사용해서 이 오류를 해결할 수 있습니다. 이 방법들은 다른 기사를 통해서 다루도록 하겠습니다.
