require 'spec_helper'

module Overwatch
  module Collection

    describe Application do

      describe "GET /resources" do
        before do
          Overwatch::Resource.create(:name => 'foo')
          get '/resources'
        end
      
        subject { last_response }
        
        it { should respond_with 200 }
        it { should respond_with_content_type 'application/json' }
        
      end
      
      describe "GET /resources/:id" do
        let(:resource) { Overwatch::Resource.create(:name => 'foo') }
        before do
          get "/resources/#{resource.id}"
        end

        subject { last_response }

        it { should respond_with 200 }
        it { should respond_with_content_type 'application/json' }
        
        it "should return one record" do
          resource.id.should == Yajl.load(last_response.body)['id']
        end
      end
      
      describe "POST /resources" do
        
        before do
          post "/resources", Yajl.dump({:name => "foo" })
        end
        
        subject { last_response }
        
        it { should respond_with 201 }
        it { should respond_with_content_type 'application/json' }
      end
      
      describe "PUT /resources/:id" do
        let(:resource) { Overwatch::Resource.create(:name => 'foo') }
        before do
          put "/resources/#{resource.id}", Yajl.dump({:name => "bar" })
        end
        
        subject { last_response }
        
        it { should respond_with 200 }
        it { should respond_with_content_type 'application/json' }
        
        it "should update the record" do
          Resource.get(resource.id).name.should == "bar"
        end
          
      end
      
      describe "DELETE /resources/:id" do
        let(:resource) { Overwatch::Resource.create(:name => 'foo') }
        before do
          delete "/resources/#{resource.id}"
        end
        
        subject { last_response }
        
        it { should respond_with 200 }
        it { should respond_with_content_type 'application/json' }
        
        it "should delete record" do
          Resource.get(resource.id).should be_nil
        end
      end
      
      describe "GET /resources/:id/attributes" do
        let(:resource) { Overwatch::Resource.create(:name => 'foo') }
        before do
          resource.snapshots.create(:raw_data => { :one => 1, :two => 2 })
          get "/resources/#{resource.id}/attributes"
        end
        
        subject { last_response }
        
        it { should respond_with 200 }
        it { should respond_with_content_type 'application/json' }
        
        it "should return an array of available attributes" do
          attributes = Yajl.load(last_response.body)
          attributes.should == ["one", "two"]
        end
      end
      
      describe "GET /resources/:id/attributes/:attribute" do
        let(:resource) { Overwatch::Resource.create(:name => 'foo') }
        before do
          Timecop.travel(Time.local(2011, 7, 20, 12, 1, 0))
          resource.snapshots.create(:raw_data => { :one => 1, :two => 2 })
          Timecop.travel(Time.local(2011, 7, 20, 12, 2, 0))
          resource.snapshots.create(:raw_data => { :one => 1, :two => 2 })
          get "/resources/#{resource.id}/attributes/one"
        end
        
        subject { last_response }
        
        it { should respond_with 200 }
        it { should respond_with_content_type 'application/json' }
        
        it "should return a hash of the attribute name and values" do
          values = Yajl.load(last_response.body)
          values['name'].should eq "one"
          puts resource.snapshots.inspect
        end
      end
      
    end    
  end
end