class LineApi < ApplicationRecord
  belongs_to :user

  validates :notice_time, numericality: { greater_than_or_equal_to: 0, less_than_or_equal_to: 2400 }

  def self.find_or_create_line(line_id)
    LineApi.find_by(line_id: line_id) || LineApi.create(line_id: line_id)
  end
end
