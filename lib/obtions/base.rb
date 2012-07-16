module Obtions
  class << self
    def parse input = ARGV, &block
      DSL.evaluate input, &block
    end

    def parse! input = ARGV, &block
      DSL.evaluate! input, &block
    end
  end
end
