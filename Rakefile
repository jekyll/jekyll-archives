# frozen_string_literal: true

require "rubygems"
require "bundler"
require "bundler/gem_tasks"

begin
  Bundler.setup(:default, :development, :test)
rescue Bundler::BundlerError => e
  warn e.message
  warn "Run `bundle install` to install missing gems"
  exit e.status_code
end

# Test task

require "rake"
require "rake/testtask"

Rake::TestTask.new(:test) do |test|
  test.libs << "lib" << "test"
  test.pattern = "test/**/test_*.rb"
  test.warning = false
end

task :default => "test"
