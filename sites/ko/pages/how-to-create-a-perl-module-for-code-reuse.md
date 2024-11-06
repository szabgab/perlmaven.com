---
title: "코드 재사용을 위한 Perl 모듈 만들기"
timestamp: 2013-06-23T18:00:00
tags:
  - package
  - use
  - Exporter
  - import
  - @INC
  - @EXPORT_OK
  - $0
  - dirname
  - abs_path
  - Cwd
  - File::Basename
  - lib
  - module
  - 1;
published: true
original: how-to-create-a-perl-module-for-code-reuse
books:
  - advanced
author: szabgab
translator: gypark
---


여러분의 시스템에, 동일한 함수를 사용하는 여러 개의 스크립트들을 만들게 될 수 있습니다.

여러분은 이미 복사-붙여넣기라는 고대의 기술을 숙달했지만, 그 결과에 만족스러워하지 않습니다.

많은 모듈들에 대해 알고 그 모듈이 제공하는 함수를 사용하면서, 여러분도 모듈을 만들고 싶어졌습니다.

그러나, 어떻게 그런 모듈을 만들 수 있는지는 모르고 있습니다.


## 모듈

```perl
package My::Math;
use strict;
use warnings;

use Exporter qw(import);

our @EXPORT_OK = qw(add multiply);

sub add {
  my ($x, $y) = @_;
  return $x + $y;
}

sub multiply {
  my ($x, $y) = @_;
  return $x * $y;
}

1;
```

이것을 somedir/lib/My/Math.pm으로 저장합니다(윈도우에서는 somedir\lib\My\Math.pm).

## 스크립트

```perl
#!/usr/bin/perl
use strict;
use warnings;

use My::Math qw(add);

print add(19, 23);
```

이것은 somedir/bin/app.pl로 저장합니다(윈도우에서는 somedir\bin\app.pl).

이제 <b>perl somedir/bin/app.pl</b>을 실행합니다(윈도우에서는 <b>perl somedir\bin\app.pl</b>).

다음과 같은 에러가 출력될 것입니다:

```
Can't locate My/Math.pm in @INC (@INC contains:
...
...
...
BEGIN failed--compilation aborted at somedir/bin/app.pl line 9.
```

## 뭐가 문제일까요?

저 스크립트에서 우리는 `use` 키워드를 사용하여 모듈을 불러오고 있습니다.
정확히는 `use My::Math qw(add);`를 사용해서 말이죠.
이 코드는 `@INC`라는 기본 내장 변수에 나열된 디렉토리들을 검색하여
<b>My</b>라는 이름의 서브디렉토리와, 그 서브디렉토리 안에 <b>Math.pm</b>라는 이름의 파일이
있는지 찾습니다.

문제는 여러분이 작성한 .pm 파일은 펄의 기본 디렉토리들 중 어느 곳에도 없다는 겁니다: 그 파일은 @INC에 나열된
디렉토리들 어디에도 없습니다.

여러분이 작성한 모듈의 위치를 옮기거나, @INC를 수정하여 이 문제를 해결할 수 있습니다.

첫번째 방법은 문제의 소지가 있습니다. 특히 시스템 관리자와 사용자 간에 엄격하게 구분을 지어놓은 시스템에서
더욱 그렇습니다. 예를 들어 유닉스나 리눅스 시스템에서는 오직 "root"(관리자)만이 이 기본 디렉토리에
쓰기 권한이 있습니다. 따라서 일반적으로는 @INC를 수정하는 것이 더 쉽고 더 옳은 방법입니다.

## 명령행에서 @INC 수정하기

모듈을 불러오기 전에, 모듈이 있는 디렉토리가 @INC 배열에 포함되도록 해야 합니다.

다음과 같이 하면:

<b>perl -Isomedir/lib/ somedir/bin/app.pl</b>.

42라는 답이 출력될 것입니다.

이 경우 `-I` 플래그가 @INC에 디렉토리 경로를 추가하는 역할을 합니다.


## 스크립트 안에서 @INC 수정하기

우리가 작성한 모듈이 있는 "My" 디렉토리가, 스크립트가 있는 디렉토리를 기준으로 고정된 <b>상대 경로에</b>
있는 것을 알기 때문에, 스크립트를 이렇게 고칠 수도 있습니다:

```perl
#!/usr/bin/perl
use strict;
use warnings;

use File::Basename qw(dirname);
use Cwd  qw(abs_path);
use lib dirname(dirname abs_path $0) . '/lib';

use My::Math qw(add);

print add(19, 23);
```

그리고 다음과 같이 명령하여 실행하면:

<b>perl somedir/bin/app.pl</b>.

이제는 제대로 동작합니다.

방금 수정한 내용을 설명드리겠습니다:

## 상대 경로로 지정된 디렉토리를 가리키도록 @INC를 수정하기

이 줄:
`use lib dirname(dirname abs_path $0) . '/lib';`
은 `@INC`의 앞부분에 상대경로로 지정된 lib 디렉토리를 추가합니다.

`$0` 변수는 현재 실행되는 스크립트의 이름이 담겨 있습니다.
`Cwd` 모듈의 `abs_path()` 함수는 스크립트의 절대 경로를 반환합니다.

`File::Basename` 모듈의 `dirname()` 함수에 파일이나 디렉토리의 경로를
넘겨주면 마지막 부분을 제외하고 디렉토리 부분을 반환합니다.

우리 경우에 $0에는 app.pl이 들어가 있습니다.

abs_path($0)은 .../somedir/bin/app.pl을 반환합니다.

dirname(abs_path $0)은 .../somedir/bin을 반환합니다.

dirname( dirname abs_path $0)은 .../somedir을 반환합니다.

여기가 우리 프로젝트의 루트 디렉토리입니다.

이제 dirname( dirname abs_path $0) . '/lib' 는 .../somedir/lib 디렉토리를 가리킵니다.

따라서 우리가 저기에 한 것은 기본적으로

`use lib '.../somedir/lib';`

와 같지만, 전체 트리의 실제 위치를 코드에 적지 않고 해내었습니다.

이 라인이 수행한 최종 작업은 '.../somedir/lib'가 @INC의 첫번째 원소가 되도록 한 것입니다.

이러고 나면, 이후에 오는 `use My::Math qw(add);` 호출은 '.../somedir/lib' 안에서
'My' 디렉토리를 찾고, '.../somedir/lib/My' 안에서 Math.pm을 찾을 것입니다.

이런 방법의 장점은 스크립트를 사용하는 사용자가 명령행에 -I...을 넣는 걸 기억할 필요가
없다는 점입니다.

다른 상황에서
[@INC를 수정하는 방법](/how-to-change-inc-to-find-perl-modules-in-non-standard-locations)이
여러 가지 있습니다.



## use에 대한 설명

앞서 말씀드린 것처럼, `use`는 My 디렉토리와 그 안에 Math.pm 파일을 찾게 됩니다.

처음으로 발견된 파일이 메모리에 적재되고 My::Math 모듈의 `import` 함수가
호출되는데 이 때 모듈 이름 뒤에 적힌 파라메터들이 넘어갑니다. 이번 경우에는
`import( qw(add) )`가 호출되고 이것은 `import( 'add' )`를 호출하는 것과
같습니다.

## 스크립트에 대한 설명

스크립트 쪽에는 더 설명할 게 그다지 남지 않았습니다. `use` 구문이 `import` 함수를
호출하며 끝나고 나면 우리는 My::Math 모듈에서 새로 들여온(import) <b>add</b> 함수를 그냥 호출할
수 있게 됩니다. 마치 이 스크립트 안에서 함수를 선언한 것처럼 말이죠.

더 흥미로운 것들은 모듈 쪽에 있습니다.



## 모듈에 대한 설명

Perl의 모듈은 하나의 이름 공간이며, 그 이름 공간에 대응되는 파일에 들어 있습니다.
`package` 키워드가 그 이름 공간을 생성합니다. My::Math라는 이름의 모듈은
My/Math.pm 파일에 대응됩니다. A::B::C라는 이름의 모듈은 @INC에 나열된 디렉토리들 중
어딘가에 있는 A/B/C.pm 파일에 대응됩니다.

앞서 말했듯이, 스크립트에 있는 `use My::Math qw(add);` 구문은 모듈을 불러온 후
`import` 함수를 호출합니다. 대부분은 사람들은 직접 import 함수를 구현하기보다는
`Exporter` 모듈을 불러온 후 그 모듈의 'import' 함수를 들여와서(import) 사용합니다.

네, 좀 혼란스럽죠. 기억해야 할 점은 Exporter 모듈이 import 함수를 제공한다는 점입니다.

이 import 함수는 여러분이 작성한 모듈에 있는 `@EXPORT_OK` 배열을 검사하고
이 배열에 나열된 함수들을 요구가 있을 때 들여올 수 있도록 준비합니다.

좋습니다, 명확히 할 필요가 있군요:
모듈은 함수들을 "내보내고(export)" 스크립트는 그 함수들을 "들여옵니다(import)".

마지막으로 언급할 것은 모듈의 마지막에 있는 `1;`입니다.
기본적으로 use 구문은 모듈을 실행하게 되고 어떤 종류든 참이 되는 구문을 보아야 합니다.
무엇이든 이 구문이 될 수 있습니다. 어떤 사람들은 `42;`라고 적기도 하고, 정말 장난끼 많은 분들은
`"FALSE"`라고 적기도 합니다. 문자들이 들어 있는 문자열은 결국 
[Perl에서는 참으로 간주됩니다](/boolean-values-in-perl).
이런 건 사람들을 헷갈리게 합니다. 심지어 어떤 분은 시구를 인용해 넣기도 합니다.

"임종 명언록(Famous last words)."

정말 멋지군요, 그러나 처음 보는 사람들은 어리둥절할 것입니다.

또한 이 모듈에는 두 개의 함수가 있습니다. 우리는 두 함수 다 내보내기로 했지만,
사용자(스크립트의 작성자)는 그 중 하나만 들여오기를 원했습니다.

## 결론

제가 위에서 설명드린 몇 줄을 제외하면, Perl 모듈을 만드는 것은 정말 간단합니다.
물론 여러분이 모듈에 대해서 알고 싶어할 법한 다른 내용들도 있고 이것들은 다른 기사에서
다루겠습니다만, 지금 내용만으로도 여러분이 자주 쓰는 함수들을 하나의 모듈에 옮기는
데에는 아무런 문제가 없습니다.

한 가지 더, 여러분이 만드는 모듈의 이름을 정하는 데 조언을 드리자면:

## 모듈 이름 짓기

모듈 이름의 각 부분의 첫 글자는 대문자로 나머지 글자들은 소문자로 지정하는 것을 강력하게 권고합니다.
또한 여러 단계로 이루어진 이름 공간을 사용할 것 역시 권장됩니다.

여러분이 Abc라는 이름의 회사에서 일을 하고 있다면, 모든 모듈의 이름을 Abc:: 이름 공간으로 시작하도록
권하겠습니다. 그 회사 안에서 Xyz라는 프로젝트를 수행 중이라면, 그 프로젝트의 모듈들은
Abc::Xyz:: 안에 있어야 합니다.

따라서 만일 환경 설정에 관한 모듈이라면 이 패키지를 Abc::Xyz::Config라 이름붙일 수 있고, 이것은 모듈이
.../projectdir/lib/Abc/Xyz/Config.pm 파일에 들어 있음을 의미하게 됩니다.

부디 그 모듈을 단순하게 Config.pm이라고 이름짓지는 마세요. 그랬다가는
Perl(설치할 때 Config.pm이 같이 설치됩니다)도 여러분도 혼란스러워하게 될 것입니다.


