require 'stringex'

module Jekyll
  
  class FeedPage < Page
    def initialize(site, base)
      super(site, base, '.', 'feed.atom')
      self.data['title']           = "Snap"
      self.data['feed_url']        = "feed.atom"
      self.data['posts_to_render'] = site.posts.sort_by { |post| - post.date.to_i }
    end
  end

  class FeedGenerator < Generator
    safe true
    priority :low

    def generate(site)
      site.pages << FeedPage.new(site, site.source)
    end
  end
end