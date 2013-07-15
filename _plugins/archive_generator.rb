require 'stringex'

module Jekyll  
  class ArchivePage < Page
    def initialize(site, base, dir)
      super(site, base, dir, 'index.html')
      self.data['layout']      = 'archive'
      self.data['title']       = "Archive"
      self.data['posts_to_render'] = site.posts
    end
  end

  class GenerateArchive < Generator
    safe true
    priority :low

    def generate(site)
      site.pages << ArchivePage.new(site, site.source, 'archives')
    end
  end
end