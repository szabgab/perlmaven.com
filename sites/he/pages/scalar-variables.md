---
title: "משתנים סקלריים"
timestamp: 2013-07-21T12:00:00
tags:
  - strict
  - my
  - undef
  - say
  - +
  - x
  - .
  - sigil
  - $
  - "@"
  - "%"
  - FATAL warnings
published: true
original: scalar-variables
books:
  - beginner
author: szabgab
translator: bruck
---


בחלק זה של  [המדריך לפרל](/perl-tutorial), נסתכל על מבני הנתונים הקיימים בפרל ועל השימוש בהם.

בפרל 5 יש שלושה מבני נתונים. <b>סקלרים, מערכים והאש (Hash)</b>. האש ידועים גם כמערכים אסוציאטיביים, או מילונים בשפות אחרות


משתנים בפרל תמיד נכתבים עם סימן מזהה בתחילתם המכונה  <b>סיג'יל (sigil)</b>. הסימנים הם <עבור משתנים סקלרים ,
`@` עבור מערכים ו- `%` עבור האש.

סקלר יכול להכיל ערך בודד כגון מספר או מחרוזת כמו כן הוא יכול להכיל הפנייה למבנה נתונים אחר - נראה זאת בהמשך.

שם של משתנה סקלרי תמיד מתחיל עם  `$` (סימן דולר) ואחריו אותיות, מספרים וקווים תחתיים.
שם משתנה יכול להיות `$name` או `$long_and_descriptive_name`. הוא יכול להיות גם
`$LongAndDescriptiveName` זו צורה שמכונה לרוב "CamelCase",
אך קהילת הפרל מעדיפה לרוב שמות משתנים כתובים באותיות קטנות כאשר קווים תחתיים מפרידים בין המילים בשם המשתנה.

כיון שאנחנו תמיד משתמשים ב- <b>strict</b>, ראשית עלינו להכריז על המשתנים באמצעות  <b>my</b>.
(בהמשך תלמדו גם על  <b>our</b> ועל אפשרויות נוספות, אך לעת עתה נשאר עם ההכרזה באמצעות <b>my</b> .)
ניתן גם מייד עם ההכרזה להציב ערך כמו בדוגמה הבאה:

```perl
use strict;
use warnings;
use 5.010;

my $name = "Foo";
say $name;
```

אפשר גם להכריז על המשתנה ולהציב בו ערך מאוחר יותר:

```perl
use strict;
use warnings;
use 5.010;

my $name;

$name = "Foo";
say $name;
```

אנחנו מעדיפים את הצורה הראשונה אם הלוגיקה של הקוד מאפשרת זאת.

אם הכרזנו על משתמש אך טרם הצבנו בו ערך אז יהיה לו ערך שנקרא [undef](https://perlmaven.com/undef-and-defined-in-perl) ערך זה דומה ל- <b>NULL</b> in databases,
אבל יש לו התנהגות קצת שונה.

ניתן לבדוק אם משתנה הוא `undef` באמצעות הפונקציה `defined` :

```perl
use strict;
use warnings;
use 5.010;

my $name;

if (defined $name) {
  say 'defined';
} else {
  say 'NOT defined';
}

$name = "Foo";

if (defined $name) {
  say 'defined';
} else {
  say 'NOT defined';
}

say $name;
```

ניתן להפוך משתנה סקלרי ל- `undef` על ידי הצבת  `undef` במשתנה:

```perl
$name = undef;
```

המשתנים הסקלרים יכולים להכיל או מספרים או מחרוזות. לכן אפשר לכתוב:

```perl
use strict;
use warnings;
use 5.010;

my $x = "hi";
say $x;

$x = 42;
say $x;
```

וזה פשוט עובד.

איך זה עובד יחד עם אופרטורים והעמסת אופרטורים בפרל?

כללית פרל עובדת הפוך מרוב השפות האחרות במקום שהאופרנדים, הערכים, יגידו לאופרטורים, לפעולות, כיצד להתנהג, האופרטורים אומרים לאופרנדים כיצד להתנהג.

כך ש אם יש לי שני משתנים שמכילים מספרים  אז האופרטור מחליט אם הם באמת צריכים להתנהג כמו מספרים או כמו מחרוזות.

```perl
use strict;
use warnings;
use 5.010;

my $z = 2;
say $z;             # 2
my $y = 4;
say $y;             # 4

say $z + $y;        # 6
say $z . $y;        # 24
say $z x $y;        # 2222
```

`+`,הוא אופרטור חיבור המספרים, מחבר שני מספרים, לכן  `$y` ו- `$z` מתנהגים כמו מספרים.

`.`, משרשר שתי מחרוזות לכן `$y` ו- `$z` מתנהגים כמו מחרוזות. (בשפות אחרות ייתכון שתקראו לפעולה זו חיבור מחרוזות.)

`x`, אופרטור החזרה, חוזר על המחרוזת בצד השמאלי מספר פעמים שווה למספר בצד הימני,
לכן במקרה זה `$z` מתנהג כמחרוזת ואילו `$y` מתנהג כמספר.

התוצאות היו זהות אם שניהם היו נוצרים כמחרוזות:

```perl
use strict;
use warnings;
use 5.010;

my $z = "2";
say $z;             # 2
my $y = "4";
say $y;             # 4

say $z + $y;        # 6
say $z . $y;        # 24
say $z x $y;        # 2222
```

ואפילו אם אחד מהם היה נוצר כמספר והשני כמחרוזת:

```perl
use strict;
use warnings;
use 5.010;

my $z = 7;
say $z;             # 7
my $y = "4";
say $y;             # 4

say $z + $y;        # 11
say $z . $y;        # 74
say $z x $y;        # 7777
```

פרל ממירה אוטומטית מספרים למחרוזות ומחרוזות למספרים על פי דרישות האופרטור.

מכנים אותם  <b>הקשרים (contexts)</b>  הקשר מספרי (נומרי) והקשר מחרוזת.

המקרים הקודמים היו קלים כשממירים מספר למחרוזת זה כמו לשים גרשיים מסביב למספר כשממירים מחרוזת למספר, יש מקרים פשוטים, כמו המקרים שראינו, שבהם המחרוזת מורכבת אך ורק ממספרים אותו דבר היה קורה אם הייתה נקודה עשרונית במחרוזת, למשל `"3.14"`.
השאלה היא, מה קורה אם המחרוזת מכילה תווים שאינם חלק משום מספר למשל `"3.14 הוא פאי"`.
איך תתנהג המחרוזת עם אופרטור נומרי (כלומר, בהקשר נומרי)? 

גם מקרה זה פשוט, אך הוא דורש הסבר

```perl
use strict;
use warnings;
use 5.010;

my $z = 2;
say $z;             # 2
my $y = "3.14 is pi";
say $y;             # 3.14 is pi

say $z + $y;        # 5.14
say $z . $y;        # 23.14 is pi
say $z x $y;        # 222
```

כשמחרוזת נמצאת בהקשר נומרי, פרל מסתכלת בצד השמאלי של המחרוזת ומנסה להמיר אותו למספרים. כל זמן שהגיוני לבצע את ההמרה, חלק זה הופך לחלק הנומרי של המשתנה. בהקשר נומרי (`+`) המחרוזת
`"3.14 הוא פאי"` נחשבת למספר `3.14`.

מבחינה מסוימת זו החלטה שרירותית לגמרי, אבל כך זה עובד, אז עם זה אנחנו מסתדרים.

הקוד הנ"ל גם ייצור התרעה בערוץ השגיאה הסטנדרטי (`STDERR`):

```
Argument "3.14 is pi" isn't numeric in addition(+) at example.pl line 10.
```

בהנחה שהשתמשתם ב- <b>use warnings</b> כפי שמאוד מומלץ לעשות.
השימוש בהתרעות יעזור לכם לשים לב כשמשהו מתנהג לא בדיוק כפי שציפיתם.
אני מקווה שהתוצאה של  `$x + $y` נראית עכשיו ברורה יותר.

## רקע

שימו לב גם שפרל לא שינתה את הערך של `$y` ל- 3.14. היא רק השתמשה בערך הנומרי בפעולת החיבור.
זה וודאי מסביר גם את התוצאה של `$z . $y`l.
במקרה זה פרל משתמשת בערך המקורי של המחרוזת.

ייתכן שתשאלו למה `$z x $y` מראה 222 בעוד שהיה לנו 3.14 מצד ימין,
נראה שפרל יודעת לחזור על מחרוזות רק מספר פעמים שלם... Iפרל מעגלת את המספר מצד ימין בלי לתת התרעה על כך. (אם אתם באמת רוצים לחשוב על זה לעומק, אז תיראו שההקשר "המספר" שהוזכר קודם הוא למעשה הקשר עם מספר תת-הקשרים, אחד מהם הוא "מספר שלם". לרוב פרל עושה מה "שנראה נכון" לרוב האנשים שאינם מתכנתים.)

בנוסף לכך, אנחנו אפילו לא רואים התרעה על המרה של חלק ממחרוזת למספר "partial string to number" כפי שראינו במקרה של`+`.

 הסיבה היא לא האופרטור השונה. אם נשים את השורה עם פעולתהחיבור בהערה אז נראה את ההתרעה על הפעולה הסיבה להעדרה של הפעולה השנייה היא שכשפרל ייצרה את הערך המספרי של המחרוזת `"3.14 is pi"` it
היא גם שמרה אותו בכיס מוסתר של המשתנה `$y` . כך שבעצם `$y`
מחזיק עכשיו גם את ערך המחרוזת וגם את הערך המספרי, והערך הנכון ישמש בכל פעולה חדשה ועל ידי יימנע הצורך מהמרה נוספת.

ברצוני לציין שלושה דברים נוספים. אחד הוא ההתנהגות של משתנה עם הערך
`undef` , השני הוא  <b>התרעות פטליות - (fatal warnings)</b> והשלישי הוא המנעות מהמרה "אוטומטית" ממחרוזת למספר.

## undef

אם ערכו של משתנה הוא  `undef` משהו שאליו רוב האנשים ייתחסו כאל "כלום" , עדיין אפשר להשתמש בו.
בהקשר נומרי הוא יתנהג כמו 0 בהקשר מחרוזת הוא ייתנהג כמו המחרוזת הריקה:

```perl
use strict;
use warnings;
use 5.010;

my $z = 3;
say $z;        # 3
my $y;

say $z + $y;   # 3
say $z . $y;   # 3

if (defined $y) {
  say "defined";
} else {
  say "NOT";          # NOT
}
```

עם שתי התרעות:

```
Use of uninitialized value $y in addition (+) at example.pl line 9.

Use of uninitialized value $y in concatenation (.) or string at example.pl line 10.
```

כפי שניתן לרואים ערכן של המשתנה בסוף הוא עדיין`undef` ולכן התוצאה של משפט התנאי תהיה הדפסת "NOT".


## התרעות פטליות - Fatal warnings

הנושא השני הוא שיש אנשים שמעדיפים שהתוכנית תזרוק חריגה (exception) קשה במקום התרעה הרכה. אם זו ההעדפה שלכם, אתם יכולים לשנות את תחילת הקוד ולכתוב

```perl
use warnings FATAL => "all";
```

כששורה זו נמצאת בקוד, התוכנית תדפיס את המספר 3, ואז תזרוק חריגה

```
Use of uninitialized value $y in addition (+) at example.pl line 9.
```

זו אותה הודעה שהתקבלה קודם כהתרעה, אבל במקרה זה התוכנית מפסיקה לרוץ.
(אלא אם תופסים את החריגה, אבל זה נושא לדיון נפרד)

## המנעות מהמרה אוטומטית של מחרוזות למספרים

אם תירצו להמנע מהמרה אוטומטית של מחרוזות כשאין המרה מדוייקת, תוכלו לבדוק אם המחרוזת נראית כמו מספר כשאתם מקבלים אותה מהעולם החיצון.

כדי לעשות זאת נשתמש במודול [Scalar::Util](https://metacpan.org/pod/Scalar::Util),
ונשתמש בפונקציה שלה `looks_like_number` .

```perl
use strict;
use warnings FATAL => "all";
use 5.010;

use Scalar::Util qw(looks_like_number);

my $z = 3;
say $z;
my $y = "3.14";

if (looks_like_number($z) and looks_like_number($y)) {
  say $z + $y;
}

say $z . $y;

if (defined $y) {
  say "defined";
} else {
  say "NOT";
}
```


## העמסת אופרטורים (operator overloading)

בנוסף לכל האמור, תמיד תוכלו ליישם העמסת אופרטורים ובמקה זה הערכים (אופרנדים) יכתיבו לאופרטורים מה לעשות. נשאיר את זה לדיון סיום מתקדם יותר.


