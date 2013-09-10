#!/usr/bin/env rake -f
require 'yaml'

desc "generate jekyll configuration"
task :generate_config do
  config = YAML.load(File.open('_config_default.yml')).merge(load_environment_config(ENV['ENVIRONMENT']))
  File.open('_config.yml', 'w') { |f| f.write(config.to_yaml) }
end

desc "build all blogs"
task :build => [:generate_config] do
  sh("bundle exec jekyll build")
end

desc "deploy the blogs"
task :deploy => [:generate_config] do

  sh("curl --location http://sourceforge.net/projects/s3tools/files/s3cmd/1.0.1/s3cmd-1.0.1.tar.gz 2>/dev/null | tar -zxf -")
  File.open('s3.cfg', 'w') do |f|
    f.puts "[default]"
    f.puts "access_key = #{ENV['S3_ACCESS_KEY']}"
    f.puts "secret_key = #{ENV['S3_SECRET_KEY']}"
  end

  sh("./s3cmd-1.0.1/s3cmd sync --config s3.cfg --verbose --acl-public --delete-removed --no-preserve _site/* s3://#{ENV['S3_BUCKET']}")
end

private
def load_environment_config(env)
  error_message = 'Please set environment variable ENVIRONMENT=STAGING or PRODUCTION'
  raise error_message if env.nil? || !%w(STAGING PRODUCTION).include?(env.upcase)
  YAML.load(File.open("_config_#{env.downcase}.yml"))
end
