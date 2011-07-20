require 'rubygems'
require 'bundler'
Bundler.require(:default)

$: << File.join(File.dirname(__FILE__), "lib")

require 'overwatch/collection'

run Overwatch::Collection::Application