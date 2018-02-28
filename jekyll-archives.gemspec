# frozen_string_literal: true

lib = File.expand_path('lib', __dir__)
$LOAD_PATH.unshift(lib) unless $LOAD_PATH.include?(lib)
require 'jekyll-archives/version'

Gem::Specification.new do |s|
  s.name        = 'jekyll-archives'
  s.summary     = 'Post archives for Jekyll.'
  s.description = 'Automatically generate post archives by dates, tags, and categories.'
  s.version     = Jekyll::Archives::VERSION
  s.authors     = ['Alfred Xing']

  s.homepage    = 'https://github.com/jekyll/jekyll-archives'
  s.licenses    = ['MIT']

  all_files       = `git ls-files -z`.split("\x0")
  s.files         = all_files.grep(%r{^(lib)/})

  s.add_dependency 'jekyll', '>= 3.1'

  s.add_development_dependency 'minitest'
  s.add_development_dependency 'minitest-reporters'
  s.add_development_dependency 'rake'
  s.add_development_dependency 'rdoc'
  s.add_development_dependency 'rubocop', '0.51'
  s.add_development_dependency 'shoulda'
end
