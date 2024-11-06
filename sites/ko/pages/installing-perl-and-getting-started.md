---
title: "펄 설치하고 사용하기"
original: installing-perl-and-getting-started
timestamp: 2015-07-27T05:45:56
tags:
  - strict
  - warnings
  - say
  - print
  - chomp
  - scalar
  - $
  - STDIN
  - <STDIN>
types:
  - screencast
published: true
books:
  - beginner
author: szabgab
translator: johnkang
---


이번 주제는 [펄 튜토리얼](/perl-tutorial)의 첫번째 파트 입니다.

이번 파트에는 Microsoft Windows 시스템에 펄을 어떻게 설치 하고 Windows, Linux 또는 Mac에서
어떻게 펄을 사용하는지 배워 보겠습니다.

그리고 펄 개발환경 셋팅하는 방법을 알아 알아보고, (편집기 또는 IDE를 일컬음)

기본적인 "Hello World" 예제를 다룰 것 입니다.


## Windows

Windows 시스템에서는 [DWIM Perl](http://dwimperl.com/)을 사용할 것입니다.
DWIM Perl은 Perl 컴파일러/인터프리터, [Padre, the Perl IDE](http://padre.perlide.org/) 그리고
많은 CPAN 모듈을 포함 하는 패키지 입니다.

시작하기에 앞서 [DWIM Perl](http://dwimperl.com/) 에 방문하고
<b>DWIM Perl for Windows</b>를 클릭 하세요.

exe 파일을 다운로드 하고 사용할 시스템에 설치 합니다.
계속 진행하기에 앞서 해당 시스템에 다른 Perl이 설치 되어있지 않음을 확인합니다.

2개이상의 Perl이 설치 되어있다 하더라도 이 둘은 동작 하겠지만 좀 더 많은 설명이 필요한 부분입니다.
우선 지금은 해당 시스템에 하나의 Perl버전만 설치/유지 하도록 하겠습니다.

## Linux

최신의 리눅스 배포판에는 대부분 최신버전의 펄을 포함 합니다.
일단 우리는 이 버전의 펄을 사용할 것이며, 편집기로는 대부분의 리눅스 배포판에서 공식 패키지로
제공하는 Padre를 설치하여 사용하거나 일반적은 텍스트 편집기중
하나를 선택하여 사용 할 수 있습니다. vim이나 Emacs에 익숙하다면 편리한것을 사용하시고 Gedit 또한
간단하고 좋은 편집기가 될수 있습니다.


## Apple

Mac은 기본적으로 펄을 포함합니다. 그렇지 않다면 표준설치툴을 이용하여
쉽게 설치 할 수 있습니다.

## Editor and IDE

추천 사항이긴 하지만, 펄 코드 작성을 위해 Padre IDE를 꼭 사용 할 필요는 없습니다.
다음 파트에서 펄 프로그래밍을 위한 몇가지 [editors and IDEs](/perl-editor)
를 소개 할 예정입니다. 다른 편집기를 선택하더라도 Windows 유저에게는
위에서 언급한 DWIM Perl을 설치 할 것을 추천합니다.

DWIM Perl은 많은 확장 번들을 포함하기 때문에 추후 많은 시간을 아낄수 있습니다.

## Video

원하신다면 필자(Gabor)가 YouTube에 올린 [Hello world with Perl](http://www.youtube.com/watch?v=c3qzmJsR2H0) 을 보실수 있습니다.
동영상은 [Beginner Perl Maven video course](https://perlmaven.com/beginner-perl-maven-video-course)에서 확인 하실수 있습니다.

## 첫번째 프로그램

첫번째 펄 프로그램은 아래와 같습니다:

```perl
use 5.010;
use strict;
use warnings;

say "Hello World";
```

하나씩 설명 하겠습니다.

## Hello world

일단 DWIM Perl이 설치 되면
"시작 -> 모든 프로그램 -> DWIM Perl -> Padre" 순으로 실행하면
빈 파일과 함께 편집기가 실행 됩니다.

아래와 같이 입력 하세요.

```perl
print "Hello World\n";
```

보는바와 같이 펄에서는 세미콜론 `;` 이 구문 끝에 옵니다.
우리가 입력한 `\n`는 개행(newline)을 의미합니다.
`print` 함수는 화면에 출력을 합니다.
이 구문이 실행이 될때 펄은 텍스트를 출력하고 마지막에 개행(newline)을 출력합니다.

hello.pl 이름으로 파일을 저장한후 "Run -> Run Script"를 선택하여 실행 할 수 있으며,
다른 윈도우창을 통해서 출력(output)을 확인 할 수 있습니다.

바로 이것이 여러분이 처음으로 작성한 펄 프로그램입니다.

프로그램을 조금더 발전 시켜 봅시다.

## Padre를 사용하지 않는 유저를 위한 command 라인에서의 펄

Padre 또는 [IDEs](/perl-editor)중 하나를 사용하지 않는 경우
편집기는 스스로 펄을 실행 할수가 없습니다.
최소 기본설정은 아닙니다.
쉘을(윈도우는 cmd) 열어 hello.pl이 저장된 디렉토리로 이동한후 
아래와 같이 입력 해야 할 것입니다:

`perl hello.pl`

이것이 명령줄 라인(command line)에서 펄 프로그램을 실행 하는 방법 입니다.

## print() 대신 say()

펄 원라이너를 조금 향상 시켜 봅시다.

First of all let's state the minimum version of Perl we would like to use:
먼저 사용하고자 하는 펄의 최소버전을 명시 합니다.

```perl
use 5.010;
print "Hello World\n";
```

위와 같이 입력후 "Run -> Run Script"를 선택하여 작성된 코드를 실행 할 수 있으며,
실행하기전에 자동으로 저장될 것입니다.

작성된 코드가 필요로 하는 펄의 최소버전을 명시하는것은 일반적으로 좋은 습관 입니다.

또한 위의 경우는 `say` 키워드를 포함한 몇가지 새로운 기능을 추가합니다.
`say` 는 `print` 와 유사하지만 짧고
출력 마지막 부분에 자동으로 개행(newline)을 추가 합니다.

아래와 같이 코드를 수정할 수 있습니다.

```perl
use 5.010;
say "Hello World";
```

`print`를 `say`로 변경하였으며 문자열의 마지막 부분이었던 `\n`를 제거 하였습니다.

아마도 여러분들이 사용하는 펄의 버전은 5.12.3 이나 5.14 일 것입니다.
대부분 최신 리눅스 배포판은 5.10 버전 혹은 더 새로운 버전을 포함합니다.

아쉽게도 아직 오래된 버전의 펄을 사용하는 곳이 있습니다.
5.10미만의 버전에서는 `say()` 키워드를 사용할수 없으며
뒤에 나올 예제에 약간의 수정이 필요로 할수도 있습니다.
5.10버전을 요구하는 기능을 사용할때 언급하도록 하겠습니다.

## Safety net

추가적으로 모든 펄 프로그램에 아래코드의 변경사항을 적용하는것을 적극 권장합니다.
두줄을 추가 하였고, 플라그마라 불리며, 다른언어의 컴파일러 플래그와 매우 흡사 합니다.

```perl
use 5.010;
use strict;
use warnings;

say "Hello World";
```

`use`의 경우 펄에 각 플라그마를 로드하여 활성화 하도록 합니다.

`strict` 와 `warnings` 는 여러분의 코드내에 일반적인 버그를 잡도록 도와주며
심지어 때로는 여러분이 버그를 만들기 이전에 막아줍니다.
이두 플라그마는 매우 유용합니다.

## 사용자 입력

이제 사용자에게 이름을 질의 하고 답변에 이를 포함시킴으로써 예제를 개선 해봅시다.

```perl
use 5.010;
use strict;
use warnings;

say "What is your name? ";
my $name = <STDIN>;
say "Hello $name, how are you?";
```

`$name` 은 스칼라 라고 불리는 변수 입니다.

변수는 <b>my</b> 키워드를 통해 선언 됩니다.
(실제로 `strict` 플라그마가 추가한 필요조건중 하나 입니다.)

스칼라 변수는 항상 `$` 기호로 시작 합니다.
&lt;STDIN&gt; 는 키보드의 입력을 읽는 도구 입니다.

위의 예제를 작성하고 F5를 눌러서 실행해 보세요.

여러분의 이름을 물을 것입니다.
이름을 입력하고 펄에게 여러분이 이름을 다 입력 했다라는것을 알려 주기 위해 ENTER를 눌러주세요.

출력물이 조금 깨져 보이는것을 발견하게 될것입니다:
콤마가 개행(줄바꿈)뒤에 나타납니다. 여러분이 누른 ENTER키 때문이며, 이름을 입력할때 개행이
`$name` 변수에 들어갔습니다.

## 줄바꿈 문제 해결

```perl
use 5.010;
use strict;
use warnings;

say "What is your name? ";
my $name = <STDIN>;
chomp $name;
say "Hello $name, how are you?";
```

문자열의 맨 마지막에 오는 개행을 지우는 `chomp` 라는 특별한 함수가 있습니다.
이는 펄에서 흔한 작업니다.

## 결론

여러분이 작성하는 모든 스크립트에 <b>항상</b> `use strict;` 와 `use warnings;` 를 첫번째
두 구문으로써 추가 하는 것이 좋습니다. `use 5.010;` 를 추가하는것도 또한 권장사항 입니다.

## 연습문제

아래의 코드를 실행해 보세요.

```perl
use strict;
use warnings;
use 5.010;

say "Hello ";
say "World";
```

출력물이 한줄에 출력되지 않습니다. 왜일까요? 어떻게 수정해야 할까요?

## 연습문제 2

사용자에게 두개의 숫자를 하나씩 질의하는 스크립트를 작성하고,
이 두 숫자의 합을 출력하세요.

## 다음은?

다음 펄튜토리얼의 주제는 [editors, IDEs and development environment for Perl](/perl-editor) 에
대한 내용입니다.

