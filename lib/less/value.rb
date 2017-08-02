class Less::Value
  def self.attribute(name, type, opts = {})
    @__attributes ||= []
    @__attributes << Less::Values::Attribute.new(name, type, opts)
    attr_reader(name)
    alias_method("#{name}?".to_sym, name) if type == Less::Bool
  end

  def self.attributes
    @__attributes
  end

  def initialize(opts, with_exceptions: true)
    @__values = {}
    @__errors = []
    self.class.attributes.each do |attr|
      value = opts[attr.name]
      value = instantiate(attr, value, with_exceptions)
      @__values[attr.name] = value
      instance_variable_set(attr.instance_attr_name, value.freeze)

    end
  end

  def instantiate(attr, value, with_exceptions)
    if with_exceptions
      attr.instantiate(value)
    else
      begin
        attr.instantiate(value)
      rescue Less::Values::ValueError => e
        @__errors << e
        value
      end
    end
  end

  def valid?
    @__errors.empty?
  end

  def self.parse(params)
    params = params.clone
    attributes.each do |attr|
      params[attr.name] = attr.parse(params[attr.name])
    end

    new(params, with_exceptions: false)
  end

  def with(new_params)
    self.class.new(@__values.merge(new_params))
  end
end
