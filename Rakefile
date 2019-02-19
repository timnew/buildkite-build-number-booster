require 'active_support/all'
require 'httpclient'
require './read_env'
require './json_client'
require './booster'

desc 'Boost build number to target'
task :default do
  token = read_env('TOKEN', secret: true)
  org_slug = read_env('ORG')
  pipeline_slug = read_env('PIPELINE')
  target = read_env('TARGET')
  user = read_env('BK_USER')
  email = read_env('BK_EMAIL')

  Booster.new(
    token: token,
    organization: org_slug,
    pipeline: pipeline_slug,
    target: target,
    user: user,
    email: email
  ).run
end

