# frozen_string_literal: true

require "helper"

class TestJekyllArchive < Minitest::Test
  context "the generated archive page" do
    setup do
      @site = fixture_site("jekyll-archives" => {
        "enabled" => true,
      })
      @site.read
      Jekyll::Archives::Archives.new(@site.config).generate(@site)
      @archives = @site.config["archives"]
    end

    should "expose attributes to Liquid templates" do
      archive = @archives.find { |a| a.type == "tag" }
      archive.posts = []
      expected = {
        "layout"    => "archive",
        "posts"     => [],
        "type"      => "tag",
        "title"     => "Test Tag",
        "date"      => nil,
        "name"      => "index",
        "path"      => "tag/test-tag/index.html",
        "url"       => "/tag/test-tag/",
        "permalink" => nil,
      }

      assert_equal expected, archive.to_liquid.to_h

      archive = @archives.find { |a| a.type == "category" }
      archive.posts = []
      expected = {
        "layout"    => "archive",
        "posts"     => [],
        "type"      => "category",
        "title"     => "plugins",
        "date"      => nil,
        "name"      => "index",
        "path"      => "category/plugins/index.html",
        "url"       => "/category/plugins/",
        "permalink" => nil,
      }

      assert_equal expected, archive.to_liquid.to_h

      archive = @archives.find { |a| a.type == "year" }
      archive.posts = []
      expected = {
        "layout"    => "archive",
        "posts"     => [],
        "type"      => "year",
        "title"     => nil,
        "date"      => archive.date,
        "name"      => "index",
        "path"      => "2013/index.html",
        "url"       => "/2013/",
        "permalink" => nil,
      }

      assert_equal expected, archive.to_liquid.to_h

      archive = @archives.find { |a| a.type == "month" }
      archive.posts = []
      expected = {
        "layout"    => "archive",
        "posts"     => [],
        "type"      => "month",
        "title"     => nil,
        "date"      => archive.date,
        "name"      => "index",
        "path"      => "2013/08/index.html",
        "url"       => "/2013/08/",
        "permalink" => nil,
      }

      assert_equal expected, archive.to_liquid.to_h

      archive = @archives.find { |a| a.type == "day" }
      archive.posts = []
      expected = {
        "layout"    => "archive",
        "posts"     => [],
        "type"      => "day",
        "title"     => nil,
        "date"      => archive.date,
        "name"      => "index",
        "path"      => "2013/08/16/index.html",
        "url"       => "/2013/08/16/",
        "permalink" => nil,
      }

      assert_equal expected, archive.to_liquid.to_h
    end
  end

  context "the generated archive page preconfigured with front matter defaults" do
    setup do
      site = fixture_site(
        "jekyll-archives" => {
          "enabled" => true,
        },
        "defaults"        => [
          {
            "scope"  => {
              "type" => "category",
            },
            "values" => {
              "author_profile" => true,
              "sidebar"        => false,
            },
          },
          {
            "scope"  => {
              "type" => "day",
            },
            "values" => {
              "author_profile" => false,
              "sidebar"        => true,
            },
          },
        ]
      )
      site.read
      Jekyll::Archives::Archives.new(site.config).generate(site)
      @archives = site.config["archives"]
    end

    should "expose all attributes to Liquid templates" do
      archive = @archives.find { |a| a.type == "category" }
      archive.posts = []
      expected = {
        "author_profile" => true,
        "sidebar"        => false,
        "layout"         => "archive",
        "posts"          => [],
        "type"           => "category",
        "title"          => "plugins",
        "date"           => nil,
        "name"           => "index",
        "path"           => "category/plugins/index.html",
        "url"            => "/category/plugins/",
        "permalink"      => nil,
      }

      assert_equal expected, archive.to_liquid.to_h

      archive = @archives.find { |a| a.type == "day" }
      archive.posts = []
      expected = {
        "author_profile" => false,
        "sidebar"        => true,
        "layout"         => "archive",
        "posts"          => [],
        "type"           => "day",
        "title"          => nil,
        "date"           => archive.date,
        "name"           => "index",
        "path"           => "2013/08/16/index.html",
        "url"            => "/2013/08/16/",
        "permalink"      => nil,
      }

      assert_equal expected, archive.to_liquid.to_h
    end
  end
end
