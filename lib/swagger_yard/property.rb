module SwaggerYard
  #
  # Holds the name and type for a single model property
  #
  class Property
    attr_reader :name, :description

    def self.from_tag(tag)
      name, options_string = tag.name.split(/[\(\)]/)

      required = options_string.to_s.split(',').map(&:strip).include?('required')

      new(name, tag.types, tag.text, required)
    end

    def initialize(name, types, description, required)
      @name, @description, @required = name, description, required

      @type = Type.from_type_list(types)
    end

    def array?
      @type.array?
    end

    def required?
      @required
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
