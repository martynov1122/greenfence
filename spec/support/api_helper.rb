module ApiHelper
  def response_json
    response.body
  end

  def sign_in(user)
    post user_session_path, user: {email: user.email, password: user.password}
    user
  end

  def sign_in_with_role role = nil, resource = nil
    user = create(:user)
    user.add_role(role, resource) if role
    sign_in(user)
  end

  def fixture_json name
    File.read(File.join(Rails.root, "spec/fixtures/json/#{name}.json"))
  end

  def access_denied_redirect_path
    "/admin"
  end
end
