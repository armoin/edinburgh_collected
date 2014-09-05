module AuthorizationHelper
  def belongs_to_user?(thing)
    return false unless thing.respond_to?(:user_id)
    logged_in? && thing.user_id == current_user.try(:id)
  end

  def greet(name)
    link_to "Welcome, #{name}", my_profile_path
  end
end

