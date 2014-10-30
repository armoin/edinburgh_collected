module ApplicationHelper
  def active_if_controller_path(*paths)
    paths.include?(controller_path) ? "active" : nil
  end
end
