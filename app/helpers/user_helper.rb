module UserHelper
  def greet(name)
    link_to "Welcome, #{name}", my_profile_path
  end

  def user_name_label(user)
    user.is_group? ? "Group name" : "First name"
  end

  def show_verification_warning?
    current_user && current_user.pending?
  end
end

