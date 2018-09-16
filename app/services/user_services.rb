class UserServices < Services
  def self.update_roles updating_user, employee, parent, role_params
    find_and_remove_employee_roles employee, parent
    role_params.each do |role_name|
      employee.add_role(role_name.to_sym, parent)
    end
    Activity::RolesChanged.construct(parent, employee)
  end

  def self.remove_roles updating_user, employee, parent
    find_and_remove_employee_roles employee, parent
    Activity::RolesRemoved.construct(parent, employee)
  end

  private

  def self.find_and_remove_employee_roles employee, parent
    employee_roles = employee.roles_for(parent)
    employee_roles.each do |role|
      employee.revoke role.name, role.resource
    end
  end
end
