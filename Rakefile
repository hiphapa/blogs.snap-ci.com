#!/usr/bin/env rake -f
require 'yaml'

desc "build all blogs"
task :build do
  sh("bundle exec jekyll build --config #{config_file_path}")
end

desc "deploy the blogs"
task :deploy => [:build] do

  sh("curl --location http://sourceforge.net/projects/s3tools/files/s3cmd/1.0.1/s3cmd-1.0.1.tar.gz 2>/dev/null | tar -zxf -")
  File.open('s3.cfg', 'w') do |f|
    f.puts "[default]"
    f.puts "access_key = #{ENV['S3_ACCESS_KEY']}"
    f.puts "secret_key = #{ENV['S3_SECRET_KEY']}"
  end

  sh("./s3cmd-1.0.1/s3cmd sync --config s3.cfg --verbose --acl-public --delete-removed --no-preserve _site/* s3://#{ENV['S3_BUCKET']}")
end

private
def config_file_path
  env = ENV['ENVIRONMENT']
  error_message = 'Please set environment variable ENVIRONMENT=STAGING or PRODUCTION'
  raise error_message if env.nil? || !%w(STAGING PRODUCTION).include?(env.upcase)
  "_config_#{env.downcase}.yml"
end
