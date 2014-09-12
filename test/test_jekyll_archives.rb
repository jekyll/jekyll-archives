require 'helper'

class TestJekyllArchives < Minitest::Test
  context "the jekyll-archives plugin" do
    setup do
      @site = fixture_site({
        "jekyll-archives" => {
          "enabled" => true
        }
      })
      @site.read
      @archives = Jekyll::Archives.new(@site.config)
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

  context "the jekyll-archives plugin with custom layout path" do
    setup do
      @site = fixture_site({
        "jekyll-archives" => {
          "layout" => "archive-too",
          "enabled" => true
        }
      })
      @site.read
      @archives = Jekyll::Archives.new(@site.config)
    end

    should "use custom layout" do
      @site.process
      assert_equal "Test too", read_file("tag/test-tag/index.html")
    end
  end

  context "the jekyll-archives plugin with custom permalinks" do
    setup do
      @site = fixture_site({
        "jekyll-archives" => {
          "enabled" => true,
          "permalinks" => {
            "year" => "/year/:year/",
            "tag" => "/tag-:name.html",
            "category" => "/category-:name.html"
          }
        }
      })
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
      @site = fixture_site({
        "jekyll-archives" => {
          "enabled" => true
        }
      })
      @site.process
    end

    should "populate the {{ site.archives }} tag in Liquid" do
      assert_equal 12, read_file("length.html").to_i
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
      @site = fixture_site({
        "jekyll-archives" => {
          "enabled" => ["tags"]
        }
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
end
