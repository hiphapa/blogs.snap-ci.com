require 'stringex'

module Jekyll
#   # The CategoryFeed class creates an Atom feed for the specified category.
#   class CategoryFeed < Page
# 
#     # Initializes a new CategoryFeed.
#     #
#     #  +base+         is the String path to the <source>.
#     #  +category_dir+ is the String path between <source> and the category folder.
#     #  +category+     is the category currently being processed.
#     def initialize(site, base, category_dir, category)
#       @site = site
#       @base = base
#       @dir  = category_dir
#       @name = 'atom.xml'
#       self.process(@name)
#       # Read the YAML data from the layout page.
#       self.read_yaml(File.join(base, '_includes/custom'), 'category_feed.xml')
#       self.data['category']    = category
#       # Set the title for this page.
#       title_prefix             = site.config['category_title_prefix'] || 'Category: '
#       self.data['title']       = "#{title_prefix}#{category}"
#       # Set the meta-description for this page.
#       meta_description_prefix  = site.config['category_meta_description_prefix'] || 'Category: '
#       self.data['description'] = "#{meta_description_prefix}#{category}"
# 
#       # Set the correct feed URL.
#       self.data['feed_url'] = "#{category_dir}/#{name}"
#     end
# 
#   end
# 
  
  class CategoryIndex < Page
    def initialize(site, base, category_dir, category)
      super(site, base, category_dir, 'index.html')
      self.data['layout']      = 'category'
      self.data['category']    = category
      self.data['title']       = "All posts tagged: #{category}"
      self.data['description'] = "Tagged: #{category}"
    end
  end

  # class Site
  #   def write_category_index(category_dir, category)
  #     index = category_index(category_dir, category)
  #     index.render(self.layouts, site_payload)
  #     index.write(self.dest)
  #     self.pages << index
  # 
  #     Create an Atom-feed for each index.
  #     feed = CategoryFeed.new(self, self.source, category_dir, category)
  #     feed.render(self.layouts, site_payload)
  #     feed.write(self.dest)
  #     # Record the fact that this page has been added, otherwise Site::cleanup will remove it.
  #     self.pages << feed
  #   end
  # 
  #   def write_category_indexes
  #     self.categories.keys.each do |category|
  #       self.write_category_index(File.join('categories', category.to_url), category)
  #     end
  #   end
  #   
  #   private
  #   def category_index(category_dir, category)
  #     return CategoryIndex.new(self, self.source, category_dir, category)
  #   end
  # end


  class GenerateCategories < Generator
    safe true
    priority :low

    def generate(site)
      site.categories.keys.each do |category|
        site.pages << CategoryIndex.new(site, site.source, File.join('categories', category.to_url), category)
      end
    end
  end

  module Filters
    def category_links(categories)
      (categories || []).sort.map { |c| category_link(c) }.join(", ")
    end

    def category_link(category)
      "<a class='category' href='/categories/#{category.to_url}/'>#{category}</a>"
    end

    def date_to_html_string(date)
      result = '<span class="month">' + date.strftime('%b').upcase + '</span> '
      result += date.strftime('<span class="day">%d</span> ')
      result += date.strftime('<span class="year">%Y</span> ')
      result
    end
  end
end