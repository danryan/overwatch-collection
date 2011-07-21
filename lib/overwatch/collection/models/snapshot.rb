module Overwatch
  class Snapshot
    include DataMapper::Resource
    
    property :id, Serial, :index => true
    property :data, Json
    # property :raw_data, Json
    property :created_at, DateTime
    property :updated_at, DateTime
    property :created_on, Date
    property :updated_on, Date
    property :created_at_hour, Integer
    property :created_at_min, Integer
    property :created_at_int, Integer
    
    belongs_to :resource
    
    # attr_accessor :data
    attr_accessor :raw_data
    
    after :create, :parse_data
    # after :create, :run_checks
    after :create, :update_attribute_keys
    after :create, :generate_timestamps
    # after :create, :schedule_reaper

    def data
      begin
        Hashie::Mash.new(
          Yajl.load($redis.hget("overwatch::snapshot:#{self.id}", "data"))
        )
      rescue
      end
    end

    def run_checks
      self.resource.run_checks
    end

    def schedule_reaper
      if self.created_at.min % 5 != 0
        Resque.enqueue_in(60.minutes, SnapshotReaper, self)
        # Resque.enqueue_in(60.minutes, AttributeReaper, "resource:#{self.resource_id}:#{key}")
      elsif self.created_at.hour != 0 && self.created_at.min != 0
        Resque.enqueue_in(1.day, SnapshotReaper, self)
      else
        Resque.enqueue_in(30.days, SnapshotReaper, self)
      end
    end

    # Usage: to_dotted_hash({:one => :two}) # => "one.two"
    def to_dotted_hash(source=self.data,target = {}, namespace = nil)
      prefix = "#{namespace}." if namespace
      case source
      when Hash
        source.each do |key, value|
          to_dotted_hash(value, target, "#{prefix}#{key}")
        end
      else
        target[namespace] = source
      end
      target
    end

    private

    def parse_data
      self.to_dotted_hash.each_pair do |key, value|
        timestamp = self.created_at.to_i * 1000
        $redis.zadd "overwatch::resource:#{resource.id}:#{key}", timestamp, "#{timestamp}:#{value}"
      end    
    end

    def update_attribute_keys
      self.to_dotted_hash.keys.each do |key|
        $redis.sadd "overwatch::resource:#{self.resource.id}:attribute_keys", key
      end
    end
    
    def generate_timestamps
      self.created_at_int = self.created_at.to_i
      self.save
    end

  end

  class AttributeError < Exception; end
end


