---
title: "פרל (Perl) על שורת הפקודה"
timestamp: 2013-06-06T14:45:56
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
translator: bruck
---


בעוד שרובו של  [מדריך הפרל](/perl-tutorial) עוסק בתכניות שנשמרות בקבצים, נראה גם מספר דוגמאות של תוכניות של שורה אחת.

גם אם אתה משתמש ב- [Padre](http://padre.perlide.org/)
או בIDE אחר שמאפשר לך להריץ את הקוד שלך מתוך סביבת העבודה עצמה, חשוב מאוד להכיר גם את שורת הפקודה (או המעטפת, shell) ולדעת להשתמש בפרל גם משם.


אם אתה משתמש בלינוקס, פתח חלון טרמינל אתה אמור לראות את סימן ה
prompt,שלרוב מסתיים בסימן $.

אם אתה משתמש ב-Windows אז לחץ על:

Start -> Run -> type in "cmd" -> ENTER

יופיע החלון השחור של CMD עם סימן prompt שנראה כך:

```
c:\>
```

## גירסת פרל

הקלד`perl -v`. פקודה זו מדפיסה משהו דומה לזה:

```
C:\> perl -v

This is perl 5, version 12, subversion 3 (v5.12.3)
  built for MSWin32-x86-multi-thread

Copyright 1987-2010, Larry Wall

Perl may be copied only under the terms of either the Artistic License or the
GNU General Public License, which may be found in the Perl 5 source kit.

Complete documentation for Perl, including FAQ lists, should be found on
this system using "man perl" or "perldoc perl".  אם אתה מחובר לאינטרנט הפנה את הדפדפן שלך אל http://www.perl.org/, אתר הבית של פרל .
```

לפי זה אני יכול לראות שעל מחשב ה-Windows שלי מותקנת גירסה 5.12.3 של פרל


## הדפסת מספר

הקלד את השורה:`perl -e "print 42"`.
על המסך יודפס המספר `42` . ב Windows  סימן ה-prompt יופיע בשורה הבאה

```
c:>perl -e "print 42"
42
c:>
```

בלינוקס תראה משהו דומה לזה:

```
gabor@pm:~$ perl -e "print 42"
42gabor@pm:~$
```

התוצאה מודפסת בתחילת השורה ומייד אחריה סימן ה-prompt.
הסיבה להבדל בין התוצאות הוא התנהגות שונה של מפרשי שורת הפקודה של שתי מערכות ההפעלה.

בדוגמה זו נשתמש באופציה `-e` שאומרת לפרל לא לצפות לקובץ. הדבר הבא על שורת הפקודה הוא קוד שכתוב בפרל.

הדוגמאות שהראיתי עד כה הן לא כל כך מעניינות. עכשיו נראה דוגמה יותר מעייניות ללא הסבר:

## החלפת ג'אווה בפרל

הפקודה: `perl -i.bak -p -e "s/\bJava\b/Perl/" resume.txt`
מחליפה את כל המופעים של המילה  <b>Java</b> במילה <b>Perl</b> 
בקובץ קורות החיים שלך,resume.txt, ושומרת גיבוי של הקובץ המקורי.

בלינוקס אפשר אפילו לכתוב: `perl -i.bak -p -e "s/\bJava\b/Perl/" *
 
כדי להחליף את המילה Java במילה  Perl בכל קבצי הטקסט שלך.

(ושוב שימו לב, בלינוקס/יוניקס לרוב יש לשתמש בגרשיים בודדים על שורת הפקודה וב-Windows יש להשתמש בגרשיים כפולים)


בהמשך, בחלק אחר, נדון יותר בתוכניות חד-שורתיות ונראה איך אפשר להשתמש בהן.
לעת עתה נאמר רק שתוכניות חד-שורתיות והידע כיצד להשתמש בהן הם כלי נשק רבי עוצמה.

אם אתה מעוניין להכיר תוכניות חד-שורתיות שימושיות מאוד, אני ממליץ לקרוא את 
[Perl One-Liners explained](http://www.catonmat.net/blog/perl-book/)
מאת פיטר קרומינש.

## מה הלאה?

החלק הבא הוא על 
[התיעוד של פרל, התיעוד שמגיע עם פרל ותיעוד המודולים](https://perlmaven.com/core-perl-documentation-cpan-module-documentation).


