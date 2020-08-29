class UserSerializer < ActiveModel::Serializer
  attributes :id, :email

  has_one :line_user
end
