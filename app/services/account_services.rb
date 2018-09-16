class AccountServices < Services
  def self.update user, user_params
  	if !user.nil?
      if user_params[:password].blank? && user_params[:password_confirmation].blank? && user.encrypted_password.present?
        user_params.delete(:password)
        user_params.delete(:password_confirmation)
      end

      user.update_attributes(user_params)
    else
    	user = User.create!(user_params)
    	user.save!
    end
    user
  end
end
