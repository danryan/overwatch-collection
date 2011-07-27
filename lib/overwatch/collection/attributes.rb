module Overwatch
  module Collection
    module Attributes

      def attribute_keys
        $redis.smembers("overwatch::resource:#{self.id}:attribute_keys").sort
      end

      def average(attr, options={})
        function(:average, attr, options)
      end

      def min(attr, options={})
        function(:min, attr, options)
      end

      def max(attr, options={})
        function(:max, attr, options)
      end

      def median(attr, options={})
        function(:median, attr, options)
      end

      def first(attr, options={})
        function(:first, attr, options)
      end

      def last(attr, options={})
        function(:last, attr, options)
      end

      def function(func, attr, options={})
        case func
        when :max
          values_for(attr, options)[:data].max
        when :min
          values_for(attr, options)[:data].min
        when :average
          values = values_for(attr, options)[:data]
          if is_a_number?(values.first)
            values.map!(&:to_f)
            values.inject(:+) / values.size
          else
            values.first
          end
        when :median
          values = values_for(attr, options)[:data].sort
          mid = values.size / 2
          values[mid]
        when :first
          value = $redis.zrangebyscore("overwatch::resource:#{self.id}:#{attr}", options[:start_at], options[:end_at])[0]
          value.split(":")[1] rescue nil
        when :last 
          value = $redis.zrevrangebyscore("overwatch::resource:#{self.id}:#{attr}", options[:end_at], options[:start_at])[0]
          value.split(":")[1] rescue nil
        end
      end

      def values_for(attr, options={})
        raise ArgumentError, "attribute does not exist" unless attribute_keys.include?(attr)
        start_at = options[:start_at] || "+inf"
        end_at = options[:end_at] || "-inf"
        interval = options[:interval]
        values = $redis.zrangebyscore("overwatch::resource:#{self.id}:#{attr}", start_at, end_at)
        values.map! do |v|
          val = v.split(":")[1]
          is_a_number?(val) ? val.to_f : val
        end
        values.compact!
        values = case interval
        when 'hour'
          values
        when 'day'
          values.each_slice(60).map { |s| s[0] }
        when 'week'
          values.each_slice(100).map { |s| s[0] }
        when 'month'
          values.each_slice(432).map { |s| s[0] }
        else
          values
        end
        { :name => attr, :data => values }#, :start_at => start_at, :end_at => end_at }
      end

      def is_a_number?(str)
        str.to_s.match(/\A[+-]?\d+?(\.\d+)?\Z/) == nil ? false : true
      end

      def values_with_dates_for(attr, options={})
        raise ArgumentError, "attribute does not exist" unless attribute_keys.include?(attr)
        start_at = options[:start_at] || "-inf"
        end_at = options[:end_at] || "+inf"
        interval = options[:interval]
        values = $redis.zrangebyscore("overwatch::resource:#{self.id}:#{attr}", start_at, end_at)
        values.map! do |v|
          val = v.split(":")
          [ val[0].to_i * 1000, is_a_number?(val[1]) ? val[1].to_f : val[1] ]
        end
        values.compact!
        values = case interval
        when 'hour'
          values
        when 'day'
          values.each_slice(60).map { |s| s[0] }
        when 'week'
          values.each_slice(100).map { |s| s[0] }
        when 'month'
          values.each_slice(432).map { |s| s[0] }
        else
          values
        end
        { :name => attr, :data => values } #, :start_at => start_at, :end_at => end_at }
      end

      def from_dotted_hash(source=self.attribute_keys)
        source.map do |main_value|
          main_value.to_s.split(".").reverse.inject(main_value) do |value, key|
            {key.to_sym => value}
          end
        end
      end


      def top_level_attributes
        self.attribute_keys.map do |key|
          key.split(".")[0]
        end.uniq
      end

      def sub_attributes(sub_attr)
        self.attribute_keys.select {|k| k =~ /^#{sub_attr}/ }
      end
    end
  end
end
