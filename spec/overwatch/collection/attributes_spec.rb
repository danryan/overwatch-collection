require 'spec_helper'

module Overwatch
  module Collection
    describe Attributes do
      let(:resource) { Overwatch::Resource.create(:name => 'foo') }
      let(:start_at) { (Time.now - 1.hour).to_i * 1000 }
      let(:end_at) { Time.now.to_i * 1000 }
      
      before do
        resource.snapshots.create(:data => snapshot_data)
        time_travel!
        resource.snapshots.create(:data => snapshot_data)
      end
      
      describe "#attribute_keys" do
        it "should return all available attributes" do
          resource.attribute_keys.should have(2).items
          resource.attribute_keys.should include("load_average.one_minute")
        end
        
      end
      
      describe "#values_for" do
        before do
          time_travel!(Time.now + 1.hour)
          resource.snapshots.create(:data => snapshot_data)
        end
          
        it "should return all values by default" do
          values = resource.values_for("load_average.one_minute")
          values[:data].should have(3).items
        end
        
        it "should return values within a given date range" do
          values = resource.values_for("load_average.one_minute", 
            :start_at => start_at, :end_at => end_at
          )
          values[:data].should have(2).items
        end
      end
      
      describe "#values_with_dates_for" do
        before do
          time_travel!(Time.now + 1.hour)
          resource.snapshots.create(:data => snapshot_data)
        end
        
        it "should return all values by default" do
          values = resource.values_with_dates_for("load_average.one_minute")
          values[:data].should have(3).items
        end
        
        it "should return values within a given date range" do
          values = resource.values_for("load_average.one_minute", 
            :start_at => start_at, :end_at => end_at
          )
          values[:data].should have(2).items
        end        
      end

    end
  end
end