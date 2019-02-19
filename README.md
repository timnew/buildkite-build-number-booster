# buildkite-build-number-booster
Boost build number to a expected value by creating hundreds of thousands of failling builds

## Why this project

It is common to use CI build number as the build number for the project, such as app or other.

Occasionally, we will create a new pipeline for existing project, such as splitting a project into different pipeline or migrate to a new account or move to a new CI, all kinds of reasons.

Then we might end up to wish to update the build number on CI (If we don't want to do some math in the build script). Unfortunately, Buildkite doesn't allow us to do it (easily). So I created this script.

## How it works

It is a ruby script that calling buildkite REST API. It asks Buildkite to build an commit and branch that does not exist, so the build fails in seconds. But the build number increases.

## How to use it

```
$ git clone git@github.com:timnew/buildkite-build-number-booster.git
$ bundle install
$ export TOKEN=<the API access token with write_builds access>
$ export ORG=<your organization slug>
$ export PIPELINE=<your pipeline slug>
$ export BK_USER=<your buildkite user name>
$ export BK_EMAIL=<your buildkite email>
$ export target=<build number you want to reach>
$ bundle exec rake
```

### How to create API token

Open the url and follow the instruction: https://buildkite.com/user/api-access-tokens

### Where to find the slug

Here is an example: If the home page of the project is https://buildkite.com/your-company/your-project-name, 
```
$ export ORG=your-company PIPELINE=your-project-name
```
