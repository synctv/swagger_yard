module SwaggerYard
  class Parameter
    attr_accessor :name, :data_type, :description
    attr_reader :param_type, :required, :allow_multiple, :allowable_values

    YARD_REGEX = /\A\[(\w*)\]\s*([\w\[\]]*)(\(.*\))?\s*(.*)\Z/

    def self.from_yard_tag(tag, operation)
      options = {}
      string = tag.text

      data_type, name, options_string, description = string.match(YARD_REGEX).captures
      options[:allow_multiple] = name.gsub!("[]", "") # name[] to match rails array behavior

      if operation.ref?(data_type)
        operation.model_names << data_type
      else
        data_type.downcase!
      end

      unless options_string.nil?
        options_string[1..-2].split(',').map(&:strip).tap do |arr|
          options[:required] = !arr.delete('required').nil?
          options[:param_type] = arr.last
        end
      end

      new(name, data_type, description, options)
    end

    # TODO: support more variation in scope types
    def self.from_path_param(name)
      new(name, "string", "Scope response to #{name}", {
        required: true,
        allow_multiple: false,
        param_type: "path"
      })
    end

    def initialize(name, data_type, description, options={})
      @name, @data_type, @description = name, data_type, description

      @required = options[:required] || false
      @param_type = options[:param_type] || 'query'
      @allow_multiple = options[:allow_multiple] || false
      @allowable_values = options[:allowable_values] || []
    end

    def allowable_values_hash
      return nil if allowable_values.empty?

      {
        "valueType" => "LIST",
        "values" => allowable_values
      }
    end

    def to_h
      {
        "paramType"       => param_type,
        "name"            => name,
        "description"     => description,
        "type"            => data_type,
        "required"        => required,
        "allowMultiple"   => allow_multiple.present?,
        "allowableValues" => allowable_values_hash 
      }.reject {|k,v| v.nil?}
    end
  end
end