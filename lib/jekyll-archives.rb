# frozen_string_literal: true

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
          "category" => "/category/:name/",
        },
      }.freeze

      def initialize(config = {})
        archives_config = config.fetch("jekyll-archives", {})
        if archives_config.is_a?(Hash)
          @config = Utils.deep_merge_hashes(DEFAULTS, archives_config)
        else
          @config = nil
          Jekyll.logger.warn "Archives:", "Expected a hash but got #{archives_config.inspect}"
          Jekyll.logger.warn "", "Archives will not be generated for this site."
        end
      end

      def generate(site)
        return if @config.nil?

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

      def tags
        @site.tags
      end

      def categories
        @site.categories
      end

      # Custom `post_attr_hash` method for years
      def years
        hash = Hash.new { |h, key| h[key] = [] }
        @posts.docs.each { |p| hash[p.date.strftime("%Y")] << p }
        hash.each_value { |posts| posts.sort!.reverse! }
        hash
      end

      def months(year_posts)
        hash = Hash.new { |h, key| h[key] = [] }
        year_posts.each { |p| hash[p.date.strftime("%m")] << p }
        hash.each_value { |posts| posts.sort!.reverse! }
        hash
      end

      def days(month_posts)
        hash = Hash.new { |h, key| h[key] = [] }
        month_posts.each { |p| hash[p.date.strftime("%d")] << p }
        hash.each_value { |posts| posts.sort!.reverse! }
        hash
      end
    end
  end
end
