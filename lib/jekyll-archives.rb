require 'jekyll'

module Jekyll
  module Archives
    # Internal requires
    autoload :Archive, 'jekyll-archives/archive'
    autoload :VERSION, 'jekyll-archives/version'

    class Archives < Jekyll::Generator
      safe true

      DEFAULTS = {
        'layout' => 'archive',
        'enabled' => [],
        'permalinks' => {
          'year' => '/:year/',
          'month' => '/:year/:month/',
          'day' => '/:year/:month/:day/',
          'tag' => '/tag/:name/',
          'category' => '/category/:name/'
        }
      }

      def initialize(config = nil)
        if config['jekyll-archives'].nil?
          @config = DEFAULTS
        else
          @config = Utils.deep_merge_hashes(DEFAULTS, config['jekyll-archives'])
        end
      end

      def generate(site)
        puts "       - Generating Archives..."
        
        @site = site
        @posts = site.posts
        @archives = []

        @site.config['jekyll-archives'] = @config

        read
        render
        write

        @site.keep_files ||= []
        @archives.each do |archive|
          @site.keep_files << archive.relative_path
        end
        @site.config["archives"] = @archives
      end

      # Read archive data from posts
      def read
        read_tags
        read_categories
        read_dates
      end

      def read_tags
        if enabled? "tags"
          tags.each do |title, posts|
            @archives << Archive.new(@site, title, "tag", posts)
          end
        end
      end

      def read_categories
        if enabled? "categories"
          categories.each do |title, posts|
            @archives << Archive.new(@site, title, "category", posts)
          end
        end
      end

      def read_dates
        years.each do |year, posts|
          @archives << Archive.new(@site, { :year => year }, "year", posts) if enabled? "year"
          months(posts).each do |month, posts|
            @archives << Archive.new(@site, { :year => year, :month => month }, "month", posts) if enabled? "month"
            days(posts).each do |day, posts|
              @archives << Archive.new(@site, { :year => year, :month => month, :day => day }, "day", posts) if enabled? "day"
            end
          end
        end
      end

      # Checks if archive type is enabled in config
      def enabled?(archive)
        @config["enabled"] == true || @config["enabled"] == "all" || if @config["enabled"].is_a? Array
          @config["enabled"].include? archive
        end
      end

      # Renders the archives into the layouts
      def render
        payload = @site.site_payload
        @archives.each do |archive|
          archive.render(@site.layouts, payload)
        end
      end

      # Write archives to their destination
      def write
        @archives.each do |archive|
          archive.write(@site.dest)
        end
      end

      # Construct a Hash of Posts indexed by the specified Post attribute.
      #
      # post_attr - The String name of the Post attribute.
      #
      # Examples
      #
      #   post_attr_hash('categories')
      #   # => { 'tech' => [<Post A>, <Post B>],
      #   #      'ruby' => [<Post B>] }
      #
      # Returns the Hash: { attr => posts } where
      #   attr  - One of the values for the requested attribute.
      #   posts - The Array of Posts with the given attr value.
      #
      # Taken from jekyll/jekyll (Copyright (c) 2014 Tom Preston-Werner under the MIT).
      def post_attr_hash(post_attr)
        # Build a hash map based on the specified post attribute ( post attr =>
        # array of posts ) then sort each array in reverse order.
        hash = Hash.new { |h, key| h[key] = [] }
        @posts.each { |p| p.send(post_attr.to_sym).each { |t| hash[t] << p } }
        hash.values.each { |posts| posts.sort!.reverse! }
        hash
      end

      def tags
        post_attr_hash('tags')
      end

      def categories
        post_attr_hash('categories')
      end

      # Custom `post_attr_hash` method for years
      def years
        hash = Hash.new { |h, key| h[key] = [] }
        @posts.each { |p| hash[p.date.strftime("%Y")] << p }
        hash.values.each { |posts| posts.sort!.reverse! }
        hash
      end

      def months(year_posts)
        hash = Hash.new { |h, key| h[key] = [] }
        year_posts.each { |p| hash[p.date.strftime("%m")] << p }
        hash.values.each { |posts| posts.sort!.reverse! }
        hash
      end

      def days(month_posts)
        hash = Hash.new { |h, key| h[key] = [] }
        month_posts.each { |p| hash[p.date.strftime("%d")] << p }
        hash.values.each { |posts| posts.sort!.reverse! }
        hash
      end
    end
  end
end
