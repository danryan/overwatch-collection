module Overwatch
  module Collection
    class Application < Sinatra::Base
      
      get '/resources/?' do
        resources = Resource.all
        if resources.size < 1
          [].to_json
        else
          status 200
          resources.to_json# (:exclude => [ :created_at, :updated_at ])
        end
      end
      
      get '/resources/:id/?' do |id|
        resource = Resource.get(id) || Resource.first(:name => id)
        if resource
          status 200
          resource.to_json# (:exclude => [ :created_at, :updated_at ])
        else
          status 404
          ["Not found"].to_json
        end
        
      end
      
      post '/resources/?' do
        data = Yajl.load(request.body.read)
        resource = Resource.new(:name => data['name'])
        if resource.save
          status 201
          resource.to_json # (:exclude => [ :created_at, :updated_at ])
        else
          status 422
          resource.errors.to_json
        end
      end

      put '/resources/:id/?' do |id|
        data = Yajl.load(request.body.read)
        resource = Resource.get(id) || Resource.first(:name => id)
        if resource
          if resource.update(data)
            status 200
            resource.to_json# (:exclude => [ :created_at, :updated_at ])
          else
            status 409
            resource.errors.to_json
          end
        else
          status 404
          ["Not found"].to_json
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
        if resource
          attributes = resource.attribute_keys
          if attributes.length < 1
            [].to_json
          else
            attributes.sort.to_json
          end
        else
          status 404
          ["Not found"].to_json
        end
      end
      
      get '/resources/:id/attributes/:attribute/?' do |id, attribute|
        resource = Resource.get(id) || Resource.first(:name => id)
        options = { 
          :start_at => params[:start_at].present? ? params[:start_at].to_i : "-inf",
          :end_at => params[:end_at].present? ? params[:end_at].to_i : "+inf",
          :interval => params[:interval].present? ? params[:interval] : 'hour'
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