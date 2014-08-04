module SwaggerYard
  #
  # Holds the name and type for a single model property
  #
  class Property
    attr_reader :name

    def self.from_tag(tag)
      new(tag.name, tag.types, tag.text)
    end

    def initialize(name, types, description)
      @name, @types, @description = name, types, description
    end

    def type
      is_array? ? @types[1] : @types[0]
    end

    def is_array?
      @types[0] == "array"
    end

    def is_required?
      @types.size > 1 && @types.last == "required"
    end

    def is_ref?
      /[[:upper:]]/.match(type[0])
    end

    def to_h
      type_tag = is_ref? ? "$ref" : "type"
      result = if is_array?
        { "type" => "array", "items" => { type_tag => type } }
      else
        { type_tag => @types.first }
      end
      result["description"] = @description if @description
      result
    end
  end
end
