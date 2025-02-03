---
title: "Set HTTP headers with WWW-Mechanize"
timestamp: 2022-12-26T12:30:01
tags:
  - HTTP
  - WWW::Mechanize
  - GET
published: true
author: szabgab
archive: true
show_related: true
---


Perl has several modules on several levels of abstraction to interact with web sites using HTTP requests. One of the nice modules is [WWW::Mechanize](https://metacpan.org/pod/WWW::Mechanize) that is built on top of [LWP::UserAgent](https://metacpan.org/pod/LWP::UserAgent). In this example we'll see how to set the header in the HTTP request using WWW::Mechanize.

We'll use the service provided by the [httpbin.org](https://httpbin.org/) web site to see the headers we set.

It has many end-points. We use the one that will send back the header the client sent as its content. It makes it very easy to see what was in our header.


## Headers by Firefox on Ubuntu

If you visit [https://httpbin.org/headers](https://httpbin.org/headers) with your browser it will show you the headers your browser sent. For example I use FireFox on Ubuntu and this is the response I received:

```
{
  "headers": {
    "Accept": "text/html,application/xhtml+xml,application/xml;q=0.9,image/avif,image/webp,*/*;q=0.8",
    "Accept-Encoding": "gzip, deflate, br",
    "Accept-Language": "en-US,en;q=0.5",
    "Host": "httpbin.org",
    "Sec-Fetch-Dest": "document",
    "Sec-Fetch-Mode": "navigate",
    "Sec-Fetch-Site": "none",
    "Sec-Fetch-User": "?1",
    "Upgrade-Insecure-Requests": "1",
    "User-Agent": "Mozilla/5.0 (X11; Ubuntu; Linux x86_64; rv:108.0) Gecko/20100101 Firefox/108.0",
    "X-Amzn-Trace-Id": "Root=1-63a9883c-6224eacc100c2bee60d820ca"
  }
}
```

From this we can see that my browser identified itself as <b>Mozilla/5.0</b>

## Headers by curl

I also tried [curl](https://curl.se/):

```
curl https://httpbin.org/headers
```

This is what I received:

```
{
  "headers": {
    "Accept": "*/*",
    "Host": "httpbin.org",
    "User-Agent": "curl/7.81.0",
    "X-Amzn-Trace-Id": "Root=1-63a988f1-5f1945fa2ce2f4df1bbfd862"
  }
}
```

So curl identified itself as "curl/7.81.0".


## Simple request with WWW::Mechanize

In order to use this code you will first need to install WWW::Mechanize. You can probably do it using

```
cpanm WWW::Mechanize
```

This is a simple sample code:

{% include file="examples/get_mechanize.pl" %}

The result includes 3 sections divided by some dashes.

First we printed the HTTP status code the server set. It was 200 OK.

The second part is the HTTP header the server set. This was shown by using the <b>dump_headers</b> method.

Finally we have the content of the page that is set to the header our client sent. This is what we saw earlier.
In this output you can see that the Perl module identified as "WWW-Mechanize/2.06".

```
200
---
Connection: close
Date: Mon, 26 Dec 2022 11:47:34 GMT
Server: gunicorn/19.9.0
Content-Length: 190
Content-Type: application/json
Access-Control-Allow-Credentials: true
Access-Control-Allow-Origin: *
Client-Date: Mon, 26 Dec 2022 11:47:34 GMT
Client-Peer: 3.229.200.44:443
Client-Response-Num: 1
Client-SSL-Cert-Issuer: /C=US/O=Amazon/OU=Server CA 1B/CN=Amazon
Client-SSL-Cert-Subject: /CN=httpbin.org
Client-SSL-Cipher: ECDHE-RSA-AES128-GCM-SHA256
Client-SSL-Socket-Class: IO::Socket::SSL
Client-SSL-Version: TLSv1_2

---
{
  "headers": {
    "Accept-Encoding": "gzip",
    "Host": "httpbin.org",
    "User-Agent": "WWW-Mechanize/2.06",
    "X-Amzn-Trace-Id": "Root=1-63a989d6-7f55197f1542610231437bcd"
  }
}
```


## How to set HTTP head sent by the client

Finally we got to the code that changes the header of the request.

It is basically the same code as we had earlier, but now we called the <b>add_header</b> method twice
with key-value pairs.

{% include file="examples/set_headers_mechanize.pl" %}

The result looks like this:

The first 2 parts were the same as previously so I commented out those to focus on the header that was sent by our Perl code:

```
{
  "headers": {
    "Accept-Encoding": "gzip",
    "Api-Key": "Some API key",
    "Host": "httpbin.org",
    "User-Agent": "Internet Explorer/6.0",
    "X-Amzn-Trace-Id": "Root=1-63a98bea-425a9c414e57cf3f42335fa4"
  }
}
```

Here you can see that the "Api-Key" field was added and the "User-Agent" field was replaced by a value we provided.


