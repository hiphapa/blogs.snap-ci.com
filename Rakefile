#!/usr/bin/env rake -f
require 'yaml'
require 'json'
require 'securerandom'
require 'uri'

desc "build all blogs"
task :build do
  sh("bundle exec jekyll build --config #{config_file_path} #{'--drafts' if include_drafts?}")
end

desc "deploy the blogs"
task :deploy do
  items = (Dir["_site/**/*.*"] + Dir["_site/**/.*"]).map{|file| URI.encode(file.gsub(/^_site/, '')) }.flatten.sort

  File.open('invalidation.json', 'w') do |f|
    invalidations = {
      :Paths => {
        :Quantity => items.count,
        :Items => items
      },
      :CallerReference => ENV['SNAP_CI'] ? "#{ENV['SNAP_PIPELINE_COUNTER']}-#{ENV['SNAP_COMMIT_SHORT']}" : SecureRandom.hex
    }
    f.puts JSON.pretty_generate(invalidations)
  end

  sh("aws s3 sync --acl public-read --delete --cache-control 'max-age=600, must-revalidate' _site/ s3://#{ENV['S3_BUCKET']}")
  sh("aws configure set preview.cloudfront true")
  sh("aws cloudfront create-invalidation --distribution-id #{ENV['CLOUDFRONT_DISTRIBUTION']} --invalidation-batch file://invalidation.json")
end

private
def config_file_path
  env = ENV['ENVIRONMENT']
  error_message = 'Please set environment variable ENVIRONMENT=STAGING or PRODUCTION'
  raise error_message if env.nil? || !%w(STAGING PRODUCTION).include?(env.upcase)
  "_config_#{env.downcase}.yml"
end

def include_drafts?
  env = ENV['ENVIRONMENT']
  error_message = 'Please set environment variable ENVIRONMENT=STAGING or PRODUCTION'
  raise error_message if env.nil? || !%w(STAGING PRODUCTION).include?(env.upcase)
  env.upcase == 'STAGING'
end
