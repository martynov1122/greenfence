object false

child @company_permissions do
 attributes :id,:name
 node(:label) {|obj| t(obj.label)}
 node(:assigned) {|obj| @user_permissions.map(&:id).include?(obj.id) }
end