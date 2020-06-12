module UsersHelper
  def domain_url
    request.protocol + request.host
  end

  def silent_notice_mode(line_user)
    line_user.silent_notice ? '有効' : '無効'
  end
end
