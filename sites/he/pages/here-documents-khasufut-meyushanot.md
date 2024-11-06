---
title: "מחרוזות here-document חשופות הן מיושנות ועומדות לצאת משימוש - איך למצוא קוד בעייתי?"
timestamp: 2013-07-14T23:01:01
tags:
  - <<
  - Perl::Critic
  - perlcritic
published: true
original: bare-here-documents-are-deprecated
author: szabgab
translator: bruck
---


## עידכון

מסתבר שלא הבנתי נכון את השינוי ב perl 5.20, אי לכך מאמר זה עודכן בהתאם.

אני רוצה להודות שוב ל [ ג'ון ג'נסן Jon Jensen](https://twitter.com/jonjensen0) שהפנה אותי
[להערה](https://rt.perl.org/rt3/Public/Bug/Display.html?id=118511#txn-1228753)
שמבהירה את הנושא. ותודה לג'ואל ברגר שהסביר זאת בהערה שלו.


יש אפשרות לכתוב מחרוזות here-document עם סימן סיום ריק:

```perl
my $str = <<"";
text

print $str
```

אם מריצים את הקוד מקבלים:

```
text
```

אני חושב שלא ראיתי משהו כזה קודם, ונראה לי שזה לא מוצא חן בעיני. נראה לי שהמצב העדיף הוא שברור מתי משהו מסתיים, לא נראה לי השימוש ברווחים  כחלק משמעותי מהקוד.

בכל מקרה, יש, או יותר נכון הייתה, גירסה עוד יותר מוזרה, שבה אפילו לא כותבים את הגרשיים בסיום הלא-קיים של תחילת מחרוזת ה-here-document:

```perl
my $str = <<;
text

print $str
```

זה המקרה שהוכרז כמיושן (deprecated) ויוצא משימוש בפרל 5.20.

אם מריצים את הקוד מקבלים:

```
Use of bare << to mean <<"" is deprecated at program.pl line 2.
text
```

כך שאפילו בלי `use warnings` הקוד גורם להתרעה.

עכשיו אני מבין יותר טוב למה קבוצת המפתחים של פרל, Perl Porters, חושבים שזה מקרה נדיר, כיוון שאנשים יקבלו התרעה כל פעם שהם משתמשים בקוד כזה.

אז זו אזעקת שווא

אני מתנצל אם המאמר הקפיץ אתכם בגלל השינויים

<hr>


בכל אופן, אני משאיר כאן את הטקסט המקור: ייתכן כי עדיין תירצו לאתר את המקרים האחרים, אפילו אם אין כוונה להסיר אותם מפרל, ייתכן שתירצו לכתוב מחרוזות here-documents
ברורת יותר כדי שהאינטרפולציה תהיה ברורה יותר לקורא.

## המאמר המקורי

כשתיארתי את מחרוזות [here documents](/here-documents) בפרל
ציינתי שייתכן שתיראו מקרים שבהם סימן הסיום אינו כתוב בין גרשיים בהכרזה על המחרוזת.

[מסתבר](http://byte-me.org/perl-5-porters-weekly-july-1-7-2013/) שאפשרות זו הוכרזה כמיושנת והיא תוסר מפרל גירסה 5.20.

ייתכן שאתם עוד רחוקים משידרוג לגרסה זו של פרל, ואתם אפילו לא יודעים אם יש לכם בכלל קוד שנראה ככה.
אולי אתם חושבים "אני בכלל לא אהיה פה כשזה יקרה".

או שאתם יכולים לעשות את הפעולות הבאות כדי לאתר כל מקום שבו יש לכם מחרוזת here-document כדי לאתר את האפשרות המיושנת ולתקן אותה בהתאם.

כך תוכלו לוודא שהבעיה לא תשבור את הקוד כשיגיע השדרוג, ואם אתם לא שם, אז לא יבואו לחפש אתכם!


## Perl::Critic מציל אותנו!

לכלי [Perl::Critic](http://www.perlcritic.com/) יש מדיניות שנקראת
[ValuesAndExpressions::RequireQuotedHeredocTerminator](https://metacpan.org/pod/Perl::Critic::Policy::ValuesAndExpressions::RequireQuotedHeredocTerminator)
שבודקת את המצב המתואר.

כפי שהוסבר [במאמר על שיפור הקוד](https://perlmaven.com/perl-critic-one-policy),
אפשר להשתמש בפקודה `perlcritic` עך מנת לאתר הפרות של מדיניות מסוימת.

נניח שיש לנו קובץ בשם programming.pl הכולל את הקוד הבא:

```perl
my $what = 'quote';

print <<"END2";
double $what
END2

print <<'END1';
single $what
END1

print <<END0;
no $what
END0
```

אם מריצים את הקוד באמצעות הפקודה<b>perl programming.pl</b> התוצאה תיראה כך:

```
double quote
single $what
no quote
```

אני מניח שזה הפלט הצפוי.

אם מריצים את פקודת perlcritic :

`perlcritic --single-policy  ValuesAndExpressions::RequireQuotedHeredocTerminator programming.pl`

נקבל את הדוח:

```
Heredoc terminator must be quoted at line 11, column 7.  See page 64 of PBP.  (Severity: 3)
```

וזה הכל. הקוד שכתוב לא על פי המדיניות, ויפסיק לעבוד בפרל 5.20, אותר.

תקנו את הקוד על ידי הוספת גרשיים כפולים סביב השם: `print <<"END0";` והריצו אותו שוב 
כדי לוודא שהפלט לא השתנה.

אפשר גם להריץ שוב את  perlcritic ולראות את הדוח המדווח על בדיקה מוצלחת:

```
$ perlcritic --single-policy  ValuesAndExpressions::RequireQuotedHeredocTerminator p.pl
p.pl source OK
```

עכשיו תעשו את זה עם כל הקבצים שלכם.

##   טיקט ב-RT- RT Ticket

לא חשבתי אפילו לחפש את זה אבל תודות ל-
[ג'ון ג'נסן, Jon Jensen](https://twitter.com/jonjensen0) הנה הקישור
 [לטיקט ב-RT](https://rt.perl.org/rt3//Public/Bug/Display.html?id=118511) שעוסק בשינוי זה בפרל.


