#!/usr/bin/env rake
# Add your own tasks in files placed in lib/tasks ending in .rake,
# for example lib/tasks/capistrano.rake, and they will automatically be available to Rake.

require File.expand_path('../config/application', __FILE__)

Overwatch::Collection::Application.load_tasks

require 'rspec/core/rake_task'

desc "Run specs"
RSpec::Core::RakeTask.new do |task|
  task.pattern = "spec/**/*_spec.rb"
end

desc "Run guard"
task :guard do
  sh %{bundle exec guard start}
end

desc "Run spork"
task :spork do
  sh %{bundle exec spork}
end
