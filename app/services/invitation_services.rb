class InvitationServices < Services
  def self.invite(inviter, inviter_resource, role, role_resource, resource_params)
    found, new_company_class = inviter.invitable_roles(inviter_resource).find_role(role)
    raise CanCan::AccessDenied, 'You cannot invite a user with this role' unless found

    new_company_name = resource_params.delete(:new_company_name)
    user = User.new(resource_params)

    # Add email error only if necessary
    user.valid?
    user.errors.clear if user.errors[:email].blank?

    if new_company_class
      company = new_company_class.new(name: new_company_name)
      # Catch company errors
      user.errors.add(:new_company_name, "can't be blank") if new_company_name.blank?
      user.errors.add(:new_company_name, "refers to a company already registered in IBMS") if Company.find_by_name(new_company_name)
    else
      company = inviter.company
    end

    # Just return the user (with errors) if email is invalid or company fails to save (when creating company)
    success = user.errors.empty?
    success &&= company.save if new_company_class
    return user unless success

    user.company = company
    user.add_role(role, role_resource || company)
    user.invite!(inviter)

    user
  end


  def self.inviteFriend(inviter, inviter_resource, role, role_resource, resource_params)
    found, new_company_class = inviter.invitable_roles(inviter_resource).find_role(role)
    raise CanCan::AccessDenied, 'You cannot invite a user with this role' unless found

    user = User.new(resource_params)

    # Add email error only if necessary
    user.valid?
    user.errors.clear if user.errors[:email].blank?

    # Just return the user (with errors) if email is invalid or company fails to save (when creating company)
    success = user.errors.empty?
    return user unless success

    user.add_role(role)
    user.invite!(inviter)

    user
  end
end
