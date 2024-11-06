---
title: "표준 출력, 표준 에러, 리다이렉션"
timestamp: 2013-06-25T12:50:11
tags:
  - STDOUT
  - STDERR
  - /dev/null
  - $|
  - buffering
published: true
original: stdout-stderr-and-redirection
books:
  - beginner
author: szabgab
translator: gypark
---


프로그램을 명령행 인터페이스를 통해 실행시키면 그 프로그램은 자동으로 두 가지의 출력 채널을
소유하게 됩니다. 하나는 <b>표준 출력(standard output)</b>, 다른 하나는 <b>표준 에러(standard error)</b>라고
부릅니다.

기본적으로 두 채널 다 스크린(쉘, 터미널, 명령행 창 등)에 연결되어 있어서, 섞여서 나오게 됩니다.
그러나 프로그램의 사용자가 그 두 채널을 분리하고 그 중 하나 또는 둘 다 파일로
<b>방향을 재지정(리다이렉트,redirect)</b>할 수 있습니다.


의도는 응용 프로그램의 일상적인 출력은 출력 채널로 내보내고, 경고와 에러 메시지들은 에러 채널로
내보내자는 것입니다.

프로그래머로서 여러분은 어떤 출력이 프로그램의 통상적인 흐름의 일부인지 결정해야 합니다.
그 출력은 표준 출력 채널로 내보낼 것입니다. 나머지 불규칙적인 출력은 표준 에러 채널로 내보낼
것입니다.

사용자가 오직 통상적인 출력만 보기를 원한다면, 에러 채널을 파일로 리다이렉트하여 나중에 따로 검토할
수 있을 것입니다.

## 에러 메시지를 출력하는 방법

Perl의 경우, 어떤 펄 프로그램이 실행되면, 이 두 가지 출력 채널은 두개의 기호로 표현됩니다:
`STDOUT`은 표준 출력을, `STDERR`는 표준 에러를 나타냅니다.

Perl 프로그램 안에서 여러분은 `print` 키워드 바로 뒤에 STDOUT 또는 STDERR를 넣어서 이 두 채널
중 한 곳으로 출력할 수 있습니다:

```perl
print STDOUT "Welcome to our little program\n";
print STDERR "Could not open file\n";
```

(부디 이 표현식에서 STDOUT과 STDERR 뒤에는 쉼표 `,`가 없다는 것에 주의하세요!)

이 스크립트를 실행하면(`perl program.pl`) 스크린에 다음과 같이 나옵니다:

```
Welcome to our little program
Could not open file
```

메시지들이 서로 다른 출력 채널을 통해 나왔다는 걸 알아볼 수 없을 것입니다.

## 기본 출력 채널

사실, 위 스크립트에서는 `STDOUT`을 빼버리고 다음처럼만 적어도 됩니다:

```perl
print "Welcome to our little program\n";
print STDERR "Could not open file\n";
```

여러분의 펄 스크립트가 시작되었을 때, STDOUT은 <b>기본 출력 채널(default output channel)</b>로
설정됩니다. 이 말은 어떤 출력 연산이든, 어디로 출력할지 특별히 지정하지 않는다면 STDOUT으로 출력할
것이라는 얘기입니다.

## 표준 출력 리다이렉트

사용자로서, 코드 내부를 들여다보지 않고도, 이 두 채널을 분리할 수 있습니다:
`perl program.pl > out.txt`라고 실행하면 `>` 기호가 표준 출력 채널을
out.txt 파일로 <b>리다이렉트</b>할 것입니다. 따라서 스크린에는 표준 에러 채널의 내용만 보이게 됩니다:

```
Could not open file
```

out.txt 파일을 열어보면 (메모장, vim, 또는 아무 텍스트 에디터를 써서) 그 안에
`Welcome to our little program`이라고 적혀 있는 것을 볼 수 있을 것입니다.

## 표준 에러 리다이렉트

반면에 `perl program.pl 2> err.txt`처럼 스크립트를 실행하면 `2>` 기호가
에러 채널을 err.txt 파일로 <b>리다이렉트</b>하게 됩니다.

화면에서는 다음처럼 보이고:

```
Welcome to our little program
```

err.txt 파일을 열면, 그 안에 `Could not open file`라는 내용이 들어 있을 것입니다.

## 두 채널 다 리다이렉트

명령행에서 두 기호를 같이 사용하여 동시에 두 채널을 리다이렉트할 수도 있습니다.

`perl program.pl > out.txt 2> err.txt`처럼 스크립트를 실행하면, 스크린은 텅 빈 채로
남아 있을 것입니다. 표준 출력 채널로 나오는 모든 내용은 out.txt 파일에 들어갈 것이고, 표준 에러
채널로 나오는 모든 내용은 err.txt 파일에 들어갈 것입니다.

위 예제에서 out.txt와 err.txt 같은 파일 이름은 완전히 임의로 지은 것입니다. 여러분은 어떠한
이름이라도 사용할 수 있습니다.

## /dev/null

유닉스/리눅스 시스템에는 `/dev/null`라는 특별한 파일이 있습니다.
이것은 블랙홀처럼 동작합니다. 이 파일로 출력되는 것들은 아무런 흔적도 없이 사라지게 됩니다.
이 파일의 주 용도는 사용자가 어떤 프로그램의 정규 출력이나 에러 메시지를 내다버리려 할 때
사용하는 것입니다.

예를 들어, 여러분에게 어떤 응용프로그램이 있고, 여러분이 그걸 수정할 수는 없는데 그 프로그램이
표준 에러 채널로 매우 많은 메시지를 출력한다고 합시다. 여러분이 그 메시지들을 스크린에서 보고
싶지 않다면 파일로 리다이렉트할 수 있습니다. 그러나 그렇게 하면, 여러분의 디스크가 금새
차 버릴 것입니다. 그래서, 이렇게 하는 대신에 표준 에러를 /dev/null로 리다이렉트한다면
운영체제가 여러분이 이 "쓰레기"들을 무시할 수 있도록 도와줄 것입니다.

`perl program.pl 2> /dev/null`

## MS 윈도우의 nul

MS 윈도우에서 `/dev/null`에 대응되는 것은 `nul`입니다.

`perl program.pl > nul`은 표준 출력을 허공으로 날려 버리고,
`perl program.pl 2> nul`는 표준 에러를 날려 버립니다.

## 유닉스/리눅스/윈도우 지원

Perl 내부에서 STDOUT과 STDERR로 구분하여 출력하는 것은 모든 운영체제에서 동작합니다만, 실제로
리다이렉트하는 것은 그렇지 않을 수 있습니다. 이것은 그 운영체제가, 더 정확히 말하면 쉘(명령행)이
어떻게 동작하느냐에 달려 있습니다.

위에 언급한 대부분의 내용은 모든 유닉스/리눅스 시스템과 MS윈도우에서 동작해야 합니다.
특별히 `/dev/null`은 유닉스/리눅스 시스템에서만 사용 가능합니다.

<h2 id="buffering">출력 순서 (버퍼링)</h2>

살짝 주의해야 할 점이 있습니다:

다음과 같은 코드가 있을 때:

```perl
print "before";
print STDERR "Slight problem here.\n";
print "after";
```

출력은 다음과 같이 나올 것입니다:

```
Slight porblem here.
beforeafter
```

"before"와 "after" 둘 다 에러 메시지 <b>다음에</b> 스크린에 도달하는 것을 눈여겨 보세요.
우리는 "before"가 에러메시지보다 먼저 나오길 기대했는데 말이죠.

이렇게 되는 이유는, 기본적으로 Perl은 STDOUT의 출력은 버퍼를 사용하지만 STDERR은 그렇지 않기
때문입니다. 버퍼링을 끄기 위해서는 `$|`라고 불리는 마술봉을 사용하세요:

```perl
$| = 1;

print "before";
print STDERR "Slight problem here.\n";
print "after";
```

```
beforeSlight porblem here.
after
```

STDOUT으로 나가는 문자열에 개행문자를 붙여서 문제를 해결할 수도 있습니다:

```perl
print "before\n";
print STDERR "Slight problem here.\n";
print "after";
```

출력도 좀 더 보기 좋아집니다:

```
before
Slight porblem here.
after
```
