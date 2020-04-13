# frozen_string_literal: true

require "helper"

class TestJekyllArchives < Minitest::Test
  context "the jekyll-archives plugin" do
    setup do
      @site = fixture_site("jekyll-archives" => {
        "enabled" => true,
      })
      @site.read
      @archives = Jekyll::Archives::Archives.new(@site.config)
    end

    should "generate archive pages by year" do
      @archives.generate(@site)
      assert archive_exists? @site, "2014/index.html"
      assert archive_exists? @site, "2013/index.html"
    end

    should "generate archive pages by month" do
      @archives.generate(@site)
      assert archive_exists? @site, "2014/08/index.html"
      assert archive_exists? @site, "2014/03/index.html"
    end

    should "generate archive pages by day" do
      @archives.generate(@site)
      assert archive_exists? @site, "2014/08/17/index.html"
      assert archive_exists? @site, "2013/08/16/index.html"
    end

    should "generate archive pages by tag" do
      @archives.generate(@site)
      assert archive_exists? @site, "tag/test-tag/index.html"
      assert archive_exists? @site, "tag/tagged/index.html"
      assert archive_exists? @site, "tag/new/index.html"
    end

    should "generate archive pages by category" do
      @archives.generate(@site)
      assert archive_exists? @site, "category/plugins/index.html"
    end

    should "generate archive pages with a layout" do
      @site.process
      assert_equal "Test", read_file("tag/test-tag/index.html")
    end
  end

  context "the jekyll-archives plugin with a custom slug mode" do
    setup do
      # slug mode other than those expected by Jekyll returns the given string after
      # downcasing it.
      @site = fixture_site("jekyll-archives" => {
        "slug_mode" => "raw",
        "enabled"   => true,
      })
      @site.read
      @archives = Jekyll::Archives::Archives.new(@site.config)
    end

    should "generate slugs using the mode specified" do
      @archives.generate(@site)
      assert archive_exists? @site, "category/💎/index.html"
    end
  end

  context "the jekyll-archives plugin with custom layout path" do
    setup do
      @site = fixture_site("jekyll-archives" => {
        "layout"  => "archive-too",
        "enabled" => true,
      })
      @site.process
    end

    should "use custom layout" do
      @site.process
      assert_equal "Test too", read_file("tag/test-tag/index.html")
    end
  end

  context "the jekyll-archives plugin with type-specific layout" do
    setup do
      @site = fixture_site(
        "jekyll-archives" => {
          "enabled" => true,
          "layouts" => {
            "year" => "archive-too",
          },
        }
      )
      @site.process
    end

    should "use custom layout for specific type only" do
      assert_equal "Test too", read_file("/2014/index.html")
      assert_equal "Test too", read_file("/2013/index.html")
      assert_equal "Test", read_file("/tag/test-tag/index.html")
    end
  end

  context "the jekyll-archives plugin with custom permalinks" do
    setup do
      @site = fixture_site(
        "jekyll-archives" => {
          "enabled"    => true,
          "permalinks" => {
            "year"     => "/year/:year/",
            "tag"      => "/tag-:name.html",
            "category" => "/category-:name.html",
          },
        }
      )
      @site.process
    end

    should "use the right permalink" do
      assert archive_exists? @site, "year/2014/index.html"
      assert archive_exists? @site, "year/2013/index.html"
      assert archive_exists? @site, "tag-test-tag.html"
      assert archive_exists? @site, "tag-new.html"
      assert archive_exists? @site, "category-plugins.html"
    end
  end

  context "the archives" do
    setup do
      @site = fixture_site("jekyll-archives" => {
        "enabled" => true,
      })
      @site.process
    end

    should "populate the {{ site.archives }} tag in Liquid" do
      assert_equal 16, read_file("length.html").to_i
    end
  end

  context "the jekyll-archives plugin with default config" do
    setup do
      @site = fixture_site
      @site.process
    end

    should "not generate any archives" do
      assert_equal 0, read_file("length.html").to_i
    end
  end

  context "the jekyll-archives plugin with enabled array" do
    setup do
      @site = fixture_site("jekyll-archives" => {
        "enabled" => ["tags"],
      })
      @site.process
    end

    should "generate the enabled archives" do
      assert archive_exists? @site, "tag/test-tag/index.html"
      assert archive_exists? @site, "tag/tagged/index.html"
      assert archive_exists? @site, "tag/new/index.html"
    end

    should "not generate the disabled archives" do
      assert !archive_exists?(@site, "2014/index.html")
      assert !archive_exists?(@site, "2014/08/index.html")
      assert !archive_exists?(@site, "2013/08/16/index.html")
      assert !archive_exists?(@site, "category/plugins/index.html")
    end
  end

  context "the jekyll-archives plugin" do
    setup do
      @site = fixture_site("jekyll-archives" => {
        "enabled" => true,
      })
      @site.process
      @archives = @site.config["archives"]
      @tag_archive = @archives.detect { |a| a.type == "tag" }
      @category_archive = @archives.detect { |a| a.type == "category" }
      @year_archive = @archives.detect { |a| a.type == "year" }
      @month_archive = @archives.detect { |a| a.type == "month" }
      @day_archive = @archives.detect { |a| a.type == "day" }
    end

    should "populate the title field in case of category or tag" do
      assert @tag_archive.title.is_a? String
      assert @category_archive.title.is_a? String
    end

    should "use nil for the title field in case of dates" do
      assert @year_archive.title.nil?
      assert @month_archive.title.nil?
      assert @day_archive.title.nil?
    end

    should "use nil for the date field in case of category or tag" do
      assert @tag_archive.date.nil?
      assert @category_archive.date.nil?
    end

    should "populate the date field with a Date in case of dates" do
      assert @year_archive.date.is_a? Date
      assert @month_archive.date.is_a? Date
      assert @day_archive.date.is_a? Date
    end
  end

  context "the jekyll-archives plugin with a non-hash config" do
    should "output a warning" do
      output = capture_output do
        site = fixture_site("jekyll-archives" => %w(apples oranges))
        site.read
        site.generate
      end
      assert_includes output, "Archives: Expected a hash but got [\"apples\", \"oranges\"]"
      assert_includes output, "Archives will not be generated for this site."

      output = capture_output do
        site = fixture_site("jekyll-archives" => nil)
        site.read
        site.generate
      end
      assert_includes output, "Archives: Expected a hash but got nil"
      assert_includes output, "Archives will not be generated for this site."
    end

    should "not generate archive pages" do
      capture_output do
        site = fixture_site("jekyll-archives" => nil)
        site.read
        site.generate
        assert_nil(site.pages.find { |p| p.is_a?(Jekyll::Archives::Archive) })
      end
    end

    should "be fine with a basic config" do
      output = capture_output do
        @site = fixture_site("title" => "Hello World")
        @site.read
        @site.generate
      end
      refute_includes output, "Archives: Expected a hash but got nil"
      assert_nil(@site.pages.find { |p| p.is_a?(Jekyll::Archives::Archive) })
    end
  end
end
