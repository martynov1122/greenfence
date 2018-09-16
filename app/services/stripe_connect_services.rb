class StripeConnectServices 
	
	def self.user_credentials code,state
		connect = UserStripeCredential.find_by_state(state)
		result = false
		if connect
		  response = RestClient.post('https://connect.stripe.com/oauth/token',{client_secret: ENV['STRIPE_CLIENT_SECRET_KEY'],code:code,grant_type:'authorization_code'})		  
		  if response.code == 200
		  	result = connect.update_attributes(JSON.parse(response).merge!(:state => nil))
		  else
		  	connect.destroy if connect.stripe_user_id.blank? && connect.state.present?
		  end
		end  
		return result
	end

	def self.deauthorize! user
		connected_user = UserStripeCredential.find_by_user_id(user)
		response = RestClient.post('https://connect.stripe.com/oauth/deauthorize',{client_id: ENV['STRIPE_CLIENT_ID'],stripe_user_id: connected_user.stripe_user_id})
		user_id = JSON.parse( response.body )['stripe_user_id']
		deauthorized if response.code == 200 && user_id == connected_user.stripe_user_id
	end

	 
end