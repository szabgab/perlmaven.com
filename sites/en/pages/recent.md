---
title: "Monitoring the most recent uploads to CPAN"
timestamp: 2015-11-24T18:00:01
tags:
  - CPAN
published: true
author: szabgab
---


Monitoring the most recent upload to CPAN.


<script>
angular.module('PerlMavenApp').controller('PerlMavenRecentCtrl', function($scope, $http) {
    $http.get('/api/1/recent').then(function (response) {
        console.log(response.data);
        $scope.distributions = response.data;
    }, function(response) {
        console.log('error');
    });
});
</script>

<!--
<div ng-controller="PerlMavenRecentCtrl">
  <table>
  <tr>
    <th>Distribution</th>
    <th>Abstract</th>
    <th>Date</th>
    <th>Repository</th>
    <th>Travis-CI</th>
    <th>License</th>
    <th></th>
  </tr>
  <tr ng-repeat="d in distributions" ng-class-even="'even'" ng-class-odd="'odd'">
    <td>[{{d.distribution}}](http://metacpan.org/release/{{d.distribution}})</td>
    <td>{{d.abstract}}</td>
    <td>{{d.date}}</td>
    <td>
      <span ng-show="d.repository_url"><a href="{{d.repository_url}}"><span class="label label-success">Repo</span></a></span>
      <span ng-show="!d.repository_url"><a href="/how-to-add-link-to-version-control-system-of-a-cpan-distributions"><span class="label label-danger">Add link!</span></a></span>
    </td>
    <td>
       <span ng-show="d.travis_yml"><a href="https://travis-ci.org/{{d.repo}}/"><span class="label label-success">Travis</span></a></span>
       <span ng-show="!d.travis_yml">
          <span ng-show="d.repo">
              <a href="/enable-travis-ci-for-continous-integration"><span class="label label-danger">Enable!</span></a>
          </span>
          <span ng-show="!d.repo">
              <span class="label label-default">Irrelevant</span>
          </span>
       </span>
    </td>
    <td>
       <span ng-show="d.license[0] === 'unknown'"><a href="/how-to-add-the-license-field-to-meta-files-on-cpan"><span class="label label-danger">Add!</span></a></span>
       <span ng-show="d.license[0] !== 'unknown'"><a href=""><span class="label label-success">{{d.license[0]}}</span></a></span>
    </td>
  </tr>
  </table>

  <div>Total: {{distributions.length}}</div>

-->

* [Recent CPAN releases without a repository in the META files](http://cpan.perlmaven.com/#lab/no-repository)
* [Recent releases without a "license" field in the META files](http://cpan.perlmaven.com/#lab/no-license)

  <h2>Explanation</h2>

    I believe Perl, just as any other Open Source technology can only strive if many people contribute a little-bit.
    Therefore I've started to create a page, that will help you find some "low hanging fruits". Things that I think
    can be easy to contribute to. On [this page](https://perlmaven.com/recent) you can find the 100 most recent
    uploads to CPAN. The first 3 columns give generic information.

  <h3>Repository - Is there a link to a public Version control system?</h3>

   The 4th column shows a link to the Public Version Control
   Repository of the module. If the module does not declare its Public VCS then you'll find a red button. Clicking on that
   button will lead you to the explanation how to add the link. Of course fist you'll need to find if the module
   even has a repository. You can usually do that by searching GitHub. You might also look at other modules from the same
   author (using MetaCPAN). That can lead you to the repository of this module.

  Having a Public VCS is a good thing for every Open Source Project. Having it included in the META file makes it easy for people to find it.

  <ul>
    <!-- <li>No VCS and the author explicitly said s/he does not have a public VCS. Then link to explanation why would it be beneficial to have a public VCS. (this is not implemented yet)</li> -->
    <li>No VCS. Then link to explanation how to start using GitHub.</li>
    <li>Has GitHub link in the 'url' field and also has a 'web' field and a 'type' field. Then this is perfect.</li>
    <li>Has GitHub link in the 'url' or 'web' fields but not like above. Then link to explanation how to improve it.</li>
    <li>Has some other VCS link in the 'url' or 'web' fields. That's ok but nevertheless link to explanation that if it was on GitHub it could use Travis-CI.</li>
  </ul>

   <h3>Travis-CI</h3>

   Travis-CI provides free continuous integration to Open Source projects on GitHub. The next column is green if the
   specific distribution has Travis configured. Red if it does not have it configured. Grey if it is not relevant (yet).
   This could be either because we don't know where is the public version control repository of the project, or because it
   is not using GitHub. In the former case you'd also see a red button in the previous column. That needs to be fixed
   before this becomes relevant. If the button is red and says Add!, you can click on it to see the explanation how to
   configure Travis-CI. You only need to add a file to the repository and send a pull-request.

  <div>
  Note: Usernames on Github are case insensitive, but on Travis-CI they are [still case sensitive](https://github.com/travis-ci/travis-ci/issues/3198).
  This can break the above report if the URL give in the META.yml is not in the same case as Travis-CI.
  </div>

   <h3>License</h3>

   Authors can declare the license of their module in the META files. If this field is red, the author has not done this yet.
   Red buttons lead you to the explanation how to add the license information. Talk to the author and send a patch or
   a GitHub pull-request in order to get this fixed.

</div>

