$(document).ready(function() {
    var show_top = function(msg) {
        $('#top-poster').html(msg);
        $('#top-poster').css('font-size', '30px');
        $('#top-poster').css('background-color', '#42e8f4');
        $('#top-poster').show();
    };
    var show_bottom = function(msg) {
        $('#after-content').html(msg);
        $('#after-content').css('font-size', '30px');
        $('#after-content').css('background-color', 'orange');
        $('#after-content').show();
    };

    // $('#after-abstract').html(msg);

    var path = window.location.pathname;

    var re_pro = new RegExp('^/pro/');
    if (re_pro.exec(path)) {
        return;
    }

    var re = new RegExp('^/archive/?');
    if (re.exec(path)) {
        return;
    }


    // 'Are you here for a quick solution or would you really like to know Perl? If the former, go ahed find the content you need!<p>If you would like to know more, let me suggest you pick up one of the eBooks I wrote: The <a href="https://leanpub.com/perl-maven/c/pmtop-2018-04">Perl Maven eBook</a>, the <a href="https://leanpub.com/markua-parser-in-perl5">TDD case study in Perl</a>, and the <a href="https://leanpub.com/dancer-spa/">Dancer SPA</a>.'
    var msg = 'Are you serious about Perl? Check out my <a href="https://leanpub.com/perl-maven">Beginner Perl Maven book</a>.<br>I have written it for you!'

    msg = 'Was this article useful? Support me via <a href="https://www.patreon.com/szabgab">Patreon</a>!';
})
