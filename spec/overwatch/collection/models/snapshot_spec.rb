require 'spec_helper'

module Overwatch
  describe Snapshot do
    let(:resource) { Overwatch::Resource.create(:name => "foo") }
    
    describe "new record" do
      it "should create a new snapshot" do
        snapshot = resource.snapshots.create(:data => snapshot_data)
        snapshot.should be_valid
        snapshot.resource.should == resource
      end
    end
  
    describe "#update_attribute_keys" do      
      it "should update the resource's available attribute keys" do
        resource.snapshots.create(:data => snapshot_data)
        resource.attribute_keys.should include("load_average.one_minute")
      end
    end
  
    describe "#parse_data" do
      it "should add each snapshot attribute to a sorted set" do
        10.times do
          resource.snapshots.create(:data => snapshot_data)
          time_travel!
        end
        $redis.zcard("overwatch::resource:#{resource.id}:load_average.one_minute").should == 10
      end
    end
  end
end