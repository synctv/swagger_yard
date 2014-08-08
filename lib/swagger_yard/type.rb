module SwaggerYard
  class Type
    def self.from_type_list(types)
      required = !types.delete("required").nil?

      parts = types.first.split(/[<>]/)
      new(parts.last, parts.grep(/array/i).any?, required)
    end

    attr_reader :name, :array, :required

    def initialize(name, array, required)
      @name, @array, @required = name, array, required
    end

    # TODO: have this look at resource listing?
    def ref?
      /[[:upper:]]/.match(name)
    end

    alias :array? :array
    alias :required? :required
  end
end
