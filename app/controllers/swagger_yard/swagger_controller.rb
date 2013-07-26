module SwaggerYard
  class SwaggerController < ApplicationController
    layout false

    def index
      swagger_listing = SwaggerYard.get_listing
      swagger_listing.merge!("basePath" => request.url) if swagger_listing["basePath"].blank?
      render :json => swagger_listing
    end

    def show
      swagger_api = SwaggerYard.get_api("/#{params[:resource]}")
      swagger_api.merge!("basePath" => request.base_url + SwaggerYard.api_path) if swagger_api["basePath"].blank? 
      render :json => swagger_api
    end

    def doc
      @access_id     = SwaggerYard.access_id
      @access_secret = SwaggerYard.access_secret
      @discovery_url = "#{request.protocol}#{request.host_with_port}/swagger/api"
      render :doc
    end
  end
end