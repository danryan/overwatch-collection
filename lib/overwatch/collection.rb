require 'bundler'
Bundler.require(:default)

# require 'dm-core'
# require 'dm-active_model'
# require 'dm-redis-adapter'
# require 'dm-serializer'
# require 'dm-timestamps'
# require 'dm-validations'
# require 'dm-types'
# require 'yajl'
# require 'hashie'
# require 'rest-client'
# require 'sinatra'
# require 'sinatra/logger'
# require 'activesupport/all'

require File.expand_path(File.join(File.dirname(__FILE__), "collection/version"))

require File.expand_path(File.join(File.dirname(__FILE__), "collection/attributes"))
require File.expand_path(File.join(File.dirname(__FILE__), "collection/models/resource"))
require File.expand_path(File.join(File.dirname(__FILE__), "collection/models/snapshot"))
require File.expand_path(File.join(File.dirname(__FILE__), "collection/application"))

module Overwatch
  module Collection
  end  
  class << self
    def config_path=(path)
      @config_path = path
    end
    
    def config_path
      @config_path ||= File.expand_path(File.dirname(__FILE__)) + "/../../config/overwatch.yml"
    end
    
    def config
      @config ||= {}
      @config.merge!(YAML.load_file(config_path))
    end
  end

end

$redis = Redis.new(
  :host => Overwatch.config['collection']['storage']['host'],
  :port => Overwatch.config['collection']['storage']['port'],
  :db => Overwatch.config['collection']['storage']['db']
)

DataMapper.setup(:default, { 
  :adapter => "redis",
  :host => Overwatch.config['collection']['storage']['host'],
  :port => Overwatch.config['collection']['storage']['port'],
  :db => Overwatch.config['collection']['storage']['db']
})