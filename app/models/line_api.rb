class LineApi < ApplicationRecord
  belongs_to :user, optional: true

  validates :notice_time, format: { with: /\d{1,2}:\d{2}/,
                                    message: '"7:00"のような時刻表現にする必要があります' }

  def self.find_or_create_line(line_id)
    LineApi.find_by(line_id: line_id) || LineApi.create(line_id: line_id)
  end
end
