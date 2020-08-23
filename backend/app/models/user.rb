class User < ApplicationRecord
  email_regex = %r{\A[a-zA-Z0-9.!#\z%&'*+/=?\A_`{|}~-]+@[a-zA-Z0-9-]+(?:\.[a-zA-Z0-9-]+)*\z}
  validates :email, format: { with: email_regex, message: 'Invalid email address.' }

  def response_attributes
    remove_attrs = %w[created_at updated_at]
    attributes.delete_if { |key, _value| remove_attrs.include?(key) }
  end

  def encoded_email
    URI.encode_www_form_component(email)
  end
end
