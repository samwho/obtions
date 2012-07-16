module Obtions
  class Flag < Element
    def apply
      var_name  = @name
      default   = @options[:default] || false
      long_name = @options[:long]
      args      = []

      args << "-#{var_name}"
      args << "--[no-]#{long_name}" if long_name
      args << @options[:documentation] if @options[:documentation]

      @out.send "#{var_name}?=", default
      @out.send "#{var_name}=", default

      if long_name
        @out.send "#{long_name}?=", default
        @out.send "#{long_name}=", default
        @optparse.on *args do |bool|
          @out.send "#{var_name}?=", bool
          @out.send "#{var_name}=", bool
          @out.send "#{long_name}?=", bool
          @out.send "#{long_name}=", bool
        end
      else
        @optparse.on *args do
          @out.send "#{var_name}?=", true
          @out.send "#{var_name}=", true
        end
      end
    end
  end
end
