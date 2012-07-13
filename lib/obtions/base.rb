module Obtions
  class << self
    def parse input, &block
      DSL.evaluate input, &block
    end

    def parse! input, &block
      DSL.evaluate! input, &block
    end
  end
end
