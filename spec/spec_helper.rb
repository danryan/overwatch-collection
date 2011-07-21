require 'rubygems'
require 'spork'

Spork.prefork do 
  require 'bundler'
  Bundler.require(:default, :test)
  
  ENV["RACK_ENV"] ||= 'test'
  
  $: << File.join(File.dirname(__FILE__), "lib")

  require 'overwatch/collection'

  support_files = File.join(File.expand_path(File.dirname(__FILE__)), "/support/**/*.rb")
  Dir[support_files].each {|f| require f}

  ENV['REDIS_URL'] = 'redis://localhost:6379/3'

  RSpec.configure do |config|
    config.color_enabled = true
    config.formatter = "documentation"
    config.mock_with :rspec
    
    config.before :suite do
    end
    
    config.before :each do
      Timecop.freeze(Time.now) #(Time.local(2011, 1, 1, 0, 0, 0))
      header 'Accept', 'application/json'
      header 'Content-Type', 'application/json'
      $redis.flushdb
    end
    
    config.after :each do 
      # $redis.flushdb
      Timecop.return
    end
  
    config.after :suite do
    end
    
    config.include Rack::Test::Methods
  end
  
  def app
    Overwatch::Collection::Application
  end
end

Spork.each_run do
end