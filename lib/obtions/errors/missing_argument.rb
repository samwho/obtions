module Obtions
  class MissingArgument < StandardError
    attr_accessor :name

    def initialize arg_name
      self.name = arg_name

      super "Required argument #{name} not specified."
    end
  end
end
