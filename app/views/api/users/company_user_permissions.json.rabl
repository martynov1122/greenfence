object false

child @company_permissions => "company_permissions" do
  attributes :id,:name
  node(:label) {|obj| t(obj.label)}
  node(:assigned) {|obj| @user_permissions.map(&:id).include?(obj.id) }
end
node(:can_change) { current_user.permission_changable_by?(current_user) }