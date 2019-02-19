require 'uri'
require 'net/http'

class Booster
  attr_reader :http, :url
  attr_reader :organization, :pipeline, :token, :target, :user, :email
  attr_accessor :build_number

  def initialize(organization:, pipeline:, token:, target:, user:, email:)
    @organization = organization
    @pipeline = pipeline
    @token = token
    @target = target.to_i
    @user = user
    @email = email
    @build_number = 0

    @url = URI("https://api.buildkite.com/v2/organizations/#{organization}/pipelines/#{pipeline}/builds")
    @http = Net::HTTP.new(url.host, url.port)
    http.use_ssl = true
  end

  def check_build_number
    build_number < target
  end

  def boost
    return unless check_build_number

    puts 'Kick off new build'

    request = Net::HTTP::Post.new(url)
    request['Content-Type'] = 'application/json'
    request['Authorization'] = "Bearer #{token}"
    request['cache-control'] = 'no-cache'
    request.body = {
      commit: 'commit-do-not-exist',
      branch: 'boost-build',
      message: 'Boost Build Number',
      author: {
        name: user,
        email: email
      },
      meta_data: {
        boost_builder_number: true
      }
    }.to_json


    response = http.request(request)
    body = JSON.parse response.read_body

    new_build_number = body['number']

    puts "Build number boosted to #{new_build_number}"

    self.build_number = new_build_number

    check_build_number
  end

  def run
    while check_build_number
      boost
    end
  end
end
