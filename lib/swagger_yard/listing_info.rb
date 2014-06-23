module SwaggerYard
  class ListingInfo
    attr_reader :description, :resource_path

    def initialize(yard_object)
      @description = yard_object.docstring

      if tag = yard_object.tags.detect {|t| t.tag_name == "resource_path"}
        @resource_path = tag.text.downcase
      end
    end
  end
end
