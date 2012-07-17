module Obtions
  class DSL
    def self.evaluate input = ARGV, &block
      input = Shellwords.split(input) unless input.is_a? Array
      DSL.new.evaluate!(input.dup, &block)
    end

    def self.evaluate! input = ARGV, &block
      input = Shellwords.split(input) unless input.is_a? Array
      DSL.new.evaluate!(input, &block)
    end

    def initialize out = ObtionStruct.new, optparse = OptionParser.new
      @out      = out
      @optparse = optparse
    end

    def evaluate! input, &block
      # Reset the required args array
      Obtions.required_args = []

      instance_eval(&block)

      opt_elements.each &:apply

      # Add help flag to command line options. This should be present in every
      # program so I'm just going to go ahead and make it a default.
      @optparse.on_tail '-h', '--help', 'Show this message.' do
        puts @optparse
        exit
      end

      @optparse.parse!(input)

      NonOptElement.args = input
      non_opt_elements.each &:apply

      unless Obtions.required_args.empty?
        raise RequiredArgsMissing.new(Obtions.required_args)
      end

      # @optparse.to_s is the help documentation that OptionParser creates for
      # us. Add it to the resulting object.
      @out.help = @optparse.to_s

      @out
    end

    # Delegates to the OptionParser#banner method.
    def banner string
      @optparse.banner = string
    end

    def separator input
      if input.is_a? String
        opt_elements << Separator.new(input, @optparse)
      elsif input.is_a? Hash
        opt_elements << Separator.new(nil, @optparse, input)
      else
        raise InvalidType.new("Seprator input must be a string or a hash. " +
                              "Found a #{input.class}.")
      end
    end

    def flag name, options = {}, &block
      options[:documentation] = block.call if block_given?
      opt_elements << Flag.new(name, @out, @optparse, options)
    end

    def arg name, options = {}, &block
      options[:documentation] = block.call if block_given?
      non_opt_elements << Arg.new(name, @out, @optparse, options)
    end

    # Alias for arg.
    def input name, options = {}, &block
      arg name, options, &block
    end

    def named_arg name, options = {}, &block
      options[:documentation] = block.call if block_given?
      opt_elements << NamedArg.new(name, @out, @optparse, options)
    end

    private

    def opt_elements
      @opt_elements ||= []
    end

    def non_opt_elements
      @non_opt_elements ||= []
    end
  end
end
