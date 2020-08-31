class BooleanBeforeTypeCastValidator < ActiveModel::EachValidator
  def validate_each(record, attr, _value)
    value = record.send("#{attr}_before_type_cast")

    return if presence_only_and_nil?(options, value)
    return if boolean?(value)

    record.errors.add(attr, make_message(options, record, attr))
  end

  def presence_only_and_nil?(options, value)
    options[:presence_only] && value.nil?
  end

  def boolean?(value)
    boolean_object      = value.is_a?(FalseClass) || value.is_a?(TrueClass)
    boolean_string      = (value == 'false') || (value == 'true')
    type_casted_boolean = value.to_s == '1' || value.to_s == '0'

    boolean_object || boolean_string || type_casted_boolean
  end

  def make_message(options, record, attr)
    message = options[:message]

    if message.nil?
      'need "true" or "false".'
    elsif message.is_a?(Proc)
      message.call(record, { attr => record.send(attr) })
    else
      message
    end
  end
end
