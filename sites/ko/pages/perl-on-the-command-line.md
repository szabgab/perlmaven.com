---
title: "명령줄에서의 Perl"
timestamp: 2013-06-25T07:45:56
tags:
  - -v
  - -e
  - -p
  - -i
published: true
original: perl-on-the-command-line
books:
  - beginner
author: szabgab
translator: keedi
---


[Perl 학습서](/perl-tutorial)의 대부분은 파일에 저장한 스크립트를
다루지만 이번에는 몇 가지 원-라이너(one-liner)의 예를 살펴보겠습니다.

비록 여러분이 스크립트를 편집기 안에서 실행할 수 있는
[Padre](http://padre.perlide.org/)나 다른 IDE를 사용하더라도
명령줄(또는 쉘)과 친숙해지고 그곳에서 perl을 사용할 수 있는 것은 매우 중요합니다.


리눅스를 사용하고 있다면 터미널 창을 여세요.
아마 $ 기호가 있는 프롬프트를 볼 수 있을 것입니다.

윈도우를 사용한다면 실행창을 열고 다음 순서대로 실행하세요.

시작 -> 실행 -> "cmd"를 입력 -> 엔터

프롬프트가 있는 검은 색 CMD 창을 볼 수 있을 것입니다.
아마 이 창은 다음처럼 생겼을 것입니다.

```
c:\>
```

## Perl 버전

`perl -v`를 입력하세요.
이 명령은 다음과 같은 결과를 출력합니다.

```
C:\> perl -v

This is perl 5, version 12, subversion 3 (v5.12.3)
  built for MSWin32-x86-multi-thread

Copyright 1987-2010, Larry Wall

Perl may be copied only under the terms of either the Artistic License or the
GNU General Public License, which may be found in the Perl 5 source kit.

Complete documentation for Perl, including FAQ lists, should be found on
this system using "man perl" or "perldoc perl".  If you have access to the
Internet, point your browser at http://www.perl.org/, the Perl Home Page.
```

출력 결과를 살펴보면, 현재 윈도우 장비에 5.12.3 버전의 Perl이 설치되어 있음을 알 수 있습니다.

## 숫자 출력하기

이제 `perl -e "print 42"`를 입력해보세요.
이 명령은 화면에 숫자 `42`를 출력합니다.
윈도우에서 프롬프트는 다음 줄에 나타납니다.

```
c:>perl -e "print 42"
42
c:>
```

리눅스에서는 다음처럼 출력됩니다.

```
gabor@pm:~$ perl -e "print 42"
42gabor@pm:~$
```

결과는 줄의 시작에 출력되며 바로 이어서 프롬프트가 따라 나옵니다.
이 차이는 두 명령줄 인터프리터의 동작 방식에 기인합니다.

앞의 예제에서 `-e` 플래그를 사용했는데 이것은 perl에게
"파일을 기대하지 마세요. 명령줄 다음에 나오는 것은 실제 펄 코드입니다."
라고 알려줍니다.

물론 앞의 예제는 그렇게 흥미롭지는 않습니다.
이것을 설명하는 대신 조금 더 복잡한 예제를 살펴보죠.

## Java를 Perl로 교체하기

이번 명령은 다음과 같습니다.
`perl -i.bak -p -e "s/\bJava\b/Perl/" resume.txt`
이 명령은 여러분의 이력서 파일에 있는 <b>Java</b> 단어를
<b>Perl</b> 단어로 모두 바꾸어 버립니다.
원래의 파일은 백업 파일로 유지하면서 말이죠.

리눅스에서는 심지어 이렇게 사용할 수도 있습니다.
`perl -i.bak -p -e "s/\bJava\b/Perl/" *.txt`
이 명령은 현재 디렉터리 하부의 모든 텍스트 파일의 내용에서
Java를 Perl로 바꾸어 버립니다.

이후의 장에서 원-라이너에 대해 더 이야기를 나누고
원-라이너를 어떻게 사용하는지 배울 것입니다.
원-라이너에 대한 지식은 여러분 손 안의 매우 강력한 무기라고 말할 수 있습니다.

어쨌든 여러분이 몇몇 매우 유용한 원-라이너에 흥미가 생겼다면 Peteris Krumins씨의
[Perl 원-라이너 설명](http://www.catonmat.net/blog/perl-book/)
문서를 읽어볼 것을 추천합니다.

## 다음

다음 편은 [코어 Perl 문서와 CPAN 모듈 문서](https://perlmaven.com/core-perl-documentation-cpan-module-documentation)입니다.
