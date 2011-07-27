require 'sinatra/base'
require 'sinatra/logger'
# require 'sinatra/reloader' if development?

module Overwatch
  module Collection
    class Application < Sinatra::Base
      register Sinatra::Logger
      configure do
        set :app_file, __FILE__
        set :root, File.expand_path(File.join(File.dirname(__FILE__), "../../../"))
        set :logging, true
        set :run, false
        set :show_exceptions, false
        set :server, %w[ thin mongrel webrick ]
        set :raise_errors, false
        set :logger_level, :info
      end
      
      [ :development, :test].each do |env|
        configure(env) do
          set :raise_errors, true
          set :show_exceptions, true
          
        end
      end
      
      error DataMapper::ObjectNotFoundError do
        status 404
        [ "Not found" ].to_json
      end
      
      before do
        content_type "application/json"
      end
      
      configure(:production) do
        # TODO: allow this variable to be configured
        set :redis_url, ENV['REDIS_URL'] || 'redis://localhost:6379/0'
      end

    end
  end
end

require File.expand_path(File.join(File.dirname(__FILE__), "routes/resource"))
require File.expand_path(File.join(File.dirname(__FILE__), "routes/snapshot"))