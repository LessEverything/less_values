class Less::Value
  def self.attribute(name, type, opts = {})
    @attributes ||= []
    @attributes << Less::Values::Attribute.new(name, type, opts)
    attr_reader(name)
    alias_method("#{name}?".to_sym, name) if type == Less::Bool
  end

  def self.attributes
    @attributes
  end

  def initialize(opts)
    @values = {}
    self.class.attributes.each do |attr|
      option = opts[attr.name]
      value = attr.instantiate(option)
      @values[attr.name] = value
      instance_variable_set(attr.instance_attr_name, value.freeze)
    end
  end

  def self.parse(params)
    params = params.clone
    attributes.each do |attr|
      params[attr.name] = attr.parse(params[attr.name])
    end

    new(params)
  end

  def with(new_params)
    self.class.new(@values.merge(new_params))
  end
end
