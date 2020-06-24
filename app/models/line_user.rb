class LineUser < ApplicationRecord
  has_secure_token :auth_token
  has_secure_token :inherit_token

  has_one :weather, dependent: :destroy

  validates :line_id, uniqueness: true
  validates :notice_time, format: { with:    /\d{2}:\d{2}/,
                                    message: '"07:00"のような時刻表現にする必要があります' }

  delegate :user, to: :weather

  def silent_notice_text
    silent_notice ? '有効' : '無効'
  end
end
