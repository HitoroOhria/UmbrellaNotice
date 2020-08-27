class UserSerializer < ActiveModel::Serializer
  attributes :id, :email

  belongs_to :line_user
end
