class LineUserValidator < ApplicationValidator
  attr_accessor :acton
  attr_accessor :id
  attr_accessor :notice_time
  attr_accessor :silent_notice

  validates :id, numericality: true, presence: true

  validates :notice_time,
            format: {
              with: /\d{2}:\d{2}/,
              message: ->(obj, _date) { obj.error_msg[:NOTICE_TIME][:VALIDATE] }
            },
            if: :notice_time

  validates :silent_notice,
            inclusion: {
              in: [true, false],
              message: ->(obj, _date) { obj.error_msg[:SILENT_NOTICE][:VALIDATE] }
            },
            if: :silent_notice

  class << self
    def init_with(params)
      params = params.permit(:id, :notice_time, :silent_notice)
      params[:id] = params[:id]&.to_i
      params[:silent_notice] = change_boolean(params[:silent_notice])
      new(params)
    end

    private

    # @return [TrueClass | FalseClass | NilClass]
    def change_boolean(string)
      if string == 'true'
        true
      elsif string == 'false'
        false
      end
    end
  end

  # @return [LineUser | NilClass]
  def find_by_id
    LineUser.find(id)
  rescue ActiveRecord::RecordNotFound
    add_error(:id, error_msg[:ID][:NOT_FOUND])
  end

  def update
    return unless (line_user = find_by_id)

    if update_params
      add_error(:attributes, error_msg[:ATTRIBUTES][:UPDATE_BLANK][update_attrs])
    else
      line_user.update(update_params) ? line_user : fetch_errors_from(line_user)
    end
  end

  def destroy
    return unless (line_user = find_by_id)

    LineUser.destroy(line_user.id)
  rescue ActiveRecord::RecordNotFound
    add_error(:id, error_msg[:ID][:NOT_FOUND])
  end
end
