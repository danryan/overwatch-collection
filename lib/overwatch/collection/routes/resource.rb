module Overwatch
  module Collection
    class Application < Sinatra::Base
      
      get '/resources/?' do
        resources = Resource.all
        if resources.size < 1
          [].to_json
        else
          resources.to_json(:exclude => [ :created_at, :updated_at ])
        end
      end
      
      get '/resources/:id/?' do |id|
        resource = Resource.get(id) || Resource.first(:name => id)
        if resource
          status 200
          resource.to_json(:exclude => [ :created_at, :updated_at ])
        else
          halt 404
        end
        
      end
      
      post '/resources/?' do
        # logger.info request.body.read
        data = Yajl.load(request.body.read)
        resource = Resource.new(:name => data['name'])
        if resource.save
          status 201
          resource.to_json(:exclude => [ :created_at, :updated_at ])
        else
          body resource.errors.to_json
          status 422
        end
      end

      put '/resources/:id/?' do |id|
        data = Yajl.load(request.body.read)
        resource = Resource.get(id) || Resource.first(:name => id)
        if resource
          if resource.update(data)
            status 200
            resource.to_json(:exclude => [ :created_at, :updated_at ])
          else
            status 409
            resource.errors.to_json
          end
        else
          halt 404
        end
          
      end
      
      delete '/resources/:id/?' do |id|
        resource = Resource.get(id) || Resource.first(:name => id)
        if resource
          if resource.destroy
            status 200
          else
            status 409
            resource.errors.to_json
          end
        else
          halt 404
        end
        
      end
      
      get '/resources/:id/attributes/?' do |id|
        resource = Resource.get(id) || Resource.first(:name => id)
        attributes = resource.attribute_keys
        if attributes.length < 1
          [].to_json
        else
          attributes.sort.to_json
        end
      end
      
      get '/resources/:id/attributes/:attribute/?' do |id, attribute|
        resource = Resource.get(id) || Resource.first(:name => id)
        
        options = { 
          :start_at => (params[:start_at].to_i || nil), 
          :end_at => (params[:end_at].to_i || nil),
          :interval => (params[:interval].to_s || 'hour')
        }
        
        values = resource.values_with_dates_for(attribute, options)
        values.to_json
      end
      
      get '/resources/:id/attributes/:attribute/:function/?' do |id, attribute, function|
        resource = Resource.get(id) || Resource.first(:name => id)
        
        options = { 
          :start_at => (params[:start_at].to_i || nil), 
          :end_at => (params[:end_at].to_i || nil),
          :interval => (params[:interval].to_s || 'hour')
        }

        attribute = resource.function(params[:function].to_sym, attribute, options)
        attribute.to_json
      end
      
    end
  end
end