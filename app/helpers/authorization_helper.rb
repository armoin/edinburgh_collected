module AuthorizationHelper
  def belongs_to_user?(thing)
    return false unless thing.respond_to?(:user_id)
    logged_in? && thing.user_id == current_user.try(:id)
  end

  def greet(user)
    link_to "Welcome, #{user.screen_name}", user_path(user.id)
  end
end

