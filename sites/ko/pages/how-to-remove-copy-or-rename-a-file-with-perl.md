---
title: "펄에서 파일 이동/복사/이름변경 방법"
timestamp: 2013-11-21T00:45:00
tags:
  - unlink
  - remove
  - rm
  - del
  - delete
  - copy
  - cp
  - rename
  - move
  - mv
  - File::Copy
published: true
original: how-to-remove-copy-or-rename-a-file-with-perl
books:
  - beginner
author: szabgab
translator: johnkang
---


<b>시스템 관리자</b> 그리고 Unix 또는 Linux 스크립팅을 하는 많은 사람들은
이러한 명령을 위해 unix의 <b>rm</b>, <b>cp</b> 그리고 <b>mv</b> 명령어를
계속 사용 할 것 입니다.
펄 스크립트내에서도 빽틱 또는 <b>system</b>함수를 통해 이 명령어들을 호출 할 수 있습니다. 

이러한 방법은 통용되는 플랫폼에서는 동작합니다만
펄이 유닉스 시스템 관리에서 가질 수 있는 주요 이점들을 포기해야 합니다.

플랫폼 독립적인 환경에서 펄로 이러한 명령을 어떻게 간단히 수행 할 수 있는지 살펴 보겠습니다.


## remove

펄에서의 파일을 삭제 하는 내장 함수 이름은 `unlink` 입니다.

이 함수는 파일 시스템으로 부터 한개 혹은 그 이상의 파일들을 삭제 합니다.
유닉스의 `rm` 윈도우의 `del` 명령어와 유사 합니다.

```perl
unlink $file;
unlink @files;
```

이 함수는 파라미터가 주어지지 않는다면 $_, [the default variable of Perl](/the-default-variable-of-perl)을 사용합니다.

더 상세한 내용은 [perldoc -f unlink](http://perldoc.perl.org/functions/unlink.html) 를 통해 확인 하실수 있습니다.

## rename

파일의 이름변경/이동을 하며 유닉스의 `mv` 도스/윈도우의 `rename` 명령어와 유사 합니다.

```perl
rename $old_name, $new_name;
```

이 함수는 다른 모든 파일시스템에서 항상 동작 하는것이 아니기 때문에 다른 대안으로
`File::Copy` 모듈의 `move` 함수를 사용하는 것을 권장 합니다.

```perl
use File::Copy qw(move);

move $old_name, $new_name;
```

Documentation:

[perldoc -f rename](http://perldoc.perl.org/functions/rename.html).

[perldoc File::Copy](http://perldoc.perl.org/File/Copy.html).

## copy

펄에서 기본적으로 copy 함수를 제공하지 않습니다. 파일을 복사 하는 일반적인 방법으로는
File::Copy 모듈의 `copy` 함수를 사용할 수 있습니다.

```perl
use File::Copy qw(copy);

copy $old_file, $new_file;
```

이것은 유닉스의 `cp` 윈도우의 `copy` 명령어와 유사 합니다.

[perldoc File::Copy](http://perldoc.perl.org/File/Copy.html) 를 통해 더 자세한 문서를 확인 하실 수 있습니다.


