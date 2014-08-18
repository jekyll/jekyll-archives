require 'jekyll'

module Jekyll
  # Internal requires
  autoload :Archive, 'jekyll-archives/archive'

  class Archives < Jekyll::Generator
    safe true

    DEFAULTS = {
      'layout' => 'archive',
      'permalinks' => {
        'year' => '/archive/:name/',
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
      tags.each do |tag|
        @archives << Archive.new(@site, tag[1], "tag", tag[0])
      end
      categories.each do |category|
        @archives << Archive.new(@site, category[1], "category", category[0])
      end
      years.each do |year|
        @archives << Archive.new(@site, year[1], "year", year[0])
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
      @posts.each { |p| hash[p.date.year.to_s] << p }
      hash.values.each { |posts| posts.sort!.reverse! }
      hash
    end
  end
end
