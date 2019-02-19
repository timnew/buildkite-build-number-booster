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

## The script is too slow

To avoid the script being considered as DoS attack to the Buildkite, the script is working on single thread, it fires new request after old one has returned. And it reduce the chance that we over build the target.

And the script roughly fire 1 req/s, so you can have it run in the background, bumping 1000 builds takes just 17 min.

To make it faster, you can turn on `Build Skipping` from the pipeline settings, so CI will terminate the previous build if a new one is kicked off on the same branch.

### Multi-threading

The script really don't support multi-threading per reason explained above. If you really want to go parallel, you can kick off multiple processes easily. Just make sure they have the same environment variables settings. And you might expecte over built in this case.
