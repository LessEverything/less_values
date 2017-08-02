module Less
  module Values
    class ValueError < StandardError; end
    class WrongTypeError < ValueError; end
    class MissingAttributeError < ValueError; end
  end
end
