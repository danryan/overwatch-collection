# -*- encoding: utf-8 -*-
$:.push File.expand_path("../lib", __FILE__)

require 'overwatch/collection/version'

Gem::Specification.new do |s|
  s.name              = 'overwatch-collection'
  s.version           = Overwatch::Collection::VERSION
  s.platform          = Gem::Platform::RUBY
  s.authors           = [ "Dan Ryan" ]
  s.email             = [ "dan@appliedawesome.com" ]
  s.homepage          = "https://github.com/danryan/overwatch-collection"
  s.summary           = "Overwatch statistical time series collection app"
  s.description       = "overwatch-collection is a Redis-backed statistical time series collection application designed to be fast, extensible, and easy to use."
  
  s.rubyforge_project = "overwatch-collection"
  s.files             = `git ls-files`.split("\n")
  s.test_files        = `git ls-files -- {spec}/*`.split("\n")
  s.executables       = `git ls-files -- bin/*`.split("\n").map{ |f| File.basename(f) }
  s.require_paths     = ["lib"]

  s.add_dependency 'dm-core', '>= 1.1.0'
  s.add_dependency 'dm-active_model', '>= 1.1.0'
  s.add_dependency 'dm-redis-adapter', '>= 0.4.0'
  s.add_dependency 'dm-serializer', '>= 1.1.0'
  s.add_dependency 'dm-timestamps', '>= 1.1.0'
  s.add_dependency 'dm-validations', '>= 1.1.0'
  s.add_dependency 'dm-types', '>= 1.1.0'
  s.add_dependency 'yajl-ruby', '>= 0.8.2'
  s.add_dependency 'hashie', '>= 1.0.0'
  s.add_dependency 'rest-client', '>= 1.6.3'
  s.add_dependency 'sinatra', '>= 1.2.6'
  s.add_dependency 'sinatra-logger', '>= 0.1.1'
  s.add_dependency 'activesupport', '>= 3.0.9'
  
  s.add_development_dependency 'rspec', '>= 2.6.0'
  s.add_development_dependency 'rack-test', '>= 0.6.0'
  s.add_development_dependency 'spork', '>= 0.9.0.rc8'
  s.add_development_dependency 'watchr', '>= 0.7'
  s.add_development_dependency 'factory_girl', '>= 1.3.3'
  s.add_development_dependency 'json_spec', '>= 0.5.0'
  s.add_development_dependency 'timecop', '>= 0.3.5'
end
