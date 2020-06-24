module ApplicationHelper
  def full_title(page_title = nil)
    base_title = 'Umbrella Notice'

    if page_title.nil?
      base_title
    else
      "#{page_title} - #{base_title}"
    end
  end
end
