---
layout: post
title:  Local rails development with service stubs
date:   2013-11-09
author: Ketan Padegaonkar
categories: hacks ruby
---

Snap talks to a few external services for all its CI needs - GitHub, Heroku, S3. Ever wondered how we go about working on our local laptops with so many integration points?

Snap uses S3 for storing artifacts that your builds generate -- we'll demonstrate how we use different implementations of Amazon S3 when doing local development vs. a real S3 when running on AWS.

<img src="/assets/images/screenshots/local-rails-developmment-with-service-stubs/download-modal.png" class="screenshot"/>

For the most simple of cases -- we need to push a directory to S3 when your build completes and serve it out (through an authentication proxy) to users when they request for it.

For starters we need two different interfaces that can put and get from S3, so here's something that we put together:

Here's an implementation that talks to s3 via [s3cmd](http://s3tools.org/download)

{% highlight ruby linenos %}
# Knows how to perform s3 operations against a real s3 bucket
module S3
  class RealS3
    class << self
      def get(src, dest)
        sh("s3cmd get #{Config.s3_bucket}/#{src} #{dest}")
      end

      def put(src, dest)
        sh("s3cmd put #{src} #{Config.s3_bucket}/#{dest}")
      end

      def rm(path)
        sh("s3cmd rm #{path}")
      end
    end
  end
{% endhighlight %}

And here's a completely fake implementation that pretends like s3 is a local filesystem :)

{% highlight ruby linenos %}
  # Pretends that the local file-system is s3
  class FakeS3
    class << self
      def get(src, dest)
        fake_src = File.join(Config.s3_fake_path, src)
        FileUtils.cp_rf(fake_src, dest)
      end

      def put(src, dest)
        fake_dest = File.join(Config.s3_fake_path, dest)
        FileUtils.cp_rf(src, fake_dest)
      end

      def rm(path)
        fake_path = File.join(Config.s3_fake_path, path)
        FileUtils.rm_rf(fake_path)
      end
    end
  end
end
{% endhighlight %}

Now that we defined our two implementations -- one that talks to s3, and another that works off a file system. How do you load a particular implementation?

{% highlight ruby linenos %}
module S3
  # Since classes are constants, we define a constant that points to either RealS3 or FakeS3
  API = CustomDeletate.load('S3')
end

# To use the S3::API
S3::API.put('/path/to/local/artifact', 'location/in/s3')

# Knows how to load a constant specified in config/stubs.yml
class CustomDelegate
  class << self
    def load(delegate_name)
      all_stubs = YAML.load(File.read(File.join(Rails.root, 'config', 'stubs.yml')))
      stubs_for_current_environment = all_stubs[Rails.env]
      delegate_class_name = stubs_for_current_environment[delegate_name]
      delegate_class = delegate_class_name.constantize
      delegate_class
    end
  end
end

{% endhighlight %}

Our stubs.yml fle contains all the stubs that we would need to work with.

{% highlight yaml linenos %}
# config/stubs.yml
# Here we define the various stubs to 3rd party integrations and
# endpoints that we can now use for local development
production:
  "S3": "S3::RealS3"
  "Github": "Github::RealGithub"
development:
  "S3": "S3::FakeS3"
  "Github": "Github::FakeGithub"
test:
  "S3": "S3::FakeS3"
  "Github": "Github::FakeGithub"
{% endhighlight %}
