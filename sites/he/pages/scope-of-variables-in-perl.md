---
title: "טווח (Scope) של משתנים בפרל"
timestamp: 2013-07-23T22:00:00
tags:
  - my
  - scope
published: true
original: scope-of-variables-in-perl
books:
  - beginner
author: szabgab
translator: bruck
---


בפרל ישנם שני סוגי משתנים עיקריים. סוג אחד הוא משתנה שהוא גלובלי בחבילה (package) ומוכרז באחת הצורות הבאות:
`use vars` שהוא מיושן וכבר לא משתמשים בו, או באמצעות `our`.

הסוג השני הוא משתנה לקסיקלי שמוכרז באמצעות  `my`.

נראה מה קורה כשמכריזים על משתנה באמצעות  `my`? באילו חלקים של הקוד ניתן לראות את המשתנה?
במילים אחרות, מה  <b>טווח (scope)</b> של המשתנה)?


## טווח של משתנים: בלוק סוגר

```perl
#!/usr/bin/perl
use strict;
use warnings;

{
    my $email = 'foo@bar.com';
    print "$email\n";     # foo@bar.com
}
# print $email;
# $email does not exists
# Global symbol "$email" requires explicit package name at ...
```

בתוך הבלוק האנונימי (הסוגריים המסולסלים `{}`), קודם כל אנחנו רואים הכרזה על משתנה חדש בשם
`$email`. המשתנה קיים בין הנקודה שבה הוא הוכרז ועד סוף הבלוק. לכן היה צריך לשים בהערה את השורה שאחרי סגירת הסוגריים המסולסלים
 `}` . אם מסירים את הסימן  `#` מהשורה
`# print $email;` , ומנסים להריץ את הקוד, אז מקבלים את שגיאת הקומפילציה הבאה:
[Global symbol "$email" requires explicit package name at ...](/global-symbol-requires-explicit-package-name).

במילים אחרות,  <b>הטווח של כל משתנה שמוכרז עם my הוא הבלוק שבו הוא נמצא אותו.</b>.

## טווח של משתנה: נגיש בכל מקום

המשתנה`$lname` מוכרז בתחילת הקוד. הוא יהיה נגיש עד סוף הקובץ בכל מקום. אפילו בתוך בלוקים. אפילו אם הבלוקים הם הגדרות של פונקציות.
אם נשנה את המשתנה בתוך הבלוק, אז ערכו ישתנה מאותו מקום ואילך.
אפילו כשעוזבים את הבלוק.

```perl
#!/usr/bin/perl
use strict;
use warnings;

my $lname = "Bar";
print "$lname\n";        # Bar

{
    print "$lname\n";    # Bar
    $lname = "Other";
    print "$lname\n";    # Other
}
print "$lname\n";        # Other
```


## משתנים שמוסתרים על ידי הכרזות על משתנים אחרים

```perl
#!/usr/bin/perl
use strict;
use warnings;

my $fname = "Foo";
print "$fname\n";        # Foo

{
    print "$fname\n";    # Foo

    my $fname  = "Other";
    print "$fname\n";    # Other
}
print "$fname\n";        # Foo
```

במקרה זה מכריזים על המשתנה  `$fname` בתחילת הקוד. כפי שנכתב קודם,הוא יהיה נגיש עד סוף הקובץ, בכל מקום, <b>פרט למקומות שבהם הוא מוסתר על ידי משתנה עם אותו שם שהוגדר מקומיח.</b>.

בתוך הבלוק השתמשנו ב- `my` כדי להכריז על משתנה אחר עם אותו שם. הכרזה זו מסתירה את המשתנה `$fname`
שהוכרז מחוץ לבלוק עד שעוזבים את הבלוק. בסוף הבלוק (בסגירת הסוגריים המסולסלים `}`), המשתנה `$fname`
שהוגדר בתוך הבלוק מושמד והמשתנה המקורי `$fname` שוב יהיה נגיש.
זוהי תכונה חשובה במיוחד כיוון שהיא מאפשרת לנו ליצור משתנים בטווחים קטנים בלי שנצטרך לחשוב על שימושים אפשריים של שמותיהם מחוץ לאותם טווחים.

## חזרה על אותו שם בבלוקים שונים

אתם חופשיים להשתמש באותו שם משתנה במספר בלוקים שונים. למשתנים האילו אין שום קשר זה לזה.

```perl
#!/usr/bin/perl
use strict;
use warnings;

{
    my $name  = "Foo";
    print "$name\n";    # Foo
}
{
    my $name  = "Other";
    print "$name\n";    # Other
}
```

## הכרזות על חבילה (package) בתוך קובץ


הדוגמה הבאה היא קצת יותר מתקדמת, אבל נראה לי שחשוב להזכיר אותה כאן.

פרל מאפשרת לנו להחליף בין  <b>מרחבי שמות (name-spaces)</b> באצעות מילת המפתח `package`  בתוך קובץ. הכרזה על חבילה  <b>לא</b> מייצרת טווח. אם תכריזו על משתנה בחבילה <b>main </b> שהיא פשוט הקוד שלך, אז המשתנה  `$fname` יהיה נגיש גם במרחבי שמות אחרים באותו קובץ.


אם תכריזו על משתנה בשם  `$lname` במרחב השמות Other
הוא יהיה נגיש כשתחזרו מאוחר יותר למרחב השמות `main` . אם ההכרזה על החבילה `package Other` הייתה בקובץ אחר
אז למשתנים יהיו טווחים שונים כאשר הטווח של כל משתנה נוצר על ידי הקובץ שבו הוא נמצא.

```perl
#!/usr/bin/perl
use strict;
use warnings;

my $fname  = "Foo";
print "$fname\n";    # Foo

package Other;
use strict;
use warnings;

print "$fname\n";    # Foo
my $lname = 'Bar';
print "$lname\n";    # Bar


package main;

print "$fname\n";    # Foo
print "$lname\n";    # Bar
```


