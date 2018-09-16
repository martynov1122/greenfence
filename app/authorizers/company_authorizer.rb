class CompanyAuthorizer < ApplicationAuthorizer
  
  def self.creatable_by?(user)
    true
  end

  def readable_by?(user)
    true
  end

  def creatable_by?(user)
    true
  end

  def updatable_by?(user)
    user.has_role?(:user, resource) && user.permission_list(resource).include?("edit_business_profile")
  end

  def deletable_by?(user)
    user.has_role?(:user, resource) && user.permission_list(resource).include?("delete_company")
  end

  def supply_chain_viewable_by?(user)
    (user.has_role?(:user,resource) && user.permission_list(resource).include?("view_supply_chain")) 
    # || (resource.buyers.map(&:uuid).include?(user.company.uuid) && user.permission_list(nil).include?("view_supply_chain"))
  end 
  
  def supply_chain_tree_viewable_by?(user)
    user.permission_list(nil).include?('view_supply_chain')
  end
end
