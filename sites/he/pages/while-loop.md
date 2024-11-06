---
title: "לולאת while"
timestamp: 2013-10-13T08:00:00
tags:
  - while
  - while (1)
  - loop
  - infinite loop
  - last
published: true
original: while-loop
books:
  - beginner
author: szabgab
translator: bruck
---


בחלק זה של [המדריך לפרל](/perl-tutorial) נראה כיצד משתמשים <b>בלולאת ה-while בפרל</b>.


```perl
use strict;
use warnings;
use 5.010;

my $counter = 10;

while ($counter > 0) {
  say $counter;
  $counter -= 2;
}
say 'done';
```

לולאת ה `while`היא לולאה עם תנאי. במקרה זה התנאי בודק האם המשתנה  $counter גדול מ- 0,
ואחרי התנאי יש בלוק קוד שתחום בסוגריים מסולסלים.

כשההרצה מגיעה לתחילת לולאת ה-while, הערך הבוליאני של התנאי נבדק, כלומר אם הוא  <a href="/boolean-values-in-perl">true או
false</a>. אם הוא  `FALSE` אז מדלגים על הבלוק והשורה הבאה, במקרה זה הדפסת  'done', מבוצעת.

אם התנאי של  `while` הוא `TRUE`,אז הבלוק מבוצע ושוב חוזרים אל התנאי. התנאי נבדק שוב. אם הוא false מדלגים על הבלוק, ומודפסת המחרוזת 'done'
. אם התנאי הוא  true אז הבלוק מבוצע ושוב חוזרים אל התנאי ...

כל הסיפור הזה ממשיך כל זמן שהתנאי הוא או במשהו דומה לאנגלית:

`while (the-condition-is-true) { do-something }`

## לולאה אינסופית

בדוגמה שראינו תמיד הפחתנו את ערך המשתנה ולכן ידענו שמתישהו התנאי כבר לא יתקיים יותר, כלומר הוא יהיה false.
אם מסיבה כלשהי התנאי תמיד ממשיך להתקיים, אף פעם לא הופך ל-false אז מקבלים `לולאה אינסופית`. התוכנית שלכם תשאר תקועה בבלוק קטן ולא תוכל לברוח ממנו.

למשל, אם היינו שוכחים להפחית את ערכו של `$counter`, או אם היינו מגדילים את ערכו, אבל עדיין בודקים שהוא מגיע לסף תחתון.

אם זה קורה  אז בטעות אז זה באג.

מצד שני, קיימים מקרים שבהם שימוש <b>מכוון</b> בלולאה אינסופית עשוי לפשט גם את הקריאה וגם את הכתיבה של הקוד שלנו. אנחנו מאוד אוהבים קוד קריא!
אם אנחנו רוצים לולאה אינסופית אנחנו יכולים להשתמש בתנאי שתמיד מתקיים.

אנחנו יכולים לכתוב:

```perl
while (42) {
  # here we do something
}
```

כמובן שמי שאינו מכיר את
[האיזכור התרבותי המתאים](http://en.wikipedia.org/wiki/Answer_to_Life,_the_Universe,_and_Everything#Answer_to_the_Ultimate_Question_of_Life.2C_the_Universe.2C_and_Everything_.2842.29)

עשוי לתהות למה דווקא 42 ולכן תמיד משתמשים ב-1 בלולאות אינסופיות. 1 הוא מספר מקובל יותר, אפילו אם הוא יותר משעמם.

```perl
while (1) {
  # here we do something
}
```

מי שמסתכל על הלולאה ורואה שאין אפשרות לצאת ממנה עשוי לתהות איך התוכנית אי פעם תסיים את ההרצה שלה בלי שמישהו יפסיק אותה מבחוץ?

יש לנו מספר אפשרויות.

אחת האפשרויות היא לקרוא לפקודה  `last`   מתוך לולאת ה-while .
פקודה זו גורמת לדילוג על שאר הבלוק, והתנאי לא ייבדק שוב.
בפועל היא מסיימת את הלולאה. לרוב שמים אותה בתוך תנאי כלשהו.

```perl
use strict;
use warnings;
use 5.010;

while (1) {
  print "Which programming language are you learning now? ";
  my $name = <STDIN>;
  chomp $name;
  if ($name eq 'Perl') {
    last;
  }
  say 'Wrong! Try again!';
}
say 'done';
```

בדוגמה זו אנחנו שואלים את המשתמש שאלה ומקווים שהוא יצליח לענות עליה (כולל שימוש נכון באותיות רישיות וקטנות) אם הוא לא יקליד Perl הוא יהיה תקוע עם אותה שאלה לנצח.

השיחה עשויה להיראות כך:

```
Which programming language are you learning now?
>  Java
Wrong! Try again!
Which programming language are you learning now?
>  PHP
Wrong! Try again!
Which programming language are you learning now?
>  Perl
done
```

ניתן לראות שכשהמשתמש הקליד את התשובה הנכונה, הפקודה  `last` בוצעה, וההרצה דילגה על שאר הבלוק, כולל התגובה
 `say 'Wrong! Try again!';` והמשיכה אחרי 
` לולאת ה-while `.


