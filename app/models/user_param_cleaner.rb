class UserParamCleaner
  def self.clean(params)
    params.require(:user).permit(
      :first_name,
      :last_name,
      :screen_name,
      :is_group,
      :email,
      :password,
      :password_confirmation,
      :accepted_t_and_c,
      :description,
      :image_angle,
      :image_scale,
      :image_w,
      :image_h,
      :image_x,
      :image_y,
      :remote_avatar_url,
      :moderation_reason,
      links_attributes: [:id, :name, :url, :_destroy]
    )
  end
end
