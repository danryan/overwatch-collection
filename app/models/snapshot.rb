class Snapshot
  include Mongoid::Document
  include Mongoid::Timestamps::Created
  
  field :data, :type => Hash
  
  # def data
    # raw = super
    # Hashie::Mash.new(raw)
  # end
  
  def data_mash
    Hashie::Mash.new(data)
  end
  
  belongs_to :resource
  
  after_create :update_resource_keys
  
  def update_resource_keys
    self.to_dotted_hash(data, {}, "data").keys.each do |key|
      unless resource.keys.include?(key)
        resource.keys << key
      end
    end
    resource.save
  end
  
  def to_dotted_hash(source=self.data,target = {}, namespace = nil)
    prefix = "#{namespace}|" if namespace
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
end
