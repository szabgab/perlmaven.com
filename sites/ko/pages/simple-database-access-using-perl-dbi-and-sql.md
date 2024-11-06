---
title: "Perl DBI와 SQL을 사용한 간단한 데이타베이스"
timestamp: 2013-05-22T04:00:00
tags:
  - SQL
  - DBI
  - DBD::SQLite
  - SELECT
  - fetchrow_array
  - fetchrow_hashref
published: true
original: simple-database-access-using-perl-dbi-and-sql
author: szabgab
translator: gypark
---


대부분의 분야에서 Perl은
[한 가지 일을 하는 데에는 여러 가지 방법이 있다](http://en.wikipedia.org/wiki/There%27s_more_than_one_way_to_do_it)는
개념을 고수합니다만, 관계형 데이타베이스를 접근할 때에는
<b>데이타베이스에 독립적인 인터페이스(Database independent interface)</b>
또는 DBI라 불리는 라이브러리가 사실상의 표준으로 사용됩니다.


## 구조

Perl 스크립트는 DBI를 사용하고, DBI는 다시 적절한 <b>데이타베이스 드라이버</b>를 사용합니다.
(예를 들자면 [Oracle](http://www.oracle.com/)을 사용하기 위한
[DBD::Oracle](https://metacpan.org/pod/DBD::Oracle),
[PostgreSQL](http://www.postgresql.org/)을 사용하기 위한
[DBD::Pg](https://metacpan.org/pod/DBD::Pg),
[SQLite](http://sqlite.org/)을 사용하기 위한
[DBD::SQLite](https://metacpan.org/pod/DBD::SQLite) 등등)

이 드라이버들은 각각의 데이타베이스 엔진의 C 클라이언트 라이브러리와 같이 컴파일되어 있습니다.
물론 SQLite의 경우는 데이타베이스 엔진 전체가 Perl 응용프로그램내에 내장됩니다.

[DBI](https://metacpan.org/pod/DBI) 모듈 문서에 들어 있는 아스키 문자 그림이
너무도 잘 되어 있어서, 여기서는 그걸 그대로 보여드리겠습니다:

<pre>
             |<- DBI의 영역 ->|
                   .-.   .----------------.   .-------------.
  .--------.       | |---| XYZ 드라이버   |---| XYZ 엔진    |
  | DBI의  |       | |   `----------------'   `-------------'
  | API를  |  |A|  |D|   .----------------.   .-------------.
  | 사용한 |--|P|--|B|---|Oracle 드라이버 |---|Oracle 엔진  |
  |        |  |I|  |I|   `----------------'   `-------------'
  | Perl   |       | |...
  |스크립트|       | |... 다른 드라이버
  `--------'       | |...
                   `-'
</pre>

## 간단한 예제

SQLite를 사용한 예제를 보여드리겠습니다. SQLite를 택한 이유는 여러분의 컴퓨터에서
매우 쉽게 직접 해볼 수 있기 때문입니다.
(예를 들어 [DWIM Perl](http://dwimperl.com/)의 어떤 버전이든
필요한 모듈이 다 포함되어 있습니다.)

```perl
#!/usr/bin/perl
use strict;
use warnings;

use DBI;

my $dbfile = "sample.db";

my $dsn      = "dbi:SQLite:dbname=$dbfile";
my $user     = "";
my $password = "";
my $dbh = DBI->connect($dsn, $user, $password, {
   PrintError       => 0,
   RaiseError       => 1,
   AutoCommit       => 1,
   FetchHashKeyName => 'NAME_lc',
});

# ...

$dbh->disconnect;
```

DBI를 로드하지만, 명시적으로 데이타베이스 드라이버를 로드하지는 <b>않습니다</b>.
그것은 DBI가 할 일입니다.

($dsn 변수에 들어 있는) <b>DSN(데이타 소스 이름)</b>은 매우 직관적입니다.
데이타베이스의 종류가 명시되어 있어서, DBI가 어떤 데이타베이스 드라이버를 불러와야 할지
알려줍니다. SQLite의 경우, 그 외 필요한 건 데이타베이스 파일의 경로명 뿐입니다.

사용자이름과 비밀번호는 빈 채로 두었습니다. SQLite에는 별 관련 없어 보입니다.

connect를 호출할 때 마지막 인자는 제가 설정해두고픈 몇 가지 속성들이 담긴 해시의 레퍼런스입니다.

DBI->connect를 호출하면 <b>데이타베이스 핸들 객체</b>가 반환되고, 이 객체를 `$dbh`란 이름의
변수에 저장하는 게 보통입니다.

<b>disconnect</b>를 호출하는 것은 필수는 아닙니다. `$dbh` 변수가 영역을 벗어나 사라지게 될 때
자동으로 호출되기 때문입니다. 그러나 명시적으로 적어주면 이 코드를 다른 프로그래머가 볼 때
데이타베이스에 관련된 작업이 끝났다는 것을 명확히 알 수 있을 것입니다.

## 테이블 생성 - CREATE TABLE

물론 데이타베이스에 연결한 것만으로는 부족하고, 데이타베이스에 자료를 넣거나 조회할 수
있어야 할 것입니다. 하지만 그러기 위해서는 먼저 데이타베이스에 테이블을 생성해야 합니다.

이번 경우는 명령어 하나로 테이블을 생성할 수 있습니다:

```perl
my $sql = <<'END_SQL';
CREATE TABLE people (
  id       INTEGER PRIMARY KEY,
  fname    VARCHAR(100),
  lname    VARCHAR(100),
  email    VARCHAR(100) UNIQUE NOT NULL,
  password VARCHAR(20)
)
END_SQL

$dbh->do($sql);
```

첫번째 구문에서는 CREATE TABLE을 실행하는 SQL 구문을
[here document](https://perlmaven.com/here-documents)
를 사용하여 변수에 담았습니다.

그 다음 데이타베이스 핸들의 `do` 메쏘드를 호출하여 SQL 구문을 데이타베이스로 전송합니다.

## 삽입 - INSERT

이제 본격적으로, 자료를 삽입해 보겠습니다:

```perl
my $fname = 'Foo';
my $lname = 'Bar',
my $email = 'foo@bar.com';
$dbh->do('INSERT INTO people (fname, lname, email) VALUES (?, ?, ?)',
  undef,
  $fname, $lname, $email);
```

행 하나를 삽입하기 위하여 `$dbh->do` 메쏘드를 다시 호출하는데,
실제 자료를 넘기지 않고 대신 자료가 들어갈 곳을 지정하는
<b>위치 표시자(place-holders)</b>로 물음표 `?`를 사용했습니다.

SQL구문 다음 인자는 `undef`입니다. 원래 이 자리에는
`connect` 메쏘드를 호출할 때 속성을 지정하던 것처럼 이번 호출에만
적용될 파라메터들이 들어있는 해시 레퍼런스가 와야 합니다만, 제 생각엔 거의 사용되지
않을 것입니다.

`undef` 다음에는 아까 표시한 위치표시자 자리에 들어갈 실제 값들이 적혀 있습니다.

보다시피 위치표시자를 어떤 형태의 따옴표 안에 넣는다거나 어떤 식으로든 실제 값으로
변환할 필요가 없습니다. DBI가 우리 대신에 해줍니다.

이렇게 함으로써
[SQL 인젝션](http://en.wikipedia.org/wiki/Sql_injection) 공격을 피할 수 있습니다.
이젠 [Bobby Tables](http://bobby-tables.com/) 같은 사람을 만나도 안심입니다.

## 갱신 - UPDATE

어떤 자료를 갱신할 때도 `do` 메쏘드를 사용합니다.

```perl
my $password = 'hush hush';
my $id = 1;

$dbh->do('UPDATE people SET password = ? WHERE id = ?',
  undef,
  $password,
  $id);
```

특별할 것 없습니다. 위치표시자가 포함된 SQL 구문이 있고, 추가 속성이 들어갈 자리에
`undef`이 오고, 위치표시자 자리에 적힐 값들이 나옵니다.

## 조회 - SELECT

데이타베이스를 사용할 때 가장 재미있는 부분입니다.
SELECT 구문이 반환하는 것이, 여러 값들로 구성된 다수의 행들일 수도 있기 때문에, 단순히
`do` 메쏘드를 한 번 호출하여 가져올 수는 없습니다.

대신에, 자료를 가져오는 여러 방법이 있는데, 여기서는 그 중 두 가지를 보여드리겠습니다.
두 방법 다 세 단계로 이루어집니다: `prepare`로 SQL 구문을 준비시키고, `execute`로
그 구문에 특정한 데이타를 넣어 실행하고, `fetch`로 행들을 가져옵니다.

여기서 `prepare` 구문은 여러 쿼리에서 공유할 수 있습니다 - 이 쿼리들이 다른 부분은 동일하고
인자 데이타만 달라지는 경우라면요. SQL 구문을 만들 때 물음표(`?`)를 위치표시자로
사용하여 실제 데이타가 들어갈 자리에 넣었습니다.

prepare를 호출하면 <b>구문 핸들 객체</b>가 반환됩니다. 이 객체는 통상적으로
`$sth` 변수에 보관합니다.

그 다음은 이 <b>구문 핸들</b>이 제공하는 `execute` 메쏘드를 호출하는데, 이 때
위치표시자 자리에 들어갈 실제 인자 값들을 적어줍니다.

세번째 단계가 정말 흥미로운 단계입니다.
<b>while 루프</b> 안에서 조회 결과를 한 행씩 가져옵니다. 이 때 여러 가지 메쏘드를 사용할 수 있습니다:

`fetchrow_array` 메쏘드는 조회된 결과의 다음 행의 내용을 리스트 형태로 반환합니다.
그 리스트는 배열에 담을 수 있습니다. 리스트의 원소의 순서는 쿼리에 적힌 필드의 순서와 동일합니다.
(이 경우에는 fname, lname 순서)

`fetchrow_hashref` 메쏘드는 해시의 레퍼런스를 반환합니다. 이 해시에는 데이타베이스의
필드 이름들이 키로 저장됩니다. 데이타베이스마다 이런 필드 이름들을 대문자 형태로 반환할지 소문자 형태로
반환할지 다를 수 있기 때문에, 이번 예제에서는 필드 이름들이 항상 소문자로 변환되도록 데이타베이스
핸들러를 설정하였습니다.
(이게 바로 데이타베이스에 연결할 때 `FetchHashKeyName` 매개변수가 했던 일입니다.)

```perl
my $sql = 'SELECT fname, lname FROM people WHERE id > ? AND id < ?';
my $sth = $dbh->prepare($sql);
$sth->execute(1, 10);
while (my @row = $sth->fetchrow_array) {
   print "fname: $row[0]  lname: $row[1]\n";
}

$sth->execute(12, 17);
while (my $row = $sth->fetchrow_hashref) {
   print "fname: $row->{fname}  lname: $row->{lname}\n";
}
```


## 실습

위의 코드들을 사용해 보세요. 첫번째 코드를 써서 데이타베이스를 준비하고 테이블을 생성해보세요.
그 다음 두번째 코드를 사용하여 테이블에 몇 명의 자료를 넣어보세요.

끝으로 마지막 예제 코드를 사용하여 데이타베이스에서 자료를 빼내어 출력해봅시다.

궁금한 게 있다면 아래에 자유롭게 질문하시기 바랍니다.

## 감사의 말

예제 코드의 버그를 잡아 준 sigzero에게 감사합니다.

