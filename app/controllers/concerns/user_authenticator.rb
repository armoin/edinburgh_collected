module UserAuthenticator
  extend ActiveSupport::Concern

  included do
    before_action :require_login
  end

  private

  def not_authenticated
    respond_to do |format|
      format.html { redirect_to signin_path, alert: "Please sign in first" }
      format.js   { render json: {error: 'You must be signed in to do this.'}, status: :forbidden }
    end
  end
end