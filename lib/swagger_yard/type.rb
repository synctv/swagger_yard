module SwaggerYard
  class Type
    def self.from_type_list(types)
      parts = types.first.split(/[<>]/)
      new(parts.last, parts.grep(/array/i).any?)
    end

    attr_reader :name, :array

    def initialize(name, array=false)
      @name, @array = name, array
    end

    # TODO: have this look at resource listing?
    def ref?
      /[[:upper:]]/.match(name)
    end

    alias :array? :array
  end
end
