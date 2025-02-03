---
title: "Using the Open Weather Map API with Perl"
timestamp: 2019-02-27T12:00:01
tags:
  - LWP::Simple
  - Config::Tiny
  - Cpanel::JSON::XS
published: true
author: szabgab
archive: true
---


In [Using the Open Weather Map API with curl](https://code-maven.com/pro/openweathermap-api-using-curl) we saw how to fetch the weather using `curl`. Now we are going to use Perl as that
will make it easier to use this as part of a larger application. Before you read this article, make sure you read
the one using `curl`.



## Configuration file

As you can read in the other article, in order to access the Open Weather Map API we need to have an API key.
We could store the API-key in a variable in the code, but then if we distribute the code we also distribute the API key.

Usually it is a better practice to have all of these keys and sometimes passwords in external files that are not stored
together with the code of the application. That makes it also a lot easier to have a separate set of keys for development, testing,
and production.

We created a file called <b>config.ini</b> with the following content:

```
[openweathermap]
api=wkfhshoiaslv
```

Where of course I put the API-key from [Open Weather Maps](https://home.openweathermap.org/api_keys).

In the code we used [Config::Tiny](https://metacpan.org/pod/Config::Tiny) to [reading the configuration INI file](/reading-configuration-files-in-perl).
This is in the `get_api_key` function.

We used the `get` function provided by [LWP::Simple](https://metacpan.org/pod/LWP::Simple) to access the API and
the `decode_json` function provided by [Cpanel::JSON::XS](https://metacpan.org/pod/Cpanel::JSON::XS) as featured in the article
about [JSON](/json) to convert the received JSON string into a perl data structure.


Then in the `main` function we print the temperature which is inside the "main" key of the retrieved data structure using
`$weather->{main}{temp};` and we also use the `Dumper` function to show the whole data structure as a Perl hash.

## The code

{% include file="examples/get_weather.pl" %}


## The dumped data

```
$VAR1 = {
          'weather' => [
                         {
                           'id' => 701,
                           'description' => 'mist',
                           'main' => 'Mist',
                           'icon' => '50n'
                         }
                       ],
          'id' => 3054643,
          'base' => 'stations',
          'dt' => 1518193800,
          'cod' => 200,
          'name' => 'Budapest',
          'coord' => {
                       'lat' => '47.5',
                       'lon' => '19.04'
                     },
          'clouds' => {
                        'all' => 75
                      },
          'visibility' => 4500,
          'main' => {
                      'temp' => 3,
                      'humidity' => 89,
                      'temp_min' => 3,
                      'temp_max' => 3,
                      'pressure' => 1016
                    },
          'sys' => {
                     'sunset' => 1518191920,
                     'id' => 5724,
                     'message' => '0.0031',
                     'sunrise' => 1518155886,
                     'country' => 'HU',
                     'type' => 1
                   },
          'wind' => {
                      'speed' => '2.1',
                      'deg' => 350
                    }
        };
```

## Conclusion

Once we have this basic solution we can integrate this code into a larger application or change the requested URL to
match other API end-points.

