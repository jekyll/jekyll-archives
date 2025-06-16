# frozen_string_literal: true

module Jekyll
  module Archives
    class PageDrop < Jekyll::Drops::Drop
      extend Forwardable

      mutable false

      def_delegators :@obj, :posts, :type, :title, :date, :name, :path, :url, :permalink
      private def_delegators :@obj, :site, :relative_path, :data

      def fallback_data
        Jekyll::Utils.deep_merge_hashes(
          data, site.frontmatter_defaults.all(relative_path, type)
        )
      end
      private :fallback_data
    end
  end
end
