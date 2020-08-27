class ApplicationRecord < ActiveRecord::Base
  self.abstract_class = true

  # shorthand of ERROR_MSG[:CLASS_OF_INSTANCE].
  def error_msg
    ERROR_MSG[upcase_class_sym]
  end

  private

  # @return [Symbol] like :USER if instance of User.
  def upcase_class_sym
    self.class.name.underscore.upcase.to_sym
  end
end
