---
title: "Perl에서의 Bareword"
timestamp: 2013-05-26T23:00:00
tags:
  - bareword
  - strict
published: true
original: barewords-in-perl
books:
  - beginner
author: szabgab
translator: gypark
---


`use strict` 는 세 부분으로 나누어집니다. 그 중에 하나, `use strict "subs"`라고도 불리는
부분은 <b>bareword</b>를 부적당하게 사용하지 못하도록 제한합니다.

이게 무슨 뜻이냐고요?


이 제한이 없을 경우 다음과 같은 코드는 제대로 동작하고 "hello"를 출력합니다.

```perl
my $x = hello;
print "$x\n";    # hello
```

문자열을 따옴표 안에 넣는 것에 익숙한 우리에게, 이것은 이상하게 느껴집니다.
그러나 Perl은 기본적으로 <b>bareword</b> - 따옴표로 둘러쌓지 않은 단어 - 가 문자열처럼 동작하는 것을
허용합니다.

위의 코드는 "hello"를 출력할 것입니다.

어, 그러니까, 누군가가 여러분의 스크립트 위쪽에다가 "hello"란 이름의 서브루틴을 추가하기 전까지는 말이죠:

```perl
sub hello {
  return "zzz";
}

my $x = hello;
print "$x\n";    # zzz
```

그렇습니다. 이번 코드에서는 Perl은 hello() 서브루틴을 보고, 이 서브루틴을 호출한 후 반환값을
$x에 할당합니다.

게다가, 누군가 이 서브루틴을 파일의 끝부분, 즉 할당문의 뒤쪽으로 옮긴다면, Perl은 할당문을 실행하는
시점에는 서브루틴을 미처 보지 못하고, 처음처럼 $x에 "hello"가 들어갑니다.

네, 여러분은 우연히라도 이런 혼란스러운 상황에 처하고 싶지 않을 겁니다. 아마 앞으로도 계속 그렇겠지요.
코드 안에 `use strict`를 쓰면 Perl은 코드 내에 bareword인 <b>hello</b>를 쓰는 것을 허용하지
않게 되고, 이런 형태의 혼란을 피할 수 있습니다.

```perl
use strict;

my $x = hello;
print "$x\n";
```

위 코드는 다음과 같은 에러를 발생시킵니다:

```
Bareword "hello" not allowed while "strict subs" in use at script.pl line 3.
Execution of script.pl aborted due to compilation errors.
```

## bareword를 유용하게 사용하는 경우

`use strict "subs"`가 효력을 발휘하고 있더라도 bareword를 사용할 수 있는 경우가 있습니다.

첫번째로, 우리가 만드는 서브루틴들의 이름은 사실 bareword입니다. 이런 것은 문제가 되지 않습니다.

또한, 해시의 원소에 접근할 때 중괄호 안에 bareword를 사용할 수 있고, 화살표 연산자 =>의 좌변에 단어를
쓸 때도 따옴표 없이 쓸 수 있습니다:

```perl
use strict;
use warnings;

my %h = ( name => 'Foo' );

print $h{name}, "\n";
```

위 코드의 두 경우 다 "name"은 bareword이며, use strict가 설정된 상태에서도 허용됩니다.


