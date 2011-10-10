module Overwatch
  module Collection
    module Attributes

      def attribute_keys
        $redis.smembers("overwatch::resource:#{self.id}:attribute_keys").sort
      end

      def values_for(attr, options={})
        raise ArgumentError, "attribute does not exist" unless attribute_keys.include?(attr)
        start_at = options[:start_at] || "-inf"
        end_at = options[:end_at] || "+inf"
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

        max = values.max
        min = values.min
        if is_a_number?(values.first)
          average = (values.map(&:to_f).inject(:+)) / values.size
        else
          average = values.first
        end
        mid = values.size / 2
        median = values.sort[mid]
        first = $redis.zrangebyscore("overwatch::resource:#{self.id}:#{attr}", start_at, end_at)[0].split(":")[1] rescue nil
        last = $redis.zrevrangebyscore("overwatch::resource:#{self.id}:#{attr}", end_at, start_at)[0].split(":")[1] rescue nil
        
        { 
          :name => attr, 
          :functions => {
            :min => min,
            :max => max,
            :average => average,
            :median => median,
            :first => first,
            :last => last
          },
          :data => values 
        } #, :start_at => start_at, :end_at => end_at }
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
