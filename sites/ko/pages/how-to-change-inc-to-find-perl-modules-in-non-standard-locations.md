---
title: "일반적이지 않은 위치에서 펄 모듈을 찾기 위해 어떻게 @INC를 수정 하는가"
timestamp: 2013-06-04T15:30:00
tags:
  - "@INC"
  - use
  - PERLLIB
  - PERL5LIB
  - lib
  - -I
published: true
original: how-to-change-inc-to-find-perl-modules-in-non-standard-locations
books:
  - beginner
author: szabgab
translator: johnkang
---


Perl 라이브러리 디렉토리에 설치 되어 있지 않은 모듈을 사용할때, perl이 해당 라이브러리들을 찾을 수 있도록 @INC를 수정해야 합니다. @INC를 수정해야 하는 몇가지 사례가 있습니다.

이 사례들을 살펴 봅시다. 첫번째:


## 개인의 펄 모듈 로딩하기

당신은 스크립트를 가지고 있고 스크립트의 일부를 My::Module 이라는 새로운 모듈로 옴기기 시작 했습니다. 그리고 /home/foobar/code/My/Module.pm 에 저장 하였습니다.

이제 당신의 펄 스크립트는 이와 같이 시작 할 수 있습니다.

```perl
use strict;
use warnings;

use My::Module;
```

이 스크립트를 실행할때 아래와 같은 많이 본듯한 error 메세지를 보게 됩니다.

```
Can't locate My/Module.pm in @INC (@INC contains:
    /home/foobar/perl5/lib/perl5/x86_64-linux-gnu-thread-multi
    /home/foobar/perl5/lib/perl5
    /etc/perl
    /usr/local/lib/perl/5.12.4
    /usr/local/share/perl/5.12.4
    /usr/lib/perl5 /usr/share/perl5
    /usr/lib/perl/5.12
    /usr/share/perl/5.12
    /usr/local/lib/site_perl
    .).
    BEGIN failed--compilation aborted.
```

펄은 당신의 모듈을 찾을수 없습니다.

## 펄 모듈 업그레이드 하기

CPAN으로 부터 설치된 펄 모듈을 업그레이드 해야 한다고 생각 되어지는 시스템에서, 아직은 standard location 에 설치 하는것을 원하지 않습니다. 먼저 그 모듈을 private directory에 두고 테스트 해본 뒤 제대로 동작한다고 확신이 들때만 system에 설치 하고 싶을 수 있습니다.

그 모듈을 private directory(e.g. /home/foobar/code)에 설치한 후에도 마찬가지 입니다. 어떻게든 perl이 이미 system에 설치된 버전이 아니라 private directory에 설치된 펄 모듈을 찾도록 알려주고 싶을것 입니다.

## use 구문

펄이 use `My::Module` 구문을 만나면 디렉토리 이름을 담고 있는 내장 `@INC` 배열의 요소들을 살펴봅니다. 각 디렉토리마다 "My"라 불리는 하위 디렉토리가 있는지 확인하고 있다면 "Module.pm" 이란 파일이 있는지 확인합니다.

첫번째로 찾은 파일은 메모리에 적재 되어집니다.

만약 찾지 못하면 위와 같은 error 메세지를 보게 됩니다.

`@INC` 배열은 펄이 컴파일 되어질때 정의 되어 바이너리 코드에 내장 되어집니다. 다시 펄을 컴파일 하지 않는 이상 @INC 배열을 수정 할 수 없습니다. 매일 할수 있는 노릇도 아닙니다.

다행이도 스크립트를 실행할때 `@INC` 배열을 변경 할 수 있습니다. 이러한 해결책들을 확인할 것이며 각각의 해결책의 적절한 사용 방법을 논의 할 것 입니다.

## PERLLIB and PERL5LIB

unix/linux 시스템의 PATH 환경변수를 정의 하는것과 똑같이 PERL5LIB 환경변수를 정의 할수 있습니다(PERLLIB 도 같은 방법으로 동작 하지만, PERLLIB 대신 PERL5LIB를 사용하는것을 추천합니다. Perl 5 에 관련되었다라는 점이 명확 해지기 때문 입니다). 변수에 나열된 모든 디렉토리는 `@INC` 배열의 앞에 추가 되어집니다.

<b>Linux/Unix</b> 에서 <b>Bash</b> 를 사용할때, 이 처럼 작성 할수 있습니다.

```
export PERL5LIB=/home/foobar/code
```

로그인 할때마다 항상 해당 변수를 사용하기 위해 ~/.bashrc에 추가 할 수 있습니다.

<b>Windows</b> 에서는 cmd command 에서 설정 할 수 있습니다.
```
set PERL5LIB = c:\path\to\dir
```

장기적인 해결책을 위해서는 다음 아래의 단계들을 수행 하십시요(Windows 7):

<b>컴퓨터</b> 우클릭, 속성 선택

좌측 패널에서 <b>고급 시스템 설정</b> 선택

시스템속성 창에서 <b>고급</b>탭 선택

해당 고급 섹션에서, <b>환경 변수(N)</b> 버튼 클릭

용도에 맞게 사용자변수 혹은 시스템변수의 <b>새로 만들기(W)</b> 버튼 클릭후 다음과 같이 입력

변수 이름(N) : PERL5LIB

변수 값(V) : c:\path\to\dir

그런다음 확인 버튼을 3번.

이 설정 뒤에 열려진 창들은 새로운 변수에 대해서 알게 됩니다. 새로 설정한 변수를 확인하기 위해 다음과 같이 타이핑 하세요.

```
echo %PERL5LIB%
```

<hr>

이 설정은 똑같은 환경에서 실행되어지는 모든 스크립트의 `@INC`배열 앞 부분에 private directory(/home/foobar/code or c:\path\to\dir)을 추가 하게 됩니다. 

다른 post에서 설명할 <b>taint mode</b> 에서의 실행은 PERLLIB와 PERL5LIB 환경변수를 무시 합니다.

## use lib

스크립트에 `use lib` 구문을 추가 하면 해당 스크립트의 `@INC` 배열에 directory 가 추가 되어집니다. 누가 그리고 어떠한 환경에서 그 스크립트를 실행하는지 개의치 않게 됩니다.

모듈을 불러오기전에 use lib 구문이 있는지 반드시 확인해야 합니다. 

```perl
use lib '/home/foobar/code';
use My::Module;
```

여기서 한가지 언급 하고 싶은것이 있습니다. 의존성 모듈을 불러들이기 위해 use lib 구문을 모듈에 추가하는 몇몇의 펄 사용자들을 보았습니다. 이것은 좋은 방법이라 생각하지 않으며 main 스크립트의 @INC를 변경하는것이 적절합니다. 또는 스크립트의 밖에서 변경하는 다음과 같은 두가지 해결책이 있습니다.

## command line 에서의 -I 옵션

(대문자 I)

마지막 해결책은 가장 임시적인 해결책으로 해당 스크립트를 실행 할때 perl 의 인자로써 `-I /home/foobar/code` 를 추가 하는것 입니다.

<b>perl -I /home/foobar/code script.pl</b>

<b>해당 스크립트의 실행</b>을 위해 /home/foobar/code를 @INC 배열 앞에 추가 할 것입니다.

## 어떤것을 사용하기겠습니까?

단지 새로운 버전의 모듈을 테스트 하고자 한다면, command line 인자를 사용하는 것을 추천 합니다 :
`perl -I /path/to/lib`

만약 private directory에 많은 모듈들이 설치 하려 한다면, 아마도 `PERL5LIB` 환경변수를 사용할 것 입니다
또한 우리는 추후 이러한 동작을 하는 `local::lib` 확인할 것입니다

`use lib` 구문은 다음 두 경우에 사용 되어집니다.

<ol>
<li>system standard location 에 모듈을 설치 할 수 가 없어(권한문제, etc)서 권한의 문제가 없는 다른 곳에 모듈을 설치 했을때.</li>
<li>애플리케이션을 개발 하고 있고 해당 스크립트와 연관된 특정 디렉토리에서 모듈을 불러들여야 할때. 이부분은 또다른 post 에서 다뤄질 것 입니다.</li>
</ol>
