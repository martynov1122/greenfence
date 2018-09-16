object @custom_role
	attributes :id,:name,:role_on,:company_id

child :permissions  do
  attributes :id,:name
  node(:label) {|obj| I18n.t(obj.label) }
end

child @users => "users" do
	node(:user_email) {|obj| obj.user.email }
	node(:user_id) {|obj| obj.user.id }
	node(:user_name) {|obj| obj.user.name }
	node(:entity_name) {|obj| obj.entity.name }
	attributes :id
end



