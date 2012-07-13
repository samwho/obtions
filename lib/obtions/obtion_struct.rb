module Obtions
  class ObtionStruct < OpenStruct
    def [] key
      send key
    end

    def []= key, value
      send "#{key}=", value
    end
  end
end
