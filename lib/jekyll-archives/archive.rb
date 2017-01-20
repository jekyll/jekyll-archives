module Jekyll
  module Archives
    class Archive < Jekyll::Page

      attr_accessor :posts, :type, :slug

      # Attributes for Liquid templates
      ATTRIBUTES_FOR_LIQUID = %w(
        posts
        type
        title
        date
        name
        path
        url
        permalink
      ).freeze

      # Initialize a new Archive page
      #
      # site  - The Site object.
      # title - The name of the tag/category or a Hash of the year/month/day in case of date.
      #           e.g. { :year => 2014, :month => 08 } or "my-category" or "my-tag".
      # type  - The type of archive. Can be one of "year", "month", "day", "category", or "tag"
      # posts - The array of posts that belong in this archive.
      def initialize(site, title, type, posts)
        @site   = site
        @posts  = posts
        @type   = type
        @title  = title
        @config = site.config['jekyll-archives']

        # Generate slug if tag or category (taken from jekyll/jekyll/features/support/env.rb)
        if title.is_a? String
          @slug = Utils.slugify(title)
        end

        # Use ".html" for file extension and url for path
        @ext  = File.extname(relative_path)
        @path = relative_path
        @name = File.basename(relative_path, @ext)

        @data = {
          "layout" => layout
        }
        @content = ""
      end

      # The template of the permalink.
      #
      # Returns the template String.
      def template
        @config['permalinks'][type]
      end

      # The layout to use for rendering
      #
      # Returns the layout as a String
      def layout
        if @config['layouts'] && @config['layouts'][type]
          @config['layouts'][type]
        else
          @config['layout']
        end
      end

      # Returns a hash of URL placeholder names (as symbols) mapping to the
      # desired placeholder replacements. For details see "url.rb".
      def url_placeholders
        if @title.is_a? Hash
          @title.merge({ :type => @type })
        else
          { :name => @slug, :type => @type }
        end
      end

      # The generated relative url of this page. e.g. /about.html.
      #
      # Returns the String url.
      def url
        @url ||= URL.new({
          :template => template,
          :placeholders => url_placeholders,
          :permalink => nil
        }).to_s
      rescue ArgumentError
        raise ArgumentError.new "Template \"#{template}\" provided is invalid."
      end

      def permalink
        data && data.is_a?(Hash) && data['permalink']
      end

      # Add any necessary layouts to this post
      #
      # layouts      - The Hash of {"name" => "layout"}.
      # site_payload - The site payload Hash.
      #
      # Returns nothing.
      def render(layouts, site_payload)
        payload = Utils.deep_merge_hashes({
          "page" => to_liquid
        }, site_payload)

        do_layout(payload, layouts)
      end

      # Add dependencies for incremental mode
      def add_dependencies
        if defined? site.regenerator
          archive_path = site.in_dest_dir(relative_path)
          site.regenerator.add(archive_path)
          @posts.each do |post|
            site.regenerator.add_dependency(archive_path, post.path)
          end
        end
      end
      
      # Convert this Convertible's data to a Hash suitable for use by Liquid.
      #
      # Returns the Hash representation of this Convertible.
      def to_liquid(attrs = nil)
        further_data = Hash[(attrs || self.class::ATTRIBUTES_FOR_LIQUID).map { |attribute|
          [attribute, send(attribute)]
        }]

        Utils.deep_merge_hashes(data, further_data)
      end

      # Produce a title object suitable for Liquid based on type of archive.
      #
      # Returns a String (for tag and category archives) and nil for
      # date-based archives.
      def title
        if @title.is_a? String
          @title
        end
      end

      # Produce a date object if a date-based archive
      #
      # Returns a Date.
      def date
        if @title.is_a? Hash
          args = @title.values.map { |s| s.to_i }
          Date.new(*args)
        end
      end

      # Obtain the write path relative to the destination directory
      #
      # Returns the destination relative path String.
      def relative_path
        path = URL.unescape_path(url).gsub(/^\//, '')
        path = File.join(path, "index.html") if url =~ /\/$/
        path
      end

      def regenerate?
        if defined? site.regenerator
          site.regenerator.regenerate?(self)
        else
          true
        end
      end

      # Returns the object as a debug String.
      def inspect
        "#<Jekyll:Archive @type=#{@type.to_s} @title=#{@title} @data=#{@data.inspect}>"
      end

    end
  end
end
