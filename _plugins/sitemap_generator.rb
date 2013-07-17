require 'builder'

module Jekyll
  class SitemapGenerator < Generator
    safe true
    priority :normal
    DAILY_CHANGE_FREQUENCY = 'daily'
    WEEKLY_CHANGE_FREQUENCY = 'weekly'

    HIGH_PRIORITY   = 1
    NORMAL_PRIORITY = 0.5

    def generate(site)
      with_new_sitemap do |sitemap|
        emit_urlset(sitemap, site)
      end
    end
  
    private
    def with_new_sitemap
      File.open('sitemap.xml', 'w') do |sitemap_file|
        yield Builder::XmlMarkup.new(:target => sitemap_file, :indent => 2)
      end
    end
  
    def emit_urlset(sitemap, site)
      sitemap.urlset(:xmlns => "http://www.sitemaps.org/schemas/sitemap/0.9") do |urlset|
        emit_root_url(urlset, site)
        sorted_posts(site).each { |post| emit_post_url(urlset, post, site) }
      end
    end
  
    def emit_root_url(urlset, site)
      emit_new_url(urlset, site.config['url'], simple_date_string(Date.today), DAILY_CHANGE_FREQUENCY, HIGH_PRIORITY)
    end

    def emit_post_url(urlset, post, site)
      emit_new_url(urlset, absolute_url(site, post), simple_date_string(post.date), WEEKLY_CHANGE_FREQUENCY)
    end
  
    def emit_new_url(urlset, location, modified_date, change_frequency, priority=NORMAL_PRIORITY)
      urlset.url do |url|
        url.loc location
        url.lastmod modified_date
        url.changefreq change_frequency
        url.priority priority
      end
    end
    
    def sorted_posts(site)
      site.posts.sort_by { |post| - post.date.to_i }
    end
  
    def absolute_url(site, post)
      site.config['url'] + post.url
    end
  
    def simple_date_string(date)
      date.strftime("%Y-%m-%d")
    end
  end
end