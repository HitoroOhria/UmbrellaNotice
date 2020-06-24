module UsersHelper
  def domain_url
    request.protocol + request.host
  end
end
