class CompanyServices < Services
  concerns Company

  def self.create user, company_params
    company = Company.new(company_params)
    raise CanCan::AccessDenied.new(access_denied_message("create")) unless user.can?(:create, company)
    return company unless company.valid?
    company.save
    Activity::CompanyCreated.construct(user, company)

    company
  end

  def self.update company, user, company_params
    if super
      Activity::CompanyUpdated.construct(user, company)
      true
    else
      false
    end
  end
end
