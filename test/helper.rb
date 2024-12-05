# frozen_string_literal: true

# Taken from jekyll/jekyll-mentions
# (Copyright (c) 2014 GitHub, Inc. Licensened under the MIT).

require "rubygems"
require "minitest/autorun"
require "shoulda/context"

require_relative "../lib/jekyll-archives"

SOURCE_DIR = File.expand_path("source", __dir__)
DEST_DIR   = File.expand_path("destination", __dir__)

module Minitest
  class Test
    def fixture_site(config = {})
      Jekyll::Site.new(
        Jekyll::Utils.deep_merge_hashes(
          Jekyll::Utils.deep_merge_hashes(
            Jekyll::Configuration::DEFAULTS,
            "source"      => SOURCE_DIR,
            "destination" => DEST_DIR
          ),
          config
        )
      )
    end

    def archive_exists?(site, path)
      site.config["archives"].any? { |archive| archive.path == path }
    end

    def read_file(path)
      read_path = File.join(DEST_DIR, path)
      return false unless File.exist?(read_path)

      File.read(read_path).strip
    end

    def capture_output(level = :debug)
      buffer = StringIO.new
      Jekyll.logger = Logger.new(buffer)
      Jekyll.logger.log_level = level
      yield
      buffer.rewind
      buffer.string.to_s
    ensure
      Jekyll.logger = Logger.new(StringIO.new, :error)
    end
  end
end
