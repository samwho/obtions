module Obtions
  class << self
    def parse input = ARGV, &block
      DSL.evaluate input, &block
    end

    def parse! input = ARGV, &block
      DSL.evaluate! input, &block
    end

    # An array of arguments that are required in the command line options
    # string. This array gets checked after the command line options have been
    # parsed and raises a RequiredArgsMissing error if there's anything in it.
    def required_args
      @@required_args ||= []
    end

    def required_args= new_required_args
      @@required_args = new_required_args
    end
  end
end
