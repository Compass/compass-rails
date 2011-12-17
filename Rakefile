#!/usr/bin/env rake
require 'rubygems'
require 'bundler'
Bundler.setup
require 'rake/dsl_definition' rescue nil

require "bundler/gem_tasks"
require 'appraisal'
require 'compass'

# ----- Default: Testing ------

task :default => [:test, :features]

require 'rake/testtask'
require 'fileutils'

Rake::TestTask.new :test do |t|
  t.libs << 'lib'
  t.libs << 'test'
  test_files = FileList['test/**/*_test.rb']
  test_files.exclude('test/rails/*', 'test/haml/*')
  t.test_files = test_files
  t.verbose = true
end

Rake::TestTask.new :units do |t|
  t.libs << 'lib'
  t.libs << 'test'
  test_files = FileList['test/units/**/*_test.rb']
  test_files.exclude('test/rails/*', 'test/haml/*')
  t.test_files = test_files
  t.verbose = true
end