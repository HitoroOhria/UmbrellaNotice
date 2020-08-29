class LineUser < ApplicationRecord
  has_secure_token :auth_token
  has_secure_token :inherit_token

  belongs_to :user,    optional: true
  has_one    :weather, dependent: :destroy

  validates :line_id, uniqueness: { case_sensitive: true }

  validates :notice_time,
            format: {
              with: /\d{2}:\d{2}/,
              message: ->(obj, _data) { obj.error_msg[:NOTICE_TIME][:VALIDATE] }
            }

  validates :silent_notice,
            boolean_before_type_cast: {
              presence_only: true,
              message: ->(obj, _data) { obj.error_msg[:SILENT_NOTICE][:VALIDATE] }
            }

  def silent_notice_text
    silent_notice ? '有効' : '無効'
  end
end
