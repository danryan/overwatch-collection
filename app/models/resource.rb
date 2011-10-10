class Resource
  include Mongoid::Document
  include Mongoid::Timestamps
  
  field :name, :type => String
  field :api_key, :type => String, :default => lambda { generate_api_key }
  field :keys, :type => Array, :default => []

  index :name, :unique => true
  index :api_key, :unique => true
  
  validates_presence_of :name, :api_key
  validates_uniqueness_of :name, :api_key
  
  has_many :snapshots
  
  def last_update
    snapshots[-1]
  end
  
  def previous_update
    snapshots[-2]
  end
  
  def regenerate_api_key
    self.api_key = generate_api_key
    self.save
  end

  def values_for(attr, options={})
    key = attr.to_sym
    raise ArgumentError, "Key does not exist" unless keys.include?(key)
    start_at = options[:start_at] || Time.now - 1.hour
    end_at = options[:end_at] || Time.now
    interval = options[:interval]
    function = options[:function]
    
    snapshot_range = r.snapshots.where(
      key.exists => true,
      :created_at.gte => start_at,
      :created_at.lte => end_at
    )
    max = snapshot_range.max(key)
    min = snapshot_range.min(key)
    average = snapshot_range.avg(key)
    mid = snapshot_range.size / 2
    median = snapshot_range[mid]
    # first = 
    # last = 
    
    result = case interval
    when 'hour'
      values
    when 'day'
      values.each_slice(60).map(&:first)
    when 'week'
      values.each_slice(100).map(&:first)
    when 'month'
      values.each_slice(432).map(&:first)
    else
      values
    end
    result
    # { :name => attr, :data => values }#, :start_at => start_at, :end_at => end_at }
  end
  
  private
  
  def is_a_number?(str)
    str.to_s.match(/\A[+-]?\d+?(\.\d+)?\Z/) == nil ? false : true
  end
  
  def generate_api_key
    Digest::SHA1.hexdigest(Time.now.to_s + rand(12341234).to_s)[1..30]
  end
  
end