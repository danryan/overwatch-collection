require 'spec_helper'

module Overwatch
  describe Resource do
        
    describe "new record" do
      
      it "generates an api key" do
        resource = Overwatch::Resource.create(:name => "foo")
        resource.api_key.should_not be_nil
      end
      
      it "creates a new resource" do
        resource = Overwatch::Resource.create(:name => "foo")
        resource.should be_valid
        resource.name.should == "foo"
      end
    
      it "disallows duplicate names" do
        resource = Overwatch::Resource.create(:name => "foo")
        resource2 = Overwatch::Resource.create(:name => "foo")
        resource2.should_not be_valid
        resource2.errors[:name].should == ["Name is already taken"]
      end
    
      it "requires a name" do
        resource = Overwatch::Resource.create
        resource.should_not be_valid
        resource.errors[:name].should == ["Name must not be blank"]
      end
      
    end
    
    describe '#generate_api_key' do
      it "generates an api key" do
        resource = Overwatch::Resource.create(:name => "foo")
        resource.api_key.should_not be_nil
      end
      
      it 'disallows duplicate api keys' do
        resource = Overwatch::Resource.create(:name => "foo")
        resource2 = Overwatch::Resource.create(:name => "bar")
        resource.api_key = '1234asdf' && resource2.api_key = '1234asdf'
        resource.save && resource2.save
        resource2.should_not be_valid
        resource2.errors[:api_key].should == ["Api key is already taken"]
      end
    end
        
    describe '#regenerate_api_key' do
      it "regenerates an api key" do
        resource = Overwatch::Resource.create(:name => 'foo')
        old_api_key = resource.api_key
        resource.regenerate_api_key
        resource.api_key.should_not == old_api_key
      end
      
    end
  end
end