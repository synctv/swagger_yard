# move into swagger_yard.rb?
require_relative 'api'
require_relative 'api_declaration'
require_relative 'resource_listing'
require_relative 'listing_info'

module SwaggerYard
  # move into ResourceListing
  class Parser
    attr_reader :listing

    def initialize
      @listing = ResourceListing.new
    end

    def run(yard_objects)
      api_declaration = ApiDeclaration.new

      # move into ApiDeclaration
      yard_objects.each do |yard_object|
        case yard_object.type
        when :class
          api_declaration.add_listing_info(ListingInfo.new(yard_object))

          break unless api_declaration.valid?
        when :method
          api_declaration.add_api(Api.new(yard_object))
        end
      end

      if api_declaration.valid?
        @listing.add(api_declaration)
        api_declaration
      else
        nil
      end
    end
  end
end
