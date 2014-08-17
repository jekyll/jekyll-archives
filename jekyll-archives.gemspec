Gem::Specification.new do |s|
  s.name        = "jekyll-archives"
  s.summary     = "Post archives for Jekyll."
  s.description = "Automatically generate post archives by dates, tags, and categories."
  s.version     = "0.1.0"
  s.authors     = ["Alfred Xing"]
  s.email       = "support@github.com"

  s.homepage    = "https://github.com/alfredxing/jekyll-archives"
  s.licenses    = ["MIT"]
  s.files       = ["lib/jekyll-archives.rb", "lib/jekyll-archives/archive.rb"]

  s.add_dependency "jekyll", '~> 2.0'

  s.add_development_dependency  'rake'
  s.add_development_dependency  'rdoc'
  s.add_development_dependency  'shoulda'
  s.add_development_dependency  'minitest'
end
