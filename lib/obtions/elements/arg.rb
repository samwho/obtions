module Obtions
  class Arg < NonOptElement
    def apply
      value = self.class.convert(next_arg, @options)
      mark_as_present if value

      @out.send "#{@name}=", value || @options[:default]
    end
  end
end
