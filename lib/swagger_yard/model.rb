module SwaggerYard
  #
  # Carries id (the class name) and properties for a referenced
  #   complex model object as defined by swagger schema
  #
  class Model
    attr_reader :id

    def self.from_yard_objects(yard_objects)
      from_yard_object(yard_objects.detect {|o| o.type == :class })
    end

    def self.from_yard_object(yard_object)
      from_tags(yard_object.tags) if yard_object
    end

    def self.from_tags(tags)
      new.tap do |model|
        model.parse_tags(tags)
      end
    end

    def initialize
      @properties = []
    end

    def valid?
      !id.nil?
    end

    def parse_tags(tags)
      tags.each do |tag|
        case tag.tag_name
        when "model"
          @id = tag.text
        when "property"
          @properties << Property.from_tag(tag)
        end
      end

      self
    end

    def properties_model_names
      @properties.select(&:is_ref?).map(&:type)
    end

    def to_h
      raise "Model is missing @model tag" if id.nil?

      {
        "id" => id,
        "properties" => Hash[@properties.map {|property| [property.name, property.to_h]}],
        "required" => @properties.select(&:is_required?).map(&:name)
      }
    end

  end

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
