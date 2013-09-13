SwaggerYard
==================

The SwaggerYard gem is a Rails Engine designed to parse your Yardocs API controller.
It'll create a Swagger-UI complaint JSON to be served out through where you mount SwaggerYard. 
You can mount this to the Rails app serving the REST API or you could mount it as a separate Rails app.
Parsing of the Yardocs happens during the server startup and the data will be subsequently cached to the Rails cache you have defined. If you API is large expect a slow server start up time.

Installation
-----------------
  
Put SwaggerYard in your Gemfile:

    gem install swagger_yard

Install the gem with Bunder:

    bundle install


Getting Started
-----------------

Place your configuration in a your rails initializers
    
    # config/initializers/swagger_yard.rb
    SwaggerYard.configure do |config|
      config.swagger_version = "1.1"
      config.api_version = "0.1"
      config.doc_base_path = "http://swagger.example.com/doc"
      config.api_base_path = "http://swagger.example.com/api"
    end

Mount your engine

	# config/routes.rb
	mount SwaggerYard::Engine, at: "/swagger"


Example
----------------

Here is a example of how to use SwaggerYard


    # @resource Account ownership
    #
    # @resource_path /accounts/ownerships
    #
    # This document describes the API for creating, reading, and deleting account ownerships.
    #
    class Accounts::OwnershipsController < ActionController::Base
      ##
      # Returns a list of ownerships associated with the account.
      #
      # @notes Status can be -1(Deleted), 0(Inactive), 1(Active), 2(Expired) and 3(Cancelled).
      #
      # @path [GET] /accounts/ownerships.{format_type}
      #
      # @parameter          [Integer]   offset            Used for pagination of response data (default: 25 items per response). Specifies the offset of the next block of data to receive.
      # @parameter          [Array]     status            Filter by status. (e.g. status[]=1&status[]=2&status[]=3).
      # @parameter_list     [String]    sort_order        Orders response by fields. (e.g. sort_order=created_at).
      #                     [List]      id                
      #                     [List]      begin_at          
      #                     [List]      end_at            
      #                     [List]      created_at        
      # @parameter          [Boolean]   sort_descending   Reverse order of sort_order sorting, make it descending.
      # @parameter          [Date]      begin_at_greater  Filters response to include only items with begin_at >= specified timestamp (e.g. begin_at_greater=2012-02-15T02:06:56Z).
      # @parameter          [Date]      begin_at_less     Filters response to include only items with begin_at <= specified timestamp (e.g. begin_at_less=2012-02-15T02:06:56Z).
      # @parameter          [Date]      end_at_greater    Filters response to include only items with end_at >= specified timestamp (e.g. end_at_greater=2012-02-15T02:06:56Z).
      # @parameter          [Date]      end_at_less       Filters response to include only items with end_at <= specified timestamp (e.g. end_at_less=2012-02-15T02:06:56Z).
      #
      def index
        ...
      end
    end


![Web UI](https://github.com/synctv/swagger_yard/example/web-ui.png)


Generators
----------------

There are two generators that you can use 

     rails g swagger_yard:ui
     rails g swagger_yard:js

They both copy over their respective files over to your Rails app to be customized. 
See [rails engines overriding views](http://guides.rubyonrails.org/engines.html#overriding-views) for more info

Copying over JS requires that ActionDispatch::Static middleware be used (by default it should in use).


Notes
-----------------

By default SwaggerYard will use a slightly modify version of the swagger-ui. Changes to the JS code are indicated with "SwaggerYard changes" comments. The changes are mainly to support Rails way of supporting an array of parameters.


More Information
-----------------

[Swagger-ui](https://github.com/wordnik/swagger-ui)
[Yard](https://github.com/lsegal/yard)


Author
-----------------

Chris Trinh