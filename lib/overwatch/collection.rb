require 'bundler'
Bundler.require(:default)

require 'overwatch/collection/version'
require 'overwatch/collection/attributes'
require 'overwatch/collection/models/resource'
require 'overwatch/collection/models/snapshot'
require 'overwatch/collection/application'


module Overwatch
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
  
  module Collection
    
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