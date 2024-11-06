---
title: "Perl 에디터"
timestamp: 2013-05-24T08:00:00
tags:
  - IDE
  - editor
  - Padre
  - vim
  - emacs
  - Eclipse
  - Komodo
published: true
original: perl-editor
books:
  - beginner
author: szabgab
translator: gypark
---


Perl 스크립트 즉 Perl 프로그램들은 단지 간단한 텍스트 파일입니다.
어떤 텍스트 에디터를 사용해서도 만들 수 있습니다. 그러나 워드프로세서로 만들 수는 없습니다.
이 기사에서는 몇 가지 에디터와 통합 개발 환경(IDE)을 소개할까 합니다.

이 기사는 [Perl tutorial](/perl-tutorial)의 일부입니다.


## 편집기와 통합개발환경

Perl 프로그램을 개발할 때 평범한 텍스트 에디터를 쓸 수도 있고
<b>통합 개발 환경(Integrated Development Environment)</b>, IDE를 쓸 수도 있습니다.

먼저 여러분이 사용할 만한 주요 플랫폼들에서 쓸 수 있는 편집기들을 소개하고, 플랫폼에
무관한 IDE들에 대해 말씀드리겠습니다.

## 유닉스 / 리눅스

리눅스나 유닉스에서 작업을 한다면, 가장 보편적인 에디터로는
[Vim](http://www.vim.org/)과
[Emacs](http://www.gnu.org/software/emacs/)가 있습니다.
이 두 가지의 기반 철학은 서로간에 매우 다르고, 그 외 다른 에디터들과도 아주 다릅니다.

여러분이 이 두 가지 중 하나를 이미 익숙하게 쓰고 있다면, 그것을 계속 쓸 것을 권장합니다.

두 에디터 각각 Perl 프로그래밍을 더 편리하게 할 수 있게 지원하는 확장이나 모드가
존재하며, 그런 게 없이도 Perl로 개발할 때 매우 쓰기 좋은 에디터들입니다.

이 에디터들이 낯설다면, 저는 에디터를 익히는 것과 Perl을 학습하는 것을
구분하기를 권하고 싶습니다.

이 두 에디터는 매우 강력하지만, 숙달하는 데 긴 시간이 걸립니다.

지금은 Perl을 공부하는 것에 집중하고, 나중에 두 에디터 중 하나를 익히는 것이 나을 것입니다.

<b>Emacs</b>와 <b>Vim</b> 둘 다 유닉스/리눅스에서 처음 생겨났지만, 그 외 주요 운영체제에서도
사용할 수 있습니다.

## 윈도우용 Perl 에디터

윈도우의 경우, 많은 사람들이 소위 "프로그래머용 에디터"들을 사용합니다.

* [Ultra Edit](http://www.ultraedit.com/)는 상용 에디터입니다.
* [TextPad](http://www.textpad.com/)는 셰어웨어입니다.
* [Notepad++](http://notepad-plus-plus.org/)는 오픈소스 공개 소프트웨어입니다.

저는 <b>Notepad++</b>를 많은 시간 사용해왔고, 매우 유용한 에디터라서 제 윈도우 시스템에 늘
설치해 둡니다.

## Mac OSX

저는 맥이 없습니다만 인기투표에 따르면
[TextMate](http://macromates.com/)가 Perl 개발용 매킨토시 에디터 중에는
가장 많이 쓰입니다.

## Perl 통합 개발 환경(IDE)

앞서 말한 것들은 IDE가 아닙니다. 다시 말해서, 실제 Perl 디버거가 내장되어 있지 않습니다.
언어에 특화된 도움말을 제공하지도 않습니다.

ActiveState사의 [Komodo](http://www.activestate.com/)는 가격이 수백 달러입니다.
기능이 제한된 공개 버전도 있습니다.

[Eclipse](http://www.eclipse.org/) 사용자들은 EPIC이라 불리는 이클립스용
Perl 플러그인이 있다는 걸 알아두면 좋을 것입니다. 
[Perlipse](https://github.com/skorg/perlipse)라는 프로젝트도 있습니다.

## Padre, the Perl IDE

2008년 7월에 저는 <b>Perl로 만들어진 Perl 개발환경</b>을 작성하기 시작했습니다.
저는 이것을 Padre - Perl Application Development and Refactoring Environment 또는
[Padre, the Perl IDE](http://padre.perlide.org/)라고 이름지었습니다.

많은 분들이 이 프로젝트에 참여했습니다. Padre는 주요 리눅스 배포본을 통해 배포되며
CPAN을 통해서 설치할 수도 있습니다. 자세한 것은
[다운로드](http://padre.perlide.org/download.html) 페이지에서 확인하시기
바랍니다.

보는 각도에 따라 Eclipse나 Kodomo만큼 강력하지는 않지만, Perl에 특화된 다른 몇몇
부분에서는 이미 그 둘보다 더 좋아졌습니다.

게다가, Padre는 매우 활발히 개발되고 있습니다. 여러분이
<b>Perl 에디터</b> 또는 <b>Perl IDE</b>를 찾고 있다면, 한 번 사용해 보시기를 권합니다.

## Perl 에디터 투표

2009년 10월에 저는 
[Perl로 개발할 때 어떤 에디터나 편집기를 쓰고 있습니까?](http://perlide.org/poll200910/)라는
투표를 열었습니다.

이제 여러분은 대다수가 쓰는 걸 택할 수도 있고, 남들이 안 쓰는 걸 쓸 수도 있고, 여러분에게 적합한 것을
고를 수도 있습니다.

## 그 외

Alex Shatlovsky께서 [Sublime Text](http://www.sublimetext.com/)를 추천하였습니다. 이것은
플랫폼에 상관없이 사용할 수 있지만 유료입니다.

## 다음

튜토리알의 다음 내용은 [커맨드 라인에서 Perl 실행하기](https://perlmaven.com/perl-on-the-command-line)에 관한 짧은 도움말입니다.


