require 'spec_helper'

module Overwatch
  module Collection

    describe Application do
      let(:resource) { Overwatch::Resource.create(:name => 'foo') }
      
      describe "GET /resources/:resource_id/snapshots" do
        before do
          5.times do
            resource.snapshots.create(:data => snapshot_data)
          end
          get "/resources/#{resource.id}/snapshots"
        end

        subject { last_response }

        it { should respond_with 200 }
        it { should respond_with_content_type 'application/json' }
        it "should return an array of snapshots" do
          last_json.should have(5).items
        end
      end

      describe "GET /resources/:resource_id/snapshots/:id" do
        let(:snapshot) { resource.snapshots.create(:data => snapshot_data) }
        before do
          get "/resources/#{resource.id}/snapshots/#{snapshot.id}"
        end
      
        subject { last_response }
      
        it { should respond_with 200 }
        it { should respond_with_content_type 'application/json' }
      
        it "should return one record" do
          resource.id.should == Yajl.load(last_response.body)['id']
        end
      end
      
      describe "POST /snapshots" do
        before do
          post "/snapshots?key=#{resource.api_key}", Yajl.dump(snapshot_data)
        end
        
        subject { last_response }
        
        it { should respond_with 201 }
        it { should respond_with_content_type 'application/json' }
        
        it "should create one snapshot" do
          resource.snapshots.should have(1).item
        end
      end
      
      describe "GET /resources/:resource_id/snapshots/:id/data" do 
        let(:snapshot) { resource.snapshots.create(:data => snapshot_data) }
        
        before do
          get "/resources/#{resource.id}/snapshots/#{snapshot.id}/data"
        end
        
        subject { last_response }
        
        it { should respond_with 200 }
        it { should respond_with_content_type 'application/json' }
        
        it "should return full JSON of a given snapshot"
      end
      # 
      # describe "POST /resources" do
      # 
      #   before do
      #     post "/resources", Yajl.dump({:name => "foo" })
      #   end
      # 
      #   subject { last_response }
      # 
      #   it { should respond_with 201 }
      #   it { should respond_with_content_type 'application/json' }
      # end
      # 
      # describe "PUT /resources/:id" do
      #   let(:resource) { Overwatch::Resource.create(:name => 'foo') }
      #   before do
      #     put "/resources/#{resource.id}", Yajl.dump({:name => "bar" })
      #   end
      # 
      #   subject { last_response }
      # 
      #   it { should respond_with 200 }
      #   it { should respond_with_content_type 'application/json' }
      # 
      #   it "should update the record" do
      #     Resource.get(resource.id).name.should == "bar"
      #   end
      # 
      # end
      # 
      # describe "DELETE /resources/:id" do
      #   let(:resource) { Overwatch::Resource.create(:name => 'foo') }
      #   before do
      #     delete "/resources/#{resource.id}"
      #   end
      # 
      #   subject { last_response }
      # 
      #   it { should respond_with 200 }
      #   it { should respond_with_content_type 'application/json' }
      # 
      #   it "should delete record" do
      #     Resource.get(resource.id).should be_nil
      #   end
      # end
      # 
      # describe "GET /resources/:id/attributes" do
      #   let(:resource) { Overwatch::Resource.create(:name => 'foo') }
      #   before do
      #     resource.snapshots.create(:raw_data => { :one => 1, :two => 2 })
      #     get "/resources/#{resource.id}/attributes"
      #   end
      # 
      #   subject { last_response }
      # 
      #   it { should respond_with 200 }
      #   it { should respond_with_content_type 'application/json' }
      # 
      #   it "should return an array of available attributes" do
      #     attributes = Yajl.load(last_response.body)
      #     attributes.should == ["one", "two"]
      #   end
      # end
      # 
      # describe "GET /resources/:id/attributes/:attribute" do
      #   let(:resource) { Overwatch::Resource.create(:name => 'foo') }
      #   before do
      #     Timecop.travel(Time.local(2011, 7, 20, 12, 1, 0))
      #     resource.snapshots.create(:raw_data => { :one => 1, :two => 2 })
      #     Timecop.travel(Time.local(2011, 7, 20, 12, 2, 0))
      #     resource.snapshots.create(:raw_data => { :one => 1, :two => 2 })
      #     get "/resources/#{resource.id}/attributes/one"
      #   end
      # 
      #   subject { last_response }
      # 
      #   it { should respond_with 200 }
      #   it { should respond_with_content_type 'application/json' }
      # 
      #   it "should return a hash of the attribute name and values" do
      #     values = Yajl.load(last_response.body)
      #     values['name'].should eq "one"
      #     puts resource.snapshots.inspect
      #   end
      # end

    end    
  end
end