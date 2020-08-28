class LineUserValidator < ApplicationValidator
  attr_accessor :update_flag # flag of #update.
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

  # validate #update.
  validate :attributes

  # --------------------  validate method  --------------------

  # error if update_params is all blank.
  def attributes
    return if update_flag.nil? || update_params.present?

    add_error(:attributes, error_msg[:ATTRIBUTES][:UPDATE_BLANK][update_attrs])
  end

  # --------------------------  end  --------------------------

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
    self.update_flag = true
    return if !(line_user = find_by_id) || invalid?

    line_user.update(update_params) ? line_user : fetch_errors_from(line_user)
  end

  def destroy
    return unless (line_user = find_by_id)

    LineUser.destroy(line_user.id)
  rescue ActiveRecord::RecordNotFound
    add_error(:id, error_msg[:ID][:NOT_FOUND][id])
  end
end
