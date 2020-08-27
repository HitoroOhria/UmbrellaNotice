class LineUserValidator < ApplicationValidator
  attr_accessor :acton
  attr_accessor :id
  attr_accessor :notice_time
  attr_accessor :silent_notice
  attr_accessor :embed

  validates :id, numericality: true, presence: true

  validates :notice_time,
            format: {
              with: /\d{2}:\d{2}/,
              message: ->(obj, _date) { obj.error_msg[:NOTICE_TIME][:VALIDATE] }
            },
            if: :notice_time

  validates :silent_notice,
            inclusion: {
              in: %w[true false],
              message: ->(obj, _data) { obj.error_msg[:SILENT_NOTICE][:VALIDATE] }
            },
            if: :silent_notice

  validates :embed,
            format: { with: EMBED_REGEX, message: ERROR_MSG[:EMBED][:VALIDATE] },
            if: :embed

  class << self
    def init_with(params)
      params = params.permit(:id, :notice_time, :silent_notice, :embed)
      params[:id] = params[:id]&.to_i
      new(params)
    end
  end

  # @return [LineUser | NilClass]
  def find_by_id
    LineUser.find(id)
  rescue ActiveRecord::RecordNotFound
    add_error(:id, error_msg[:ID][:NOT_FOUND][id])
  end

  def update
    return unless (line_user = find_by_id)

    if update_params.blank?
      add_error(:attributes, error_msg[:ATTRIBUTES][:UPDATE_BLANK][update_attrs])
    else
      line_user.update(update_params) ? line_user : fetch_errors_from(line_user)
    end
  end

  def destroy
    return unless (line_user = find_by_id)

    LineUser.destroy(line_user.id)
  rescue ActiveRecord::RecordNotFound
    add_error(:id, error_msg[:ID][:NOT_FOUND][id])
  end
end
