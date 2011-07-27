module Overwatch
  class Resource
    include DataMapper::Resource
    include Overwatch::Collection::Attributes
    
    property :id, Serial, :index => true
    property :name, String, :index => true
    property :api_key, String, :index => true
    property :created_at, DateTime
    property :updated_at, DateTime
    
    has n, :snapshots
    
    before :create, :generate_api_key

    validates_presence_of :name
    validates_uniqueness_of :name
    validates_uniqueness_of :api_key

    # after :create, :schedule_no_data_check
    
    def previous_update
      snapshots[-2]
    end

    def last_update
      snapshots[-1]
    end
    # 
    # def run_checks
    #   Resque.enqueue(CheckRun, self.id.to_s)
    # end
    # 
    # def schedule_no_data_check
    #   Resque.enqueue_in(5.minutes, NoDataCheck, self)
    # end

    def regenerate_api_key
      generate_api_key
      self.save
    end

    private

    def generate_api_key
      api_key = Digest::SHA1.hexdigest(Time.now.to_s + rand(12341234).to_s)[1..30]
      self.api_key = api_key
    end
    
  end
end
