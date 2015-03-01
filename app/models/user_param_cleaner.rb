class UserParamCleaner
  def self.clean(params)
    params.require(:user).permit(
      :remote_avatar_url,
      :first_name,
      :last_name,
      :screen_name,
      :is_group,
      :email,
      :password,
      :password_confirmation,
      :accepted_t_and_c,
      :description,
      image_data: [:rotation, :scale, :x, :y],
      links_attributes: [:id, :name, :url, :_destroy]
    )
  end
end
