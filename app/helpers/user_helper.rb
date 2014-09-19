module UserHelper
  def user_name_label(user)
    user.is_group? ? "Group name:" : "First name:"
  end
end

