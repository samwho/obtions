module Obtions
  class NamedArg < Element
    def apply
      @out.send "#{@name}?=", @options[:default]
      args = []

      args << "--#{@name}=VALUE"
      args << @options[:in] if @options[:in] and @options[:in].is_a?(Array)
      args << @options[:documentation] if @options[:documentation]

      @optparse.on *args do |value|
        value = self.class.convert(value, @options) if @options[:type]
        @out.send "#{@name}=", value
        mark_as_present
      end
    end
  end
end
