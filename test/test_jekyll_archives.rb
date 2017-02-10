require "helper"

class TestJekyllArchives < Minitest::Test
  context "the jekyll-archives plugin" do
    setup do
      @site = fixture_site("jekyll-archives" => {
        "enabled" => true
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

  context "the jekyll-archives plugin with custom layout path" do
    setup do
      @site = fixture_site("jekyll-archives" => {
        "layout"  => "archive-too",
        "enabled" => true
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
      @site = fixture_site({
        "jekyll-archives" => {
          "enabled" => true,
          "layouts" => {
            "year" => "archive-too"
          }
        }
      })
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
      @site = fixture_site({
        "jekyll-archives" => {
          "enabled"    => true,
          "permalinks" => {
            "year"     => "/year/:year/",
            "tag"      => "/tag-:name.html",
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
      @site = fixture_site("jekyll-archives" => {
        "enabled" => true
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
      @site = fixture_site("jekyll-archives" => {
        "enabled" => ["tags"]
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
        "enabled" => true
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

  context "the jekyll-archives plugin with an enabled non-default tag archive" do
    setup do
      @site = fixture_site("jekyll-archives" => {
        "enabled" => ["foo"],
	"types" => { "foo" => "tag"},
	"permalinks" => { "foo" => "/t/:name/"}
      })
      @site.process
    end

    should "generate the enabled archives" do
      assert archive_exists? @site, "t/test-tag/index.html"
      assert archive_exists? @site, "t/tagged/index.html"
      assert archive_exists? @site, "t/new/index.html"
    end

    should "not generate disabled archives" do
      assert !archive_exists?(@site, "2014/index.html")
      assert !archive_exists?(@site, "2014/08/index.html")
      assert !archive_exists?(@site, "2013/08/16/index.html")
      assert !archive_exists?(@site, "category/plugins/index.html")
      assert !archive_exists?(@site, "tag/test-tag/index.html")
      assert !archive_exists?(@site, "tag/tagged/index.html")
      assert !archive_exists?(@site, "tag/new/index.html")
    end
  end

  context "the jekyll-archives plugin with all tags enabled and non-default tag archive" do
    setup do
      @site = fixture_site("jekyll-archives" => {
        "enabled" => ["tags"],
	"types" => { "foo" => "tag"},
	"permalinks" => { "foo" => "/t/:name/"}
      })
      @site.process
    end

    should "generate the enabled archives" do
      assert archive_exists? @site, "tag/test-tag/index.html"
      assert archive_exists? @site, "tag/tagged/index.html"
      assert archive_exists? @site, "tag/new/index.html"
      assert archive_exists? @site, "t/test-tag/index.html"
      assert archive_exists? @site, "t/tagged/index.html"
      assert archive_exists? @site, "t/new/index.html"
    end

    should "not generate disabled archives" do
      assert !archive_exists?(@site, "2014/index.html")
      assert !archive_exists?(@site, "2014/08/index.html")
      assert !archive_exists?(@site, "2013/08/16/index.html")
      assert !archive_exists?(@site, "category/plugins/index.html")
    end
  end

  context "the jekyll-archives plugin with an enabled non-default category archive" do
    setup do
      @site = fixture_site("jekyll-archives" => {
        "enabled" => ["foo"],
	"types" => { "foo" => "category"},
	"permalinks" => { "foo" => "/c/:name/"}
      })
      @site.process
    end

    should "generate the enabled archives" do
      assert archive_exists?(@site, "c/plugins/index.html")
    end

    should "not generate disabled archives" do
      assert !archive_exists?(@site, "2014/index.html")
      assert !archive_exists?(@site, "2014/08/index.html")
      assert !archive_exists?(@site, "2013/08/16/index.html")
      assert !archive_exists?(@site, "category/plugins/index.html")
      assert !archive_exists?(@site, "tag/test-tag/index.html")
      assert !archive_exists?(@site, "tag/tagged/index.html")
      assert !archive_exists?(@site, "tag/new/index.html")
    end
  end

  context "the jekyll-archives plugin with all categories enabled and non-default category archive" do
    setup do
      @site = fixture_site("jekyll-archives" => {
        "enabled" => ["categories"],
	"types" => { "foo" => "category"},
	"permalinks" => { "foo" => "/c/:name/"}
      })
      @site.process
    end

    should "generate the enabled archives" do
      assert archive_exists?(@site, "category/plugins/index.html")
      assert archive_exists?(@site, "c/plugins/index.html")
    end

    should "not generate disabled archives" do
      assert !archive_exists?(@site, "2014/index.html")
      assert !archive_exists?(@site, "2014/08/index.html")
      assert !archive_exists?(@site, "2013/08/16/index.html")
      assert !archive_exists?(@site, "tag/test-tag/index.html")
      assert !archive_exists?(@site, "tag/tagged/index.html")
      assert !archive_exists?(@site, "tag/new/index.html")
    end
  end

  context "the jekyll-archives plugin with an enabled non-default year archive" do
    setup do
      @site = fixture_site("jekyll-archives" => {
        "enabled" => ["foo"],
	"types" => { "foo" => "year"},
	"permalinks" => { "foo" => "/y/:year/"}
      })
      @site.process
    end

    should "generate the enabled archives" do
      assert archive_exists?(@site, "y/2014/index.html")
    end

    should "not generate disabled archives" do
      assert !archive_exists?(@site, "2014/index.html")
      assert !archive_exists?(@site, "2014/08/index.html")
      assert !archive_exists?(@site, "2013/08/16/index.html")
      assert !archive_exists?(@site, "category/plugins/index.html")
      assert !archive_exists?(@site, "tag/test-tag/index.html")
      assert !archive_exists?(@site, "tag/tagged/index.html")
      assert !archive_exists?(@site, "tag/new/index.html")
    end
  end

  context "the jekyll-archives plugin with all years enabled and non-default year archive" do
    setup do
      @site = fixture_site("jekyll-archives" => {
        "enabled" => ["years"],
	"types" => { "foo" => "year"},
	"permalinks" => { "foo" => "/y/:year/"}
      })
      @site.process
    end

    should "generate the enabled archives" do
      assert archive_exists?(@site, "2014/index.html")
      assert archive_exists?(@site, "y/2014/index.html")
    end

    should "not generate disabled archives" do
      assert !archive_exists?(@site, "2014/08/index.html")
      assert !archive_exists?(@site, "2013/08/16/index.html")
      assert !archive_exists?(@site, "category/plugins/index.html")
      assert !archive_exists?(@site, "tag/test-tag/index.html")
      assert !archive_exists?(@site, "tag/tagged/index.html")
      assert !archive_exists?(@site, "tag/new/index.html")
    end
  end

  context "the jekyll-archives plugin with an enabled non-default month archive" do
    setup do
      @site = fixture_site("jekyll-archives" => {
        "enabled" => ["foo"],
	"types" => { "foo" => "month"},
	"permalinks" => { "foo" => "/m/:year/:month/"}
      })
      @site.process
    end

    should "generate the enabled archives" do
      assert archive_exists?(@site, "m/2014/08/index.html")
    end

    should "not generate disabled archives" do
      assert !archive_exists?(@site, "2014/index.html")
      assert !archive_exists?(@site, "2014/08/index.html")
      assert !archive_exists?(@site, "2013/08/16/index.html")
      assert !archive_exists?(@site, "category/plugins/index.html")
      assert !archive_exists?(@site, "tag/test-tag/index.html")
      assert !archive_exists?(@site, "tag/tagged/index.html")
      assert !archive_exists?(@site, "tag/new/index.html")
    end
  end

  context "the jekyll-archives plugin with all months enabled and non-default month archive" do
    setup do
      @site = fixture_site("jekyll-archives" => {
        "enabled" => ["months"],
	"types" => { "foo" => "month"},
	"permalinks" => { "foo" => "/m/:year/:month/"}
      })
      @site.process
    end

    should "generate the enabled archives" do
      assert archive_exists?(@site, "2014/08/index.html")
      assert archive_exists?(@site, "m/2014/08/index.html")
    end

    should "not generate disabled archives" do
      assert !archive_exists?(@site, "2014/index.html")
      assert !archive_exists?(@site, "2013/08/16/index.html")
      assert !archive_exists?(@site, "category/plugins/index.html")
      assert !archive_exists?(@site, "tag/test-tag/index.html")
      assert !archive_exists?(@site, "tag/tagged/index.html")
      assert !archive_exists?(@site, "tag/new/index.html")
    end
  end

  context "the jekyll-archives plugin with an enabled non-default day archive" do
    setup do
      @site = fixture_site("jekyll-archives" => {
        "enabled" => ["foo"],
	"types" => { "foo" => "day"},
	"permalinks" => { "foo" => "/d/:year/:month/:day/"}
      })
      @site.process
    end

    should "generate the enabled archives" do
      assert archive_exists?(@site, "d/2013/08/16/index.html")
    end

    should "not generate disabled archives" do
      assert !archive_exists?(@site, "2014/index.html")
      assert !archive_exists?(@site, "2014/08/index.html")
      assert !archive_exists?(@site, "2013/08/16/index.html")
      assert !archive_exists?(@site, "category/plugins/index.html")
      assert !archive_exists?(@site, "tag/test-tag/index.html")
      assert !archive_exists?(@site, "tag/tagged/index.html")
      assert !archive_exists?(@site, "tag/new/index.html")
    end
  end

  context "the jekyll-archives plugin with all days enabled and non-default day archive" do
    setup do
      @site = fixture_site("jekyll-archives" => {
        "enabled" => ["days"],
	"types" => { "foo" => "day"},
	"permalinks" => { "foo" => "/d/:year/:month/:day/"}
      })
      @site.process
    end

    should "generate the enabled archives" do
      assert archive_exists?(@site, "2013/08/16/index.html")
      assert archive_exists?(@site, "d/2013/08/16/index.html")
    end

    should "not generate disabled archives" do
      assert !archive_exists?(@site, "2014/index.html")
      assert !archive_exists?(@site, "2014/08/index.html")
      assert !archive_exists?(@site, "category/plugins/index.html")
      assert !archive_exists?(@site, "tag/test-tag/index.html")
      assert !archive_exists?(@site, "tag/tagged/index.html")
      assert !archive_exists?(@site, "tag/new/index.html")
    end
  end

  context "the jekyll-archives plugin with non-default archives defined and only default archives enabled" do
    setup do
      @site = fixture_site("jekyll-archives" => {
        "enabled" => ["tag", "category", "year", "month", "day"],
	"types" => {
		"t" => "tag",
		"c" => "category",
		"y" => "year",
		"m" => "month",
		"d" => "day"
	},
	"permalinks" => {
		"t" => "/t/:name/",
		"c" => "/c/:name/",
		"y" => "/y/:year/",
		"m" => "/m/:year/:month/",
		"d" => "/d/:year/:month/:day/"
	}
      })
      @site.process
    end

    should "generate the enabled archives" do
      assert archive_exists?(@site, "2014/index.html")
      assert archive_exists?(@site, "2014/08/index.html")
      assert archive_exists?(@site, "2013/08/16/index.html")
      assert archive_exists?(@site, "category/plugins/index.html")
      assert archive_exists?(@site, "tag/test-tag/index.html")
      assert archive_exists?(@site, "tag/tagged/index.html")
      assert archive_exists?(@site, "tag/new/index.html")
    end

    should "not generate disabled archives" do
      assert !archive_exists?(@site, "y/2014/index.html")
      assert !archive_exists?(@site, "m/2014/08/index.html")
      assert !archive_exists?(@site, "d/2013/08/16/index.html")
      assert !archive_exists?(@site, "c/plugins/index.html")
      assert !archive_exists?(@site, "t/test-tag/index.html")
      assert !archive_exists?(@site, "t/tagged/index.html")
      assert !archive_exists?(@site, "t/new/index.html")
    end
  end

  context "the jekyll-archives plugin with non-default archives defined and all enabled" do
    setup do
      @site = fixture_site("jekyll-archives" => {
        "enabled" => "all",
	"types" => {
		"t" => "tag",
		"c" => "category",
		"y" => "year",
		"m" => "month",
		"d" => "day"
	},
	"permalinks" => {
		"t" => "/t/:name/",
		"c" => "/c/:name/",
		"y" => "/y/:year/",
		"m" => "/m/:year/:month/",
		"d" => "/d/:year/:month/:day/"
	}
      })
      @site.process
    end

    should "generate the default archives" do
      assert archive_exists?(@site, "2014/index.html")
      assert archive_exists?(@site, "2014/08/index.html")
      assert archive_exists?(@site, "2013/08/16/index.html")
      assert archive_exists?(@site, "category/plugins/index.html")
      assert archive_exists?(@site, "tag/test-tag/index.html")
      assert archive_exists?(@site, "tag/tagged/index.html")
      assert archive_exists?(@site, "tag/new/index.html")
    end

    should "generate the custom archives" do
      assert archive_exists?(@site, "y/2014/index.html")
      assert archive_exists?(@site, "m/2014/08/index.html")
      assert archive_exists?(@site, "d/2013/08/16/index.html")
      assert archive_exists?(@site, "c/plugins/index.html")
      assert archive_exists?(@site, "t/test-tag/index.html")
      assert archive_exists?(@site, "t/tagged/index.html")
      assert archive_exists?(@site, "t/new/index.html")
    end
  end

  context "the jekyll-archives plugin with enabled non-default archives width missing permalinks" do
    setup do
      @site = fixture_site("jekyll-archives" => {
        "enabled" => "all",
	"types" => {
		"foo-t" => "tag",
		"foo-c" => "category",
		"foo-y" => "year",
		"foo-m" => "month",
		"foo-d" => "day"
	},
      })
      @site.process
    end

    should "generate the custom archives with the fallback path" do
      assert archive_exists?(@site, "foo-y/2014/index.html")
      assert archive_exists?(@site, "foo-m/2014/08/index.html")
      assert archive_exists?(@site, "foo-d/2013/08/16/index.html")
      assert archive_exists?(@site, "foo-c/plugins/index.html")
      assert archive_exists?(@site, "foo-t/test-tag/index.html")
      assert archive_exists?(@site, "foo-t/tagged/index.html")
      assert archive_exists?(@site, "foo-t/new/index.html")
    end
  end
end
