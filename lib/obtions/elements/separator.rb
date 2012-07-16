module Obtions
  class Separator < Element
    def initialize string, optparse, options = {}
      @string   = string
      @optparse = optparse
      @options  = options
    end

    def apply
      if @string
        @optparse.separator @string
      elsif @options[:file]
        case @options[:file]
        when String
          @optparse.separator File.read(@options[:file])
        when File
          @optparse.separator @options[:file].read
        end
      end
    end
  end
end
