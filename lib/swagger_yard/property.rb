module SwaggerYard
  #
  # Holds the name and type for a single model property
  #
  class Property
    attr_reader :name, :description

    def self.from_tag(tag)
      new(tag.name, tag.types, tag.text)
    end

    def initialize(name, types, description)
      @name = name
      @description = description
      @type = Type.from_type_list(types)
    end

    def array?
      @type.array?
    end

    def required?
      @type.required?
    end

    def ref?
      @type.ref?
    end

    def type
      @type.name
    end

    def to_h
      type_tag = ref? ? "$ref" : "type" # as of v1.2 spec this is required behavior
      result = if array?
        { "type" => "array", "items" => { type_tag => type } }
      else
        { type_tag => type }
      end
      result["description"] = description if description
      result
    end
  end
end
