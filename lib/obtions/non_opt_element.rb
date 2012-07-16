module Obtions
  class NonOptElement < Element
    def self.args= new_args
      @@args = new_args
    end

    def next_arg
      @@args.shift
    end
  end
end
