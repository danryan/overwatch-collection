require 'clamp'

module Overwatch
  module Collection
    class Command < Clamp::Command
      option ['-p', '--port'], 'PORT', 'listening port', :default => '9001'
      option ['-h', '--host'], 'HOST', 'hostname', :default => 'localhost'
      option ['-c', '--config'], 'CONFIG', 'config file', :default => File.expand_path(File.join(File.dirname(__FILE__), '/../config/overwatch.yml'))
      
      def execute
        Overwatch.config_path = config
        Overwatch::Collection::Application.run! :host => host, :port => port.to_i
      end
    end
  end
end