class LineUser < ApplicationRecord
  has_one :weather_api, dependent: :destroy

  validates :notice_time, format: { with: /\d{1,2}:\d{2}/,
                                    message: '"7:00"のような時刻表現にする必要があります' }

  def self.find_or_create(line_id)
    LineUser.find_by(line_id: line_id) || LineUser.create(line_id: line_id)
  end
end
