class BooleanBeforeTypeCastValidator < ActiveModel::EachValidator
  def validate_each(record, attr, _value)
    value = record.send("#{attr}_before_type_cast")

    return if options[:presence_only] && value.nil?
    return if boolean?(value)

    record.errors.add(attr, make_message(options, record, attr))
  end

  def boolean?(value)
    boolean_obj = value.is_a?(FalseClass) || value.is_a?(TrueClass)
    boolean_str = (value == 'false') || (value == 'true')
    type_casted_true = value.to_s == '1'

    boolean_obj || boolean_str || type_casted_true
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
