lib = File.expand_path('../lib', __FILE__)
$LOAD_PATH.unshift(lib) unless $LOAD_PATH.include?(lib)
require 'jekyll-archives/version'

Gem::Specification.new do |s|
  s.name        = "jekyll-archives"
  s.summary     = "Post archives for Jekyll."
  s.description = "Automatically generate post archives by dates, tags, and categories."
  s.version     = Jekyll::Archives::VERSION
  s.authors     = ["Alfred Xing"]

  s.homepage    = "https://github.com/jekyll/jekyll-archives"
  s.licenses    = ["MIT"]
  s.files       = ["lib/jekyll-archives.rb", "lib/jekyll-archives/archive.rb"]

  s.add_dependency "jekyll", '~> 3.0.0.pre.beta8'

  s.add_development_dependency  'rake'
  s.add_development_dependency  'rdoc'
  s.add_development_dependency  'shoulda'
  s.add_development_dependency  'minitest'
end
