# Add your own tasks in files placed in lib/tasks ending in .rake,
# for example lib/tasks/capistrano.rake, and they will automatically be available to Rake.

require 'rake'

# require 'resque/tasks'
# require 'resque_scheduler/tasks'    

require 'bundler/gem_tasks'

require 'rspec/core/rake_task'

desc "Run specs"
RSpec::Core::RakeTask.new do |task|
  task.pattern = "spec/**/*_spec.rb"
end
  
desc "Run watchr"
task :watchr do
  sh %{bundle exec watchr .watchr}
end

desc "Run spork"
task :spork do
  sh %{bundle exec spork}
end


Bundler.require(:doc)
desc "Generate documentation"
YARD::Rake::YardocTask.new do |t|
  t.files = [ 'lib/**/*.rb' ]
end

namespace :overwatch do
  namespace :test do 
    task :snapshot => :environment do
      a = Resource.first
      a.snapshots.create(:data => {:one => rand(10), :two => { :three => rand(10) }})
    end
  end
end