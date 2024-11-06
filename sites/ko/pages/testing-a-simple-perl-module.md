---
title: "간단한 펄 모듈 테스트하기"
timestamp: 2015-07-21T10:30:00
tags:
  - testing
  - TAP
  - Test::Simple
published: true
original: testing-a-simple-perl-module
author: szabgab
translator: johnkang
---


이제 막 펄로 새로운 모듈을 작성하기 위한 작업에 착수 하였다고 가정해 봅시다.
여러분은 자동화된 테스트를 작성함으로써 모듈의 흐름을 이해하고 작업을 시작 할 수 있습니다.

이해를 돕기 위해 오래된 좋은 수학 예제를 사용 하겠습니다.


모든 프로젝트에 펄 커뮤니티의 <b>best practices</b> 가이드 라인을 따르고
대부분의 CPAN 모듈이 구조화 되어있는것 처럼 Layout을 생성하는것은
아마도 좋은 방안이 될것 입니다.
이는 곧 프로젝트의 모든 파일(모듈, 테스트 그리고 단일 디렉토리 구조 하위의
모든 보조 파일들)을 가지게 되는것을 의미합니다.


이 구조내에서 모듈들은 `lib` 서브디렉토리 하위에 위치 하게 되며,
테스트 스크립트들은 `t` 서브디렉토리 하위에 위치 하게 됩니다.
`.t` 확장자로된 간단한 펄 스크립트입니다.



```
root/
  lib/Math.pm
  t/01_compute.t
```

첫번째 버전의 `Math.pm` 모듈을 만들었으며,
`lib/Math.pm` 위치에 저장 되었습니다.


## 모듈

lib/Math.pm 파일은 이렇게 생겼습니다:

```perl
package Math;
use strict;
use warnings;
use 5.010;

use base 'Exporter';
our @EXPORT_OK = qw(compute);

sub compute {
  my ($operator, $x, $y) = @_;

  if ($operator eq '+') {
      return $x + $y;
  } elsif ($operator eq '-') {
      return $x - $y;
  } elsif ($operator eq '*') {
      return $x - $y;
  }
}

1;
```

위의 코드는 실습하는데 문제가 없으며,
모듈의 자세한 설명은 생략 하겠습니다.

```perl
use 5.010;
use Math qw(compute);
say compute('+', 2, 3);    # 5를 출력할 것입니다.
```


## 테스트

테스트 스크립트는 `compute()` 함수를 호출 하고 결과 값이 기대값과 같은지
확인 합니다. 관례를 따르기 위해 테스트 스트립트를 `t/` 디렉토리 하위에
`.t/` 확장자로 생성했습니다.

`t/01_compute.t` 는 아래와 같습니다.

```perl
use strict;
use warnings;
use 5.010;

use Test::Simple tests => 2;

use Math qw(compute);

ok( compute('+', 2, 3) == 5 );
ok( compute('-', 5, 2) == 3 );
```


## 테스트 스크립트 실행

일단 테스트 코드를 작성 하면 명령줄에서 실행 할 수 있습니다.

```
perl t/01_compute.t
```

다만 현재로썬 프로젝트의 최상위 디렉토리에 있어야 합니다.

운이 좋다면 아래와 같은 오류 메세지를 볼 수 있습니다.

```
1..2
Can't locate Math.pm in @INC (@INC contains:
  /etc/perl /usr/local/lib/perl/5.12.4 /usr/local/share/perl/5.12.4
  /usr/lib/perl5 /usr/share/perl5 /usr/lib/perl/5.12 /usr/share/perl/5.12
  /usr/local/lib/site_perl .) at t/01_compute.t line 7.
BEGIN failed--compilation aborted at t/01_compute.t line 7.
# Looks like your test exited with 2 before it could output anything.
```

펄 스크립트가 펄 표준 라이브러리 디렉토리 내에서 `Math.pm` 모듈을
찾을수 없기 때문입니다. 그리고 이 스크립트는 프로젝트 디렉토리내의 `lib/` 에서
찾아봐야 한다는 것을 알 수 없습니다.

필자가 "운이 좋다면" 이라고 쓴 이유는 더 낳은 상황이기 때문입니다.
운이 안좋은 상황은 혹여나 같은 이름의 모듈이 이미 설치 되어 있는 상황 입니다.
이런 상황에서 펄은 설치되어있는 `Math.pm` 모듈을 로딩 할 것이며, 이는
저희가 작성한 모듈이 아닙니다. `lib/Math.pm`를 수정해도 테스트 스크립트
실행에 적용되지 않을것이며 이를 찾기 위해 많은 시간이 허비 하게 될것입니다.

사실 입니다. 우리 모두에게 발생하는 일입니다.

펄이 우리가 작성한 모듈을 제대로 찾을수 있도록 어디에서 찾아봐야 하는지
알려줘야 합니다. 많이 사용하는 방법으로는 `-I` 명령줄 옵션을 통해서
[일반적이지 않은 위치에서 펄 모듈을 찾기 위해 어떻게 @INC를 수정 하는가](/how-to-change-inc-to-find-perl-modules-in-non-standard-locations) 처럼
모듈이 위치한 디렉토리의 경로를 제공하는 것입니다.


```
perl -Ilib t/01_compute.t
```

출력 결과물은 아래와 같을것 입니다:

```
1..2
ok 1
ok 2
```

## prove 사용

작성된 테스트 코드를 실행하는 더 좋은 방법으로는 `prove`를 이용하여 실행하는 것입니다.
역시나 현재 프로젝트경로 내에 있는 모듈을 사용 하도록 알려줘야 합니다.
스크립트를 직접 실행하는것 보다 더 간단합니다.
모듈들이 `lib/` 서브디렉토리에 존재해야 한다는걸 이미 알고 있기 때문에
`-l` 플래그 옵션만 활성화 해주면 됩니다.

```
prove -l t/01_compute.t
```

출력 결과물은 이전과 좀 다릅니다:

```
t/01_compute.t .. ok
All tests successful.
Files=1, Tests=2,  0 wallclock secs
  ( 0.04 usr  0.00 sys +  0.02 cusr  0.00 csys =  0.06 CPU)
Result: PASS
```

## 설명

이제 몇가지 설명을 시작 하겠습니다. `Math.pm` 에 대한 내용은 이기사에 초점이 마춰져
있지 않기 때문에 따로 설명하지 않겠습니다.
테스트 스크립트와 출력 결과에 초점을 두겠습니다.


테스트의 흥미로운 부분은 아래와 같습니다:

```perl
use Test::Simple tests => 2;

ok( compute('+', 2, 3) == 5 );
ok( compute('-', 5, 2) == 3 );
```

첫째로, 펄에서 테스트 코드를 작성하는데 있어서 가장 간단하고 구조화된 [Test::Simple](https://metacpan.org/pod/Test::Simple) 모듈을 로드 했고, 
얼마나 많은 테스트를 수행 할 것인지 정의 하였습니다.
즉 [Test::Simple](https://metacpan.org/pod/Test::Simple) 에서 로딩된 `ok()` 함수를 얼마나 많이 호출할 것인가 입니다.



이는 출력결과물에서 `1..2` 부분을 생성하게 됩니다.

Test::Simple 모듈이 우리가 계획한 만큼 테스트를 수행 하는지 인지 할 수 있도록
테스트 수행 개수를 선언 했습니다.

`ok()` 함수는 정말 간단한 함수 입니다. 단일 스칼라 값을 취한후
값이 참이면 "`ok`" 거짓이면 "`not ok`" 를 출력 합니다.
또한 몇번째 테스트를 수행하는지 셈을 하여 줄의 마지막에 출력 합니다.
이것이 우리가 얻은 출력 결과물 입니다.



```
1..2
ok 1
ok 2
```

`ok()` 호출의 내부 동작은:

```perl
compute('+', 2, 3) == 5
```

단지 `compute()` 함수를 호출하여 기대값과 비교하는 것입니다.
이 두값이 같으면 참, 그렇지 않으면 거짓 입니다.

## TAP

펄을 이용하여 직접 실행한 테스트 스크립트의 출력물을
[TAP, the Test Anything Protocol](https://perlmaven.com/tap-test-anything-protocol) 이라고 불립니다.

우리가 위에서 `prove()` 사용 했을때, `prove()` 가 테스트 스크립트를 실행하여
TAP 출력물을 수집/분석후 이에 대한 report를 생성한 것입니다.

별거 아닌것 처럼 보일수 있지만, 만약 수백개의 테스트가 정의된
4~5개 정도의 테스트 스크립트를 가지고 있다면 prove에 의해 생성된 report를
보는것이 가공되지 않은 TAP 출력물을 보는것 보다 수월 할 것입니다.

