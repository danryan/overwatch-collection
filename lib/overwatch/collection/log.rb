require 'mixlib/log'

module Overwatch
  module Collection
    class Log
      extend Mixlib::Log
      include Mixlib::Log
      
      init
    end
  end
end