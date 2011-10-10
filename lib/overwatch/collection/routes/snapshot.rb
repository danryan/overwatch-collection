module Overwatch
  module Collection
    class Application < Sinatra::Base
      
      get '/resources/:resource_id/snapshots/?' do |resource_id|
        resource = Resource.get(resource_id)
        snapshots = resource.snapshots
        
        if snapshots.size < 1
          [].to_json
        else
          snapshots.to_json
        end
      end
      
      get '/resources/:resource_id/snapshots/:id/?' do |resource_id, id|
        resource = Resource.get(resource_id)
        snapshot = resource.snapshots.first(:id => id)
        
        if resource
          if snapshot
            status 200
            snapshot.to_json
          else
            status 404
            ["Snapshot not found"].to_json
          end
        end
      end
      
      
      get '/snapshots/?' do
        snapshots = Snapshot.all
        
        if snapshots.size < 1
          [].to_json
        else
          snapshots.to_json
        end
      end
      
      get '/snapshots/:id/?' do |id|
        snapshot = Snapshot.first(:id => id)
        
        if snapshot
          status 200
          snapshot.to_json
        else
          status 404
          ["Snapshot not found"].to_json
        end
      end
      
      get '/snapshots/:id/data/?' do |id|
        snapshot = Snapshot.first(:id => id)
        
        if snapshot
          status 200
          snapshot.data.to_json
        else
          status 404
          ["Snapshot not found"].to_json
        end
      end
      
      delete '/snapshots/:id/?' do |id|
        snapshot = Snapshot.first(:id => id)
        if snapshot
          if snapshot.destroy
            status 200
          else
            status 409
            snapshot.errors.to_hash.to_json(:except => :errors)
          end
        else
          status 404
          ["Snapshot not found"].to_json
        end
      end

      post '/snapshots/?' do
        resource = Resource.first(:api_key => params['key'])
        data = Yajl.load(request.body.read)
        snapshot = resource.snapshots.create(:data => data['data'])
        
        if resource
          if snapshot
            status 201
            snapshot.to_json
          else
            status 409
            snapshot.errors.to_hash.to_json(:except => :errors)
          end
        else
          status 404
          ["Snapshot not found"].to_json
        end
      end
      
      get '/resources/:resource_id/snapshots/:id/data/?' do |resource_id, id|
        resource = Resource.get(resource_id)
        snapshot = resource.snapshots.first(:id => id)
        
        if resource
          if snapshot
            status 200
            snapshot.data.to_json
          else
            status 404
            ["Snapshot not found"].to_json
          end
        else
          status 404
          ["Resource not found"].to_json
        end
        
      end
    end
  end
end