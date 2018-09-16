collection @roles
  attributes :id,:name
  node(:users) { |obj| obj.company_id == nil ? UsersCustomRole.users_in_system_role(obj.id,current_user.company.users.map(&:id)).count :
  UsersCustomRole.users_in_group(obj.id).count }
  node(:created_at) {|obj| obj.created_at.strftime("%m/%d/%Y")}
  node(:updated_at) {|obj| obj.updated_at.strftime("%m/%d/%Y")}