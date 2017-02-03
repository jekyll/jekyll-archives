require "jekyll"

module Jekyll
  module Archives
    # Internal requires
    autoload :Archive, "jekyll-archives/archive"
    autoload :VERSION, "jekyll-archives/version"

    class Archives < Jekyll::Generator
      safe true

      DEFAULTS = {
        "layout"     => "archive",
        "enabled"    => [],
        "permalinks" => {
          "year"     => "/:year/",
          "month"    => "/:year/:month/",
          "day"      => "/:year/:month/:day/",
          "tag"      => "/tag/:name/",
          "category" => "/category/:name/"
        }
      }.freeze

      def initialize(config = nil)
        @config = if config["jekyll-archives"].nil?
                    DEFAULTS
                  else
                    Utils.deep_merge_hashes(DEFAULTS, config["jekyll-archives"])
                  end
      end

      def generate(site)
        @site = site

        # Archive the posts collection by default
        @site.posts.metadata['archive'] = true

        @archives = []
        @site.config['jekyll-archives'] = @config

        read
        @site.pages.concat(@archives)
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

      def date_attr_hash(date_format, date_posts)
        hash = Hash.new { |h, key| h[key] = [] }

        date_posts.each do |p|
          hash[p.date.strftime(date_format)] << p
        end

        hash.values.each { |posts| posts.sort!.reverse! }
        hash
      end

      def doc_attr_hash(doc_attr)
        hash = Hash.new { |h, key| h[key] = [] }

        @site.collections.each do |name, collection|
          if collection.metadata['archive']
            collection.docs.each do |d|
              case doc_attr
              when 'tags'
                d.data['tags'].each { |t| hash[t] << d } if d.data['tags']
              when 'categories'
                d.data['categories'].each { |t| hash[t] << d } if d.data['categories']
              when 'years'
                hash[d.date.strftime("%Y")] << d
              end
            end
          end
        end

        hash.values.each { |posts| posts.sort!.reverse! }
        hash
      end

      def tags
        if Jekyll::VERSION >= '3.0.0'
          doc_attr_hash('tags')
        else
          @site.post_attr_hash('tags')
        end
      end

      def categories
        if Jekyll::VERSION >= '3.0.0'
          doc_attr_hash('categories')
        else
          @site.post_attr_hash('categories')
        end
      end

      def years
        if Jekyll::VERSION >= '3.0.0'
          doc_attr_hash('years')
        else
          date_attr_hash("%Y", @site.posts)
        end
      end

      def months(year_posts)
        date_attr_hash("%m", year_posts)
      end

      def days(month_posts)
        date_attr_hash("%d", month_posts)
      end
    end
  end
end
