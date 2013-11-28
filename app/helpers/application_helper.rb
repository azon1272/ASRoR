# encoding: utf-8
module ApplicationHelper
    def full_title(page_title)
    base_title = "Перевозимо все!"
    if page_title.empty?
      base_title
    else
      "#{base_title} | #{page_title}"
    end
  end
  # Force signout to prevent CSRF attacks
  def handle_unverified_request
    sign_out
    super
  end
end
