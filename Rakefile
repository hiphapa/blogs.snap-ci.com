#!/usr/bin/env rake -f

desc "build all blogs"
task :build do
  sh("bundle exec jekyll build")
end

desc "deploy the blogs"
task :deploy do
  sh("curl --location http://sourceforge.net/projects/s3tools/files/s3cmd/1.0.1/s3cmd-1.0.1.tar.gz 2>/dev/null | tar -zxf -")
  File.open('s3.cfg', 'w') do |f|
    f.puts "[default]"
    f.puts "access_key = #{ENV['S3_ACCESS_KEY']}"
    f.puts "secret_key = #{ENV['S3_SECRET_KEY']}"
  end

  sh("./s3cmd-1.0.1/s3cmd sync --config s3.cfg --verbose --acl-public --delete-removed --no-preserve _site/* s3://#{ENV['S3_BUCKET']}")
end
