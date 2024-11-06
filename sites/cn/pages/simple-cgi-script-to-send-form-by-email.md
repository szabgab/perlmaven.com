---
title: "简单的Perl CGI脚本通过电子邮件发送表单"
timestamp: 2013-05-23T12:45:56
tags:
  - CGI
published: true
original: simple-cgi-script-to-send-form-by-email
author: szabgab
translator: herolee
---


尽管有很多其他更好的办法去解决这个问题，不幸的是我仍然看到很多人不能使用现代的方法只能挣扎着使用旧的Perl代码。

很多情况下，他们连CPAN上的模块都不能使用。

最近有人给我发了一份恐怖的CGI代码，问我他怎样才能捕获HTML表单的域并用Perl发送一封邮件信息。

这里我并不想重构那段代码。我只是演示一个简单的例子，如何处理网页表单并通过电子邮件发送表单的值。


## 使用CGI处理HTML表单

这是一个很简单的包含一个表单的HTML页面。表单有3个域。文本框域<b>fullname</b>，选项域<b>country</b>和一个文本区域<b>question</b>。

这一块假定你已经了解了。

不同之处在于<b>form</b>本身的参数。
`action`是指向CGI脚本的URL。`method`可以是<b>GET</b>或者<b>POST</b>。
区别在于使用GET的情况下，值会显示在浏览器的地址栏里，而使用POST时，他们会被隐藏。

本例中我们使用POST。

```html
<html>
<head><title>Submit form</title>
</head>
<body>

<form action="/cgi/sendmail.pl" method="POST">
Full name: <input name="fullname"><br>

Country:
<select name="country">
<option></option>
<option value="usa">USA</option>
<option value="russia">Russia</option>
</select><br>

Question:
<textarea name="question"></textarea><br>

<input type="submit" value="Send mail">
</form>

</body>
</html>
```

第一个Perl CGI脚本仅仅处理表单并回显结果。

```perl
#!/usr/bin/perl -T
use strict;
use warnings;
use 5.008;

use Data::Dumper;
use CGI;
my $q = CGI->new;

my %data;
$data{fullname} = $q->param('fullname');
$data{country} = $q->param('country');
$data{question} = $q->param('question');

print $q->header;
if ($data{fullname} !~ /^[\s\w.-]+$/) {
    print "Name must contain only alphanumerics, spaces, dots and dashes.";
    exit;
}

print "response " . Dumper \%data;
```

我们来看看CGI部分：

`use CGI;`加载了`CGI`模块，而且我们创建了一个新的CGI对象叫做`$q`。

这里有两个目的。一个是从提交的表单中获取参数，另一个是打印出HTTP报头。

<h3>打印报头</h3>

打印报头是通过`print $q->header;`这一行实现。这等价于我们在[另一个例子中](https://perlmaven.com/how-to-calculate-balance-of-bank-accounts-in-csv-file-using-perl)看到的`print "Content-Type: text/html; charset=ISO-8859-1\n\n";`

<h3>获取提交数据</h3>

CGI对象的`param`方法以fullname域为输入参数返回提交的值。我们3次调用它以获取表单的3个域。
我们可以把这些值分别赋给不同标量变量($fullname, $country, $question)，但是把它们放到一个哈希里会更便于随后的处理。
我们可以使用`Vars`方法，但这里我希望更明确指定域的名字。

下边4行声明一个hash然后用从表单收到的值填充它。

```perl
my %data;
$data{fullname} = $q->param('fullname');
$data{country} = $q->param('country');
$data{question} = $q->param('question');
```

下一步是打印HTTP报头，这也可以是我们希望发送给浏览器的任何响应。

之后我们开始验证输入。

这里我只是演示一个例子，但是更多情况下你可能希望确保每个域收到可接受的值。

```perl
if ($data{fullname} !~ /^[\s\w.-]+$/) {
    print "Name must contain only alphanumerics, spaces, dots and dashes.";
    exit;
}
```

这里我们确保fullname域只能包含文本、数字、空格、点字符和破折号。
这对一个国际公司太有限了因为还需要接受Unicode字符，但作为一个小例子足够了。
一旦验证失败，我们打印错误信息，这会出现在浏览器里，之后退出CGI脚本。我们不希望继续执行剩余的代码。

本部分代码最后一步是打印哈希`%data`里的内容并发回给浏览器。
这么做只是验证我们成功捕获他们提交的值。

<h3>使用Javascript验证？</h3>

把验证部分放入表单的JavaScript代码里也可以。这可以提高可用性，但是<b>不</b>能对你的代码和服务器提供必要的保护。
你不得不验去证数据。


## 发送电子邮件

继续前的一个警告：

即便这段代码可以工作，我仍然建议这只是最后的方案。
如果你可以使用CPAN，那里有很多更好的办法去解决发送电子邮件部分。

## 安全：Taint模式

你或许注意到了，表单处理代码的第一行#！行以`-T`结尾。这个标志叫做`Taint模式`。
它通过限制特定的操作使我们的代码更安全。比如，发送电子邮件代码执行一个外部程序。
由于我们不能完全信任环境变量，taint模式要求我们自己设置`PATH`环境变量。
我们脚本实际上用不到它，因此只是设置为空：`$ENV{PATH} = '';`。

```perl
$ENV{PATH} = '';
sendmail(
    'Target <to@perlmaven.com>',
    'hello world',
    'submitted: ' . Dumper(\%data),
    'Source <from@perlmaven.com>');

sub sendmail {
    my ($tofield, $subject, $text, $fromfield) = @_;
    my $mailprog = "/usr/lib/sendmail";

    open my $ph, '|-', "$mailprog -t -oi" or die $!;
    print $ph "To: $tofield\n";
    print $ph "From: $fromfield\n";
    print $ph "Reply-To: $fromfield\n";
    print $ph "Subject: $subject\n";
    print $ph "\n";
    print $ph "$text";
    close $ph;
    return ;
}
```

脚本这部分我们使用了老式的方法发送邮件。这只在sendmail或者其他类似服务正常使用的Unix/Linux系统中可以工作。

实际的发送部分封装在一个需要4个参数子例程中。

* 收件人
* 标题行
* 邮件内容
* 发件人

子例程内，我们打开为sendmail命令打开了一个进程句柄并传递给它一些参数。
进程句柄（本例的$ph）就像一个普通的写文件句柄。你可以往里边打印文本，它会出现在"其他程序"的标准输入里。
这里的"其他程序"是系统里的sendmail程序。

当我们调用`close $ph`时，邮件注入系统常规的邮件队列里，跟其他信息一样等待调度到时发送出去。
这意味着几秒后，系统会试图发送你的邮件。

## 另一个警告

在每个人都可以提供邮件标题的环境中不要使用上述脚本，本例中的To, From, Reply-To, Subject。
这会导致[开放转发](http://en.wikipedia.org/wiki/Open_mail_relay)问题，因此可以用来发送垃圾邮件。
