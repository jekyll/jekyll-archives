# From jekyll/jekyll-mentions

require "rubygems"
require "bundler"

begin
  Bundler.setup(:default, :development, :test)
rescue Bundler::BundlerError => e
  $stderr.puts e.message
  $stderr.puts "Run `bundle install` to install missing gems"
  exit e.status_code
end

# Test task

require "rake"
require "rake/testtask"

Rake::TestTask.new(:test) do |test|
  test.libs << "lib" << "test"
  test.pattern = "test/**/test_*.rb"
end

task :default => "test"

# Release task

def name
  @name ||= File.basename(Dir["*.gemspec"].first, ".*")
end

def version
  Jekyll::Archives::VERSION
end

def gemspec_file
  "#{name}.gemspec"
end

def gem_file
  "#{name}-#{version}.gem"
end

desc "Release #{name} v#{version}"
task :release => :build do
  unless `git branch` =~ %r!^\* master$!
    puts "You must be on the master branch to release!"
    exit!
  end
  sh "git commit --allow-empty -m 'Release :gem: #{version}'"
  sh "git tag v#{version}"
  sh "git push origin master"
  sh "git push origin v#{version}"
  sh "gem push pkg/#{name}-#{version}.gem"
end

desc "Build #{name} v#{version} into pkg/"
task :build do
  mkdir_p "pkg"
  sh "gem build #{gemspec_file}"
  sh "mv #{gem_file} pkg"
end
