module Obtions
  class DSL
    def self.evaluate input, &block
      DSL.new.evaluate(input, &block)
    end

    def initialize out = ObtionStruct.new
      @out = out
    end

    def evaluate input, &block
      @optparse = OptionParser.new
      instance_eval &block
      @optparse.parse(input)
      @out
    end

    def evaluate! input, &block
      @optparse = OptionParser.new
      instance_eval &block
      @optparse.parse!(input)
      @out
    end

    def flag name, options = {}
      var_name = options[:as] || name

      @out.send "#{var_name}?=", false
      @out.send "#{var_name}=", false
      @optparse.on "-#{name}" do
        @out.send "#{var_name}?=", true
        @out.send "#{var_name}=", true
      end
    end
  end
end
