# encoding: utf-8

require 'rubygems'
require 'bundler'
begin
  Bundler.setup(:default, :development)
rescue Bundler::BundlerError => e
  $stderr.puts e.message
  $stderr.puts "Run `bundle install` to install missing gems"
  exit e.status_code
end
require 'rake'

require 'jeweler'
Jeweler::Tasks.new do |gem|
  # gem is a Gem::Specification... see http://docs.rubygems.org/read/chapter/20 for more options
  gem.name = "alphasign"
  gem.homepage = "http://github.com/jon-proulx/alphasign"
  gem.license = "MIT"
  gem.summary = "A gem for communicating with LED signs using Alpha Sign Protocol "
  gem.description = <<-EOF
Alphasign is handles communication with LED signs using the
Alpha Sign Protocol. These include Alpha signs and Betabrite signs
by Adaptive Micro Systems, maybe others too, YMMV.

This release handles writing "text files" and "string" files to the
sign over rs232 serial port, using a fixed memory configuration.  Upcoming
releases will add "dots picture" files and memory user accesable memory 
file configuration.
EOF
  gem.email = "jon@jonproulx.com"
  gem.authors = ["Jon Proulx"]
  # dependencies defined in Gemfile
end
Jeweler::RubygemsDotOrgTasks.new

require 'rake/testtask'
Rake::TestTask.new(:test) do |test|
  test.libs << 'lib' << 'test'
  test.pattern = 'test/**/test_*.rb'
  test.verbose = true
end

require 'rcov/rcovtask'
Rcov::RcovTask.new do |test|
  test.libs << 'test'
  test.pattern = 'test/**/test_*.rb'
  test.verbose = true
  test.rcov_opts << '--exclude "gems/*"'
end

task :default => :test

require 'rdoc/task'
Rake::RDocTask.new do |rdoc|
  version = File.exist?('VERSION') ? File.read('VERSION') : ""

  rdoc.rdoc_dir = 'rdoc'
  rdoc.title = "alphasign #{version}"
  rdoc.rdoc_files.include('README*')
  rdoc.rdoc_files.include('lib/**/*.rb')
end
