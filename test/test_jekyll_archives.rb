require 'helper'

class TestJekyllArchives < Minitest::Test
  context "the jekyll-archives plugin" do
    setup do
      @site = fixture_site
      @site.read
      @archives = Jekyll::Archives.new(@site.config)
    end

    should "generate archive pages by year" do
      @archives.generate(@site)
      assert archive_exists? @site, "/archive/2014/"
      assert archive_exists? @site, "/archive/2013/"
    end

    should "generate archive pages by tag" do
      @archives.generate(@site)
      assert archive_exists? @site, "/tag/test/"
      assert archive_exists? @site, "/tag/tagged/"
      assert archive_exists? @site, "/tag/new/"
    end

    should "generate archive pages by category" do
      @archives.generate(@site)
      assert archive_exists? @site, "/category/plugins/"
    end

    should "generate archive pages with a layout" do
      @site.process
      assert_equal "Test", read_file("/tag/test/index.html")
    end
  end

  context "the jekyll-archives plugin with custom layout path" do
    setup do
      @site = fixture_site({
        "jekyll-archives" => {
          "layout" => "archive-too"
        }
      })
      @site.read
      @archives = Jekyll::Archives.new(@site.config)
    end

    should "use custom layout" do
      @site.process
      assert_equal "Test too", read_file("/tag/test/index.html")
    end
  end

  context "the jekyll-archives plugin with custom permalinks" do
    setup do
      @site = fixture_site({
        "jekyll-archives" => {
          "permalinks" => {
            "year" => "/:name/",
            "tag" => "/tag-:name.html",
            "category" => "/category-:name.html"
          }
        }
      })
      @site.read
      @archives = Jekyll::Archives.new(@site.config)
    end

    should "use the right permalink" do
      @site.process
      assert archive_exists? @site, "/2014/"
      assert archive_exists? @site, "/2013/"
      assert archive_exists? @site, "/tag-test.html"
      assert archive_exists? @site, "/tag-new.html"
      assert archive_exists? @site, "/category-plugins.html"
    end
  end
end
