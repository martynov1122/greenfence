object false
child @users => 'users' do
	attributes :id,:name,:email
end

child @custom_roles do
	attributes :id,:name,:role_on
end