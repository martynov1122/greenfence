class Admin::SessionsController < Devise::SessionsController
  def create
    user = User.find_by_username(params[:username])
    user.valid_password?(params[:password])
    sign_in(resource_name, user)
    respond_with user
  end
end
