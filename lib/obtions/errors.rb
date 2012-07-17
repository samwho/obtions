module Obtions
  class InvalidType < StandardError
  end

  class RequiredArgsMissing < StandardError
    attr_accessor :args

    def initialize args
      self.args = args

      super "Required args missing: #{args.map(&:name).join(', ')}"
    end
  end
end
