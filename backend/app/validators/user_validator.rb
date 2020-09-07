class UserValidator < ApplicationValidator
  attr_accessor :update_flag # flag of #update.
  attr_accessor :id
  attr_accessor :email
  attr_accessor :new_email
  attr_accessor :inherit_token
  attr_accessor :embed

  validates :email,
            format: {
              with: EMAIL_REGEX,
              message: ->(obj, _data) { obj.error_msg[:EMAIL][:VALIDATE] }
            },
            presence: true

  validates :new_email,
            format: {
              with: EMAIL_REGEX,
              message: ->(obj, _data) { obj.error_msg[:NEW_EMAIL][:VALIDATE] }
            },
            if: :new_email

  validates :inherit_token,
            length: {
              is: 24,
              message: ->(obj, _data) { obj.error_msg[:INHERIT_TOKEN][:VALIDATE] }
            },
            if: :inherit_token

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
      new(params.permit(:email, :new_email, :inherit_token, :embed))
    end
  end

  def save
    user = User.new(email: email)
    user.save && user
  rescue ActiveRecord::RecordNotUnique
    add_error(:email, error_msg[:EMAIL][:EXIST])
  end

  # @return [User | NilClass] nil when record not found.
  def find_by_email
    User.find_by!(email: email)
  rescue ActiveRecord::RecordNotFound
    add_error(:email, error_msg[:EMAIL][:NOT_FOUND][email])
  end

  def update
    self.update_flag = true
    return if !(user = find_by_email) || invalid?

    user.update(update_params) ? user : fetch_errors_from(user)
  end

  def destroy
    return  unless (user = find_by_email)

    self.id = user.id
    User.destroy(user.id)
  rescue ActiveRecord::RecordNotFound
    add_error(:id, error_msg[:ID][:NOT_FOUND][id])
  end

  def relate_line_user
    return unless (user = find_by_email)

    line_user = LineUser.find_by!(inherit_token: inherit_token)
    line_user.user = user
    line_user.save!
  rescue ActiveRecord::RecordNotFound
    add_error(:inherit_token, error_msg[:INHERIT_TOKEN][:NOT_FOUND][inherit_token])
  end

  def release_line_user
    return unless (user = find_by_email)
    return unless (line_user = user.LineUser)

    line_user.user = nil
    line_user.save!
  end

  private

  # fetch errors form User when user.update.
  # @return [NilClass]
  def fetch_errors_from(record)
    record.errors.messages.each do |attr, messages|
      attr.to_sym == :email ? add_errors(:new_email, messages)
                            : add_errors(attr, messages)
    end
    nil
  end

  # @return [NilClass]
  def add_errors(attr, messages)
    messages.each do |message|
      add_error(attr, message)
    end
  end

  # toggle update attribute :new_email from :email.
  def update_params
    params = UPDATE_ATTRS[upcase_class_sym].map do |attr|
      attr.to_sym == :email ? [:email, send(:new_email)]
                            : [attr, send(attr)]
    end.to_h

    params.delete_if { |_key, value| value.nil? }
  end
end
