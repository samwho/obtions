module Obtions
  class Element
    attr_accessor :name, :options

    def initialize name, out, optparse, options = {}
      self.name    = name
      @out         = out
      @optparse    = optparse
      self.options = options

      Obtions.required_args << self if options[:required]
    end

    def apply
      raise "This method should be overridden in subclasses of Element."
    end

    # If you are creating an element that is required in the command line option
    # string, this is the method that will tell Obtions that it is actually
    # present.
    #
    # This method should be called inside the @optparse.on block.
    def mark_as_present
      Obtions.required_args.delete_at(Obtions.required_args.index(self) ||
                                      Obtions.required_args.length)
    end

    def self.convert subject, options = {}
      return nil if subject.nil?
      return subject unless options[:type]
      type = options[:type]

      if    type == Integer
        return Integer(subject, options[:base] || 10)
      elsif type == Float
        return Float(subject)
      elsif type == Symbol
        return subject.to_sym
      elsif type == Array
        split = subject.split(/\s*,\s*/)

        if options[:of]
          split.map! { |elem| convert(elem, type: options[:of]) }
        end

        return split
      elsif type == Date || options[:type] == DateTime
        if options[:format]
          return DateTime.strptime(subject, options[:format])
        else
          return DateTime.parse(subject)
        end
      elsif type == File
        return File.open(subject)
      elsif type != nil
        # invalid type option
        raise InvalidType.new("#{type.to_s} is not an accepted type.")
      end
    end
  end
end
