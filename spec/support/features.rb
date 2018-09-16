module Features
  def sign_in_with_role(role = nil)
    user = create(:user, role: role)
    sign_in(user)
  end

  def sign_in(user)
    page.driver.submit :delete, destroy_user_session_path, {}
    visit new_user_session_path
    find(:css, "#user_email").set(user.email)
    find(:css, "#user_password").set(user.password)
    click_button 'Login'
    user
  end

  def dashboard_path(user)
    path = if user.is_egg_role?
      [:farm_manager, user.farm]
    elsif user.is_test_role?
      [:farm_manager, user.testing_lab]
    elsif user.is_gfsi_certificate_role?
      [:gfsi, user.gfsi_certificate_company]
    else
      [:gfsi, :dashboard]
    end

    polymorphic_path(path)
  end

  def access_denied_redirect_path(user=nil)
    user ? dashboard_path(user) : "/gfsi/dashboard"
  end
end
