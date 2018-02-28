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

      def initialize(config = nil)
        @config = Utils.deep_merge_hashes(DEFAULTS, config.fetch("jekyll-archives", {}))
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

      def enabled?(archive)
        @config['enabled'] == true || @config['enabled'] == 'all' ||
          (@config['enabled'].is_a?(Array) && @config['enabled'].include?(archive))
      end

      # Read archive data from posts
      def read
        read_tags if enabled?('tags')
        read_categories if enabled?('categories')
        read_posts_per_year if enabled?('year')
        read_posts_per_month if enabled?('month')
        read_posts_per_day if enabled?('day')
      end

      def read_tags
        @archives += @site.post_attr_hash('tags').map do |title, posts|
          Archive.new(@site, title, 'tag', posts)
        end
      end

      def read_categories
        @archives += @site.post_attr_hash('categories').map do |title, posts|
          Archive.new(@site, title, 'category', posts)
        end
      end

      def read_posts_per_year
        @archives += @posts.docs.group_by { |p| p.date.year }.map do |year, posts_for_year|
          Archive.new(@site, { :year => year }, 'year', posts_for_year.sort.reverse)
        end
      end

      def read_posts_per_month
        @archives += @posts.docs.group_by { |p| [p.date.year, p.date.month] }.map do |(year, month), posts_for_month|
          Archive.new(@site, { :year => year, :month => month }, 'month', posts_for_month.sort.reverse)
        end
      end

      def read_posts_per_day
        @archives += @posts.docs.group_by { |p| [p.date.year, p.date.month, p.date.day] }.map do |(year, month, day), posts_for_day|
          Archive.new(@site, { :year => year, :month => month, :day => day }, 'day', posts_for_day.sort.reverse)
        end
      end
    end
  end
end
