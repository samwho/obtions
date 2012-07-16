module Obtions
  class NamedArg < Element
    def apply
      @out.send "#{@name}?=", @options[:default]
      args = []
      val_str = @options[:optional] ? "[=OPTIONAL]" : "=MANDATORY"

      args << "--#{@name}#{val_str}"
      args << @options[:in] if @options[:in] and @options[:in].is_a?(Array)
      args << @options[:documentation] if @options[:documentation]

      @optparse.on *args do |value|
        value = self.class.convert(value, @options) if @options[:type]
        @out.send "#{@name}=", value
      end
    end
  end
end
