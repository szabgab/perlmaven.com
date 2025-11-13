

Also, the rename example could also show using regex for the substitution, since Perl's strength is regex.  However, Perl's rename(1p) utility by Larry
Wall himself might be more germane. It can use any Perl expression at all.  I've used it for (re-)numbering a very large number of static image files to names which can then be used by ffmpeg(1) to form a video for a time-lapsed video project.

When replacing a string in many files, I have usually had to use word boundary markers in the patterns to avoid false positives.  e.g.

 perl -i -p -e "s/\example.org\b/www.example.org/g" *.txt

Not too many of my own one-liners have survived in my notes, but here are two from Bash history:

$ echo "http://example.com/loc=Casa Beach" \
| perl -MURI::Escape -l0ne 'print uri_escape($_,"^A-Za-z0-9\-\._~/:=")'

The -l0 reminds me that there are a lot of use-cases for multi-line matching.  Other utilities such as sort have --zero-terminated or --null options.

$ openssl x509 -fingerprint -sha256 -in /etc/mosquitto/certs/server.crt | perl -F= -e 'if(m/sha256 Fingerprint/) {$F[1] =~ tr/://ds; print $F[1]; }'

And an old one from a set of shell scripts which were replaced completely with R-scripts.  The Perl example is too complex to be a good example but maybe inspires something simpler:

echo "select * from measurements \
        where epoch >= $(date -d "00:00:00" +"%s") order by
        epoch,probe;" \
| sqlite3 /home/me/temperatures.sqlite3 \
| perl -MPOSIX -F'\|' -e 'splice(@F,1,1,"\t"x$F[1]);
        $F[0]=strftime("%Y-%m-%d\t%H:%M:%S",localtime($F[0]));
        print @F;'

It moves data into particular tab-delimited columns based on which sensor number the data came from.


* https://catonmat.net/perl-one-liners-explained-part-one
* https://learnbyexample.github.io/learn_perl_oneliners/
* https://chris.improbable.org/2010/5/27/the-top-10-tricks-of-perl-one-liners/


