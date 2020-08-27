class LineUserSerializer < ActiveModel::Serializer
  attributes :id, :notice_time, :silent_notice

  has_one :user
end
