module ApplicationHelper

  def full_title(var_title)
    base_title = "Ruby on Rails Tutorial Sample App"
    base_title += (" | " + var_title) unless var_title.empty?
    base_title
  end
end
