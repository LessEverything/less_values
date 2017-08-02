require 'bigdecimal'
require 'bigdecimal/util'

module Less
  module Values
    class Attribute
      attr_reader :name, :type
      def initialize(name, type, opts)
        @name = name
        @type = type
        @opts = opts
      end

      def instance_attr_name
        ('@' + @name.to_s).to_sym
      end

      def instantiate(value)
        value = @opts[:default] if value.nil?

        raise MissingAttributeError, missing_attr_message if missing_attribute?(value)
        raise WrongTypeError, wrong_type_message(value) if wrong_type?(value)

        value
      end

      def parse(value)
        is_blank = ['', nil].member?(value)

        if type == Integer
          return nil if is_blank
          value.to_i
        elsif type == Float
          return nil if is_blank
          value.to_f
        elsif type == BigDecimal
          return nil if is_blank
          value.to_d
        elsif type == Less::Bool
          ['1', 'true', true].member?(value)
        else
          value
        end
      end

      private

      def missing_attribute?(value)
        value.nil? && !@opts[:allow_nil]
      end

      def wrong_type?(value)
        return false if value.is_a?(type)
        return false if type == Less::Bool && (value == true || value == false)
        return false if value.nil? && @opts[:allow_nil]

        true
      end

      def wrong_type_message(value)
        "Attribute #{@name} is of the wrong type "\
        "(expected #{@type}, got #{value.class})"
      end

      def missing_attr_message
        "Missing value for attribute #{@name}"
      end
    end
  end
end
