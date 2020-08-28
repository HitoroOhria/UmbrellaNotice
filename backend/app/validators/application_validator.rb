class ApplicationValidator
  include ActiveModel::Model

  # shorthand of ERROR_MSG[:CLASS_OF_INSTANCE].
  # about ERROR_MSG to config/initializers/error_messages.rb
  def error_msg
    ERROR_MSG[upcase_class_sym]
  end

  private

  # @return [Nil]
  def add_error(key, message)
    errors.add(key, message) && nil
  end

  # @return [Nil]
  def fetch_errors_from(record)
    record.errors.messages.each { |key, value| add_error(key, value) } && nil
  end

  # @return [Symbol] like :USER if instance of UserValidator.
  def upcase_class_sym
    self.class.name.gsub(/Validator/, '').underscore.upcase.to_sym
  end

  # shorthand of UPDATE_ATTRS[:CLASS_OF_INSTANCE].
  def update_attrs
    UPDATE_ATTRS[upcase_class_sym]
  end

  # Overwrite unless routing parameter is :id.
  # @return [Hash] attributes removed blank attribute.
  def update_params
    params = UPDATE_ATTRS[upcase_class_sym].map { |attr| [attr, send(attr)] }.to_h
    params.delete_if { |_key, value| value.nil? }
  end
end
