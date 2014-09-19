module ApplicationHelper
  def active_if_controller_path(path)
    controller_path == path ? "active" : nil
  end
end
