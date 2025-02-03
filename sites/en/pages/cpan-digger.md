---
title: "CPAN Digger"
timestamp: 2020-10-24T12:30:01
tags:
  - CPAN
published: true
author: szabgab
archive: true
description: "CPAN Digger is going to be a web site collecting data about Perl-related code and helping the authors to improve that code."
show_related: true
---


The goal of the CPAN Digger project is to understand and to help to improve the code that is on CPAN.


A few steps:

## Weekly report in the Perl Weekly

Before setting out to make the small improvements I can offer, I wanted to measure the current state and I wanted to have a way to measure progress.

In the [Perl Weekly](https://perlweekly.com/) newsteller I've started to share weekly [statistics from MetaCPAN](https://perlweekly.com/metacpan.html)

What I saw is that the numbers are fluctuating quite a lot (even the percentages). About 20-25% of the distributions have not links to GitHub or other public VCS.
About 40-60% of those that have a link don't have a CI system configured.

## Link to Public Version Control System

If a distribution does not have a link to a public VCS in their META file then it will be difficult to contribute to that distribution.
Some people might expect a patch in e-mail, but these days very few people know how to do that. A lot more know how to send a pull-request.
It is also much better as the potential contributor can easily see the changes since the most recent release that are still only in the repository.
If it is an open source project having an accessible public version control system seems like a very sensible option.
Linking to it in the meta-data of the package makes it easy for other tools, e.g. MetaCPAN to display it.

Also without a link to a VCS it will be outright impossible to see if it has a CI system configured.

So the first step is to locate CPAN distributions that don't include a link to their VCS (Version Control System). Suggest to the author to add one.
[How to convince Meta CPAN to show a link to the version control system of a distribution?](/how-to-add-link-to-version-control-system-of-a-cpan-distributions)
This has to be done by contacting the author personally.

## Configure Continuous Integration (CI) for the project

Using a hosted [Continuous Integration system](/ci) helps the author catch many issues before the distribution reaches CPAN.
It can catch issues with changing dependencies even while the code itself does not change and it can help noticing if our changes
would break any of the downstream dependencies before we release the code to CPAN.

In this step we need to locate distributions that have VCS, but don't have CI configured. Ask the author if they are interested and send a Pull-Request to set up CI.

[CPAN Testers](http://www.cpantesters.org/) are awesome, I wrote about them a number of times. They test most of the modules uploaded to CPAN on various platforms.
However they only run on modules already uploaded to CPAN. A CI-system configured to your repo can run every time you push a file.
Every time someone sends a pull-requests shortening the  the feedback loop to the potential contributors. It can run scheduled, for examples once a day,
to see if a change in one of your dependencies did not break your code. Again, to get back feedback as soon as possible.

If the project is hosted on GitHub there are a number of options such as GitHub Actions, Travis-CI, Appveyor, Circle-CI, Azure Pipelines.

If the project is hosted on GitLab, they provide the GitLab pipelines.

If the project is hosted on Bitbucket, they provide their own pipelines.

A few articles:

[Enable Travis-CI for Continuous Integration](/enable-travis-ci-for-continous-integration)

[Using Travis-CI and installing Geo::IP on Linux and OSX](/using-travis-ci-and-installing-geo-ip-on-linux)

## Link the the desired issue-tracking system

By default MetaCPAN will link to the [Request Tracker](https://rt.cpan.org/), but you might prefer that your users
will submite bug-reports and feature requests via some other issue-tracking system. For example the one that comes with your
Version Control system.

Help authors configure the Meta-data that links MetaCPAN to the issue-tracking system they prefer to use.

## License field

The license field in the META data of a CPAN packages allows an easy way to automatically check the license of each package.

[How to add the license field to the META.yml and META.json files on CPAN?](/how-to-add-the-license-field-to-meta-files-on-cpan)

## Tools

You can install the [CPAN::Digger](https://metacpan.org/pod/CPAN::Digger) module and run

```
cpan-digger --author SZABGAB --report
```

replacing my PAUSE ID with yours. This will give you a list of your distributions that do not have a link to a Version Control System.

```
cpan-digger --author SZABGAB --report --github --sleep 3 --limit 30
```

This will also check the 30 most recently uploaded distributions for having a CI system.
This will clone each repository in a temporary directory so you might want to set the "--sleep" flag to hammer GitHub a bit less frequently.


```
cpan-digger --recent 30 --report --github --sleep 3
```

Finally you can ask information about the N most recently uploaded distributions by any author. This can be useful
if you would like to help others linking to the VCS or setting up a CI system.

## TODO
* Set up a separate site where we collect the Meta information about CPAN distributions.
* Run Perl Critic on the source code of the modules and show statistics which rules are usually followed and which not. See [Kritika](https://kritika.io/)
* Run Perl Tidy on the source code and see what layout is usually used.
* Check Cyclomatic Complexity of the code - [Perl::Metrics::Simple](https://metacpan.org/pod/Perl::Metrics::Simple)


{% youtube id="imJjt5SgQII" file="english-cpan-digger-v1.01.mkv" %}


## Log

Emails suggesting to add link to VCS. There always will be people who don't want to share the link to their public version control. That's fine. We should not bother them again.

On the other hand where the email bounced or where there was no response we might try to find another way to contact the author.

<style>
td {
    padding-left: 10px;
}
.success {
   color: green;
}
.todo {
   color: brown;
}
.failure {
   color: red;
}
</style>

<table>
<tr class="neutral"><td>2020.11.21</td><td>[Jason Carty](https://metacpan.org/author/JCARTY)            </td><td>Email bounced                                </td></tr>
<tr class="failure"><td>2020.11.18</td><td>[Guido Socher](https://metacpan.org/author/GUS)              </td><td>Not using public VCS                         </td></tr>
<tr class="success"><td>2020.11.18</td><td>[Olly Betts](https://metacpan.org/author/OLLY)               </td><td>Link added                                   </td></tr>
<tr class="success"><td>2020.11.18</td><td>[Mathias Weidner](https://metacpan.org/author/MAMAWE)        </td><td>Links added                                  </td></tr>
<tr class="neutral"><td>2020.11.15</td><td>[Strzelecki Łukasz](https://metacpan.org/author/STRZELEC)    </td><td>                                             </td></tr>
<tr class="neutral"><td>2020.11.15</td><td>[Brian Kelly](https://metacpan.org/author/REEDFISH)          </td><td>                                             </td></tr>
<tr class="neutral"><td>2020.11.15</td><td>[Louis Strous](https://metacpan.org/author/LSTROUS)          </td><td>                                             </td></tr>
<tr class="failure"><td>2020.11.15</td><td>[Ludovico Stevens](https://metacpan.org/author/LSTEVENS)     </td><td>Not using public VCS                         </td></tr>
<tr class="neutral"><td>2020.11.15</td><td>[Marcus Holland-Moritz](https://metacpan.org/author/MHX)     </td><td>Pull-request sent                            </td></tr>
<tr class="failure"><td>2020.11.15</td><td>[John Heidemann](https://metacpan.org/author/JOHNH)          </td><td>Not using public VCS                         </td></tr>
<tr class="neutral"><td>2020.11.14</td><td>[Mike Taylor](https://metacpan.org/author/MIRK)              </td><td>                                             </td></tr>
<tr class="neutral"><td>2020.11.14</td><td>[Pete Ratzlaff](https://metacpan.org/author/PRATZLAFF)       </td><td>                                             </td></tr>
<tr class="neutral"><td>2020.11.14</td><td>[S. Falempin](https://metacpan.org/author/DOHNUTS)           </td><td>Email bounced                                </td></tr>
<tr class="neutral"><td>2020.11.14</td><td>[Sano Taku](https://metacpan.org/author/MIKAGE)              </td><td>                                             </td></tr>
<tr class="neutral"><td>2020.11.14</td><td>[Scott T. Hardin](https://metacpan.org/author/MRSCOTTY)      </td><td>                                             </td></tr>
<tr class="neutral"><td>2020.11.12</td><td>[Bruce Schuck](https://metacpan.org/author/BPSCHUCK)         </td><td>                                             </td></tr>
<tr class="success"><td>2020.11.12</td><td>[Michael R. Davis](https://metacpan.org/author/MRDVT)        </td><td>Moving once private repos to GitHub          </td></tr>
<tr class="neutral"><td>2020.11.12</td><td>[Wang Fan](https://metacpan.org/author/WFANSH)               </td><td>                                             </td></tr>
<tr class="neutral"><td>2020.11.12</td><td>[Armin Fuerst](https://metacpan.org/author/AFUERST)          </td><td>Email bounced                                </td></tr>
<tr class="neutral"><td>2020.11.09</td><td>[Franck Giacomoni](https://metacpan.org/author/GIACOMONI)    </td><td>                                             </td></tr>
<tr class="success"><td>2020.11.09</td><td>[David Dick](https://metacpan.org/author/DDICK)              </td><td>On GitHub now                                </td></tr>
<tr class="neutral"><td>2020.11.07</td><td>[LE GALL Thierry](https://metacpan.org/author/FACILA)        </td><td>                                             </td></tr>
<tr class="neutral"><td>2020.11.07</td><td>[Tomohiro Yamashita](https://metacpan.org/author/TOMOYAMA)   </td><td>                                             </td></tr>
<tr class="failure"><td>2020.11.07</td><td>[Philip Gwyn](https://metacpan.org/author/GWYN)              </td><td>Not using public VCS                         </td></tr>
<tr class="neutral"><td>2020.11.07</td><td>[Pete Krawczyk](https://metacpan.org/author/PETEK)           </td><td>                                             </td></tr>
<tr class="failure"><td>2020.11.07</td><td>[Jerrad Pierce](https://metacpan.org/author/JPIERCE)         </td><td>Not using public VCS                         </td></tr>
<tr class="neutral"><td>2020.11.05</td><td>[Jim Turner](https://metacpan.org/author/TURNERJW)           </td><td>                                             </td></tr>
<tr class="neutral"><td>2020.11.05</td><td>[Karl Gaissmaier](https://metacpan.org/author/GAISSMAI)      </td><td>                                             </td></tr>
<tr class="neutral"><td>2020.11.03</td><td>[Christoph Halbartschlager](https://metacpan.org/author/CHA) </td><td>                                             </td></tr>
<tr class="success"><td>2020.11.03</td><td>[John Gravatt](https://metacpan.org/author/GRAVATTJ)         </td><td>John added the VCS link within a few hours   </td></tr>
<tr class="neutral"><td>2020.11.03</td><td>[Oleg Pronin](https://metacpan.org/author/SYBER)             </td><td>                                             </td></tr>
<tr class="neutral"><td>2020.10.31</td><td>[Dustin La Ferney](https://metacpan.org/author/CREDO)        </td><td>                                             </td></tr>
<tr class="success"><td>2020.08.25</td><td>[Vincent van Dam](https://metacpan.org/author/JOYREX)        </td><td>Pull-request sent                                   </td></tr>
<tr class="neutral"><td>2020.08.25</td><td>[Vitaliy V. Tokarev](https://metacpan.org/author/TVV)        </td><td>Will fix in the next issue                          </td></tr>
<tr class="failure"><td>2020.10.25</td><td>[Jeffrey Ratcliffe](https://metacpan.org/author/RATCLIFFE)   </td><td>Did not sound enthusiastic about the idea.          </td></tr>
<tr class="failure"><td>2020.10.25</td><td>[NLnet Labs](https://metacpan.org/author/NLNETLABS)          </td><td>It is in the README and they prefer not to add to the META data. [see also](https://rt.cpan.org/Public/Bug/Display.html?id=101777)</td></tr>
<tr class="neutral"><td>2020.10.25</td><td>[Robert Acock](https://metacpan.org/author/LNATION)          </td><td>                                                    </td></tr>
<tr class="neutral"><td>2020.10.25</td><td>[Philip R Brenan](https://metacpan.org/author/PRBRENAN)      </td><td>positive reply                                      </td></tr>
<tr class="success"><td>2020.08.19</td><td>[Roland van Ipenburg](https://metacpan.org/author/IPENBURG)  </td><td>success                                             </td></tr>
<tr class="success"><td>2020.08.19</td><td>[Theo van Hoesel](https://metacpan.org/author/VANHOESEL)     </td><td>projects were internal on their way to public VCSs. </td></tr>
<tr class="success"><td>2020.08.19</td><td>[Szymon Nieznański](https://metacpan.org/author/SNEZ)        </td><td>projects were internal on their way to public VCSs. </td></tr>
<tr class="todo"   ><td>2020.08.19</td><td>[Juan Jose San Martin](https://metacpan.org/author/PECO)     </td><td>no response                                         </td></tr>
<tr class="failure"><td>2020.08.19</td><td>[Paul "LeoNerd" Evans](https://metacpan.org/author/PEVANS)   </td><td>no objection, but does not see much value in the links. - result: no links.</td></tr>
<tr class="neutral"><td>2020.08.10</td><td>[Jacques Degues](https://metacpan.org/author/JDEGUEST)       </td><td>positive response, partial success                  </td></tr>
<tr class="success"><td>2020.08.09</td><td>[Mike Jones](https://metacpan.org/author/MIKEJONES)          </td><td>success                                             </td></tr>
<tr class="todo"   ><td>2020.08.09</td><td>[Know Zero](https://metacpan.org/author/KNOWZERO)            </td><td>Email bounced                                       </td></tr>
<tr class="success"><td>2020.08.08</td><td>[Kang-min Liu](https://metacpan.org/author/GUGOD)            </td><td>success: it was just an oversight.                  </td></tr>
</table>

<!--
<tr class="neutral"><td>2020.11.</td><td><a href=""></a>         </td><td>                                             </td></tr>
-->
