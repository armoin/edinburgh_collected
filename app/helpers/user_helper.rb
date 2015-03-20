module UserHelper
  def greet(name)
    link_to "Welcome, #{name}", my_profile_path
  end

  def user_name_label(user)
    user.is_group? ? "Group name" : "First name"
  end

  def block_toggle_button_for(user)
    action = user.is_blocked? ? 'unblock' : 'block'

    link_to "#{action.capitalize} user",
      send("#{action}_admin_user_path", user),
      {
        method: :put,
        data: {confirm: 'Are you sure?'},
        class: 'button red'
      }
  end

  def user_list_button_for(user)
    path = user.is_blocked? ? blocked_admin_users_path : admin_users_path
    link_to "Back", path, class: 'button'
  end
end

