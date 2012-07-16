module Obtions
  class Element
    def initialize name, out, optparse, options = {}
      @name     = name
      @out      = out
      @optparse = optparse
      @options  = options
    end

    def apply
      raise "This method should be overridden in subclasses of Element."
    end

    def self.convert subject, options = {}
      return nil if subject.nil?
      return subject unless options[:type]
      type = options[:type]

      if    type == Integer
        return Integer(subject, options[:base] || 10)
      elsif type == Float
        return Float(subject)
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
