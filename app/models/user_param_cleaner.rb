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
      links_attributes: [:id, :name, :url, :_destroy]
    )
  end
end
