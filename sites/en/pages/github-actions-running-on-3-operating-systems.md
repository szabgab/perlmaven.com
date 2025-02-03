---
title: "Github Actions for Perl running on Windows, Mac OSX, and Ubuntu Linux"
timestamp: 2020-11-13T07:30:01
tags:
  - PerlMaven
published: true
author: szabgab
archive: true
show_related: true
---


In order to configure GitHub Actions for a Perl project, all you need is to create a directory called `.github/workflows` and
put a [YAML](/yaml) file in it. The name of the file does not matter much, as long as it has the <b>yml</b> extension.

This example was copied from the [repostory of Array::Compare](https://github.com/davorg/array-compare/) by
[Dave Cross](https://davecross.co.uk/). It was called `.github/workflows/perltest.yml` there.

Then it was slightly changed and annotated with explanations.


{% include file="examples/workflows/perltest.yml" %}


## workflow_dispatch

If workflow_dispatch is enabled in the GitHub Actions workflow you'll be able to run the workflow
[manually from GitHub UI](https://docs.github.com/en/free-pro-team@latest/actions/managing-workflow-runs/manually-running-a-workflow)
or via the [REST API](https://docs.github.com/en/free-pro-team@latest/rest/reference/actions#create-a-workflow-dispatch-event).

```
curl -u USERNAME:PERSONAL_TOKEN -X POST \
    -H "Accept: application/vnd.github.v3+json" \
    https://api.github.com/repos/OWNER/REPO_NAME/actions/workflows/WORKFLOW_FILE_NAME/dispatches -d '{"ref":"BRANCH"}'
```

* USERNAME - Your GitHub username (In my case it is szabgab, in the case of Dave it is davorg)
* PERSONAL_TOKEN - See [Create personal access token](https://docs.github.com/en/free-pro-team@latest/github/authenticating-to-github/creating-a-personal-access-token)
* OWNER - This might be your username, or an organization, this is the first part in the URL path of the reposiotry. In the case we used here it is <b>davorg</b>.
* REPO_NAME - The name of the project reposiotory. In this case it is <b>array-compare</b>.
* WORKFLOW_FILE_NAME - In this case it was <b>perltest.yml</b> (including the extension).
* BRANCH - Can be "master" or "main" or whatever branch-name you have


It will sets <b>GITHUB_EVENT_NAME</b> to be <b>workflow_dispatch</b>


For more details, see [workflow_dispatch](https://docs.github.com/en/free-pro-team@latest/actions/reference/events-that-trigger-workflows#workflow_dispatch)




