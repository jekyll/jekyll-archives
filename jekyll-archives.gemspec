# frozen_string_literal: true

require_relative "lib/jekyll-archives/version"

Gem::Specification.new do |s|
  s.name        = "jekyll-archives"
  s.summary     = "Post archives for Jekyll."
  s.description = "Automatically generate post archives by dates, tags, and categories."
  s.version     = Jekyll::Archives::VERSION
  s.authors     = ["Alfred Xing"]

  s.homepage    = "https://github.com/jekyll/jekyll-archives"
  s.licenses    = ["MIT"]

  all_files     = `git ls-files -z`.split("\x0")
  s.files       = all_files.grep(%r!^(lib)/!).push("LICENSE")

  s.required_ruby_version = ">= 2.7.0"

  s.add_dependency "jekyll", ">= 3.6", "< 5.0"
end
