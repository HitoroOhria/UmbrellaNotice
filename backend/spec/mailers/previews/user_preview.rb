# Preview all emails at http://localhost/rails/mailers/user
class UserPreview < ActionMailer::Preview
  def confirmation_instructions
    user  = User.new(email: 'test@example.com', password: 'example')
    token = SecureRandom.alphanumeric

    UserMailer.confirmation_instructions(user, token)
  end

  def reset_password_instructions
    user  = User.new(email: 'test@example.com', password: 'example')
    token = SecureRandom.alphanumeric

    UserMailer.reset_password_instructions(user, token)
  end

  def unlock_instructions
    user  = User.new(email: 'test@example.com', password: 'example')
    token = SecureRandom.alphanumeric

    UserMailer.unlock_instructions(user, token)
  end

  def email_changed
    user = User.new(email: 'test@example.com', password: 'example')
    UserMailer.email_changed(user)
  end

  def password_change
    user = User.new(email: 'test@example.com', password: 'example')
    UserMailer.password_change(user)
  end
end
