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
        },
	"types"      => {
          "year"     => "year",
          "month"    => "month",
          "day"      => "day",
          "tag"      => "tag",
          "category" => "category"
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
        @posts = site.posts
        @archives = []

        @site.config["jekyll-archives"] = @config

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
        @config["types"].select do |id, type|
          type == "tag" && (enabled?("tags") || enabled?(id))
        end.keys.each do |id|
          tags.each do |title, posts|
            @archives << Archive.new(@site, title, id, posts)
          end
        end
      end

      def read_categories
        @config["types"].select do |id, type|
          type == "category" && (enabled?("categories") || enabled?(id))
        end.keys.each do |id|
          categories.each do |title, posts|
            @archives << Archive.new(@site, title, id, posts)
          end
        end
      end

      def read_dates
        ys = @config["types"].select do |id, type|
          type == "year" && (enabled?("years") || enabled?(id))
        end.keys
        ms = @config["types"].select do |id, type|
          type == "month" && (enabled?("months") || enabled?(id))
        end.keys
        ds = @config["types"].select do |id, type|
          type == "day" && (enabled?("days") || enabled?(id))
        end.keys
        years.each do |year, posts|
          ys.each do |id|
            @archives << Archive.new(@site, { :year => year }, id, posts)
          end
          months(posts).each do |month, posts|
            ms.each do |id|
              @archives << Archive.new(@site, { :year => year, :month => month }, id, posts)
            end
            days(posts).each do |day, posts|
              ds.each do |id|
                @archives << Archive.new(@site, { :year => year, :month => month, :day => day }, id, posts)
              end
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

      def tags
        @site.post_attr_hash("tags")
      end

      def categories
        @site.post_attr_hash("categories")
      end

      # Custom `post_attr_hash` method for years
      def years
        hash = Hash.new { |h, key| h[key] = [] }

        # In Jekyll 3, Collection#each should be called on the #docs array directly.
        if Jekyll::VERSION >= "3.0.0"
          @posts.docs.each { |p| hash[p.date.strftime("%Y")] << p }
        else
          @posts.each { |p| hash[p.date.strftime("%Y")] << p }
        end
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
